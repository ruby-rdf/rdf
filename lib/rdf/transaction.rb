module RDF
  ##
  # An RDF transaction.
  #
  # Transactions provide an ACID scope for queries and mutations.
  #
  # Repository implementations may provide support for transactional updates
  # by providing an atomic implementation of {Mutable#apply_changeset} and 
  # responding to `#supports?(:transactions)` with `true`.
  # 
  # We carefully distinguish between read-only and read/write transactions,
  # in order to enable repository implementations to take out the
  # appropriate locks for concurrency control. Transactions are read-only
  # by default; mutability must be explicitly requested on construction in
  # order to obtain a read/write transaction.
  #
  # Individual repositories may make their own sets of guarantees within the 
  # transaction's scope. In case repository implementations should be unable
  # to provide full ACID guarantees for transactions, that must be clearly 
  # indicated in their documentation. If update atomicity is not provided, 
  # `#supports?(:transactions)` must respond `false`.
  #
  # @example Executing a read-only transaction
  #   repository = RDF::Repository.new
  #
  #   RDF::Transaction.begin(repository) do |tx|
  #     tx.query(predicate: RDF::Vocab::DOAP.developer) do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Executing a read/write transaction
  #   repository = RDF::Repository.new
  #
  #   RDF::Transaction.begin(repository, mutable: true) do |tx|
  #     subject = RDF::URI("http://example.org/article")
  #     tx.delete [subject, RDF::RDFS.label, "Old title"]
  #     tx.insert [subject, RDF::RDFS.label, "New title"]
  #   end
  # 
  # The base class provides a full, buffered implementation depending on 
  # `RDF::Changeset` and using `Changeset#apply`. Custom `Repositories`
  # can implement a minimial write-atomic transactions by overriding
  # `#apply_changeset`. Minimal snapshot isolation for queries can be 
  # implemented by passing a `:snapshot` to `options` on initialization.
  #
  # For datastores that support Transactions natively, it is recommended 
  # to implement a custom `Transaction` subclass, setting `@tx_class` to
  # default to that class for the `Repository`.
  #
  # @see RDF::Changeset
  # @see RDF::Mutable#apply_changeset
  # @since 0.3.0
  class Transaction
    include RDF::Mutable
    include RDF::Queryable

    extend Forwardable

    def_delegators :@snapshot, :query_pattern, :query_execute

    ##
    # Executes a transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Boolean]         :mutable (false)
    #    Whether this is a read-only or read/write transaction.
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    # @return [void]
    def self.begin(repository, options = {}, &block)
      self.new(repository, options, &block)
    end

    ##
    # The repository being operated upon.
    #
    # @return [RDF::Repository]
    # @since  2.0.0
    attr_reader :repository

    ##
    # RDF statement mutations to apply when executed.
    #
    # @return [RDF::Changeset]
    # @since  2.0.0
    attr_reader :changes

    ##
    # RDF statements to delete when executed.
    #
    # @deprecated
    # @return [RDF::Enumerable]
    attr_reader :deletes
    def deletes
      self.changes.deletes
    end

    ##
    # RDF statements to insert when executed.
    #
    # @deprecated
    # @return [RDF::Enumerable]
    attr_reader :inserts
    def inserts
      self.changes.inserts
    end

    ##
    # Any additional options for this transaction.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Initializes this transaction.
    #
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Boolean]         :mutable (false)
    #    Whether this is a read-only or read/write transaction.
    # @option options [Queryable]       :snapshot
    #    A queryable snapshot of the repository for isolated reads. Defaults to
    #    `#repository` as an unisolated query target.
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    def initialize(repository, options = {}, &block)
      @repository = repository
      @options  = options.dup
      @snapshot = @options.delete(:snapshot) { @repository }
      @mutable  = !!(@options.delete(:mutable) || false)
      
      @changes = RDF::Changeset.new
      
      if block_given?
        case block.arity
          when 1 then block.call(self)
          else self.instance_eval(&block)
        end
      end
    end

    ##
    # Determines whether the transaction's changeset is available for
    # introspection.
    #
    # If `#buffered` is `true`, `#changes` contains the current up-to-date 
    # Changeset as it would be applied on execution. This is not necessarily 
    # the case for all Transaction subclasses, which are permitted to use the
    # underlying datastore, obviating the need to track a `Changeset`. 
    #
    # Such implementations must return `false` when `#changes` is out of date.
    # They should return `true` when `#changes` has been synced to the relevant
    # transaction scope in the datastore.
    #
    # @return [Boolean]
    # @see    #changes
    # @since  2.0.0
    def buffered?
      !(self.changes.empty?)
    end

    ##
    # Returns `true` if this is a read/write transaction, `false` otherwise.
    #
    # @return [Boolean]
    # @see     RDF::Writable#writable?
    def writable?
      @mutable
    end

    ##
    # Returns `true` if this is a read/write transaction, `false` otherwise.
    #
    # @return [Boolean]
    # @see     RDF::Writable#mutable?
    def mutable?
      @mutable
    end

    ##
    # Returns `true` to indicate that this transaction is readable.
    #
    # @return [Boolean]
    # @see    RDF::Readable#readable?
    def readable?
      true
    end

    ##
    # Returns a developer-friendly representation of this transaction.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(changes: -%d/+%d)>", self.class.name,
        self.__id__, self.changes.deletes.count, self.changes.inserts.count)
    end

    ##
    # Outputs a developer-friendly representation of this transaction to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      $stderr.puts(inspect)
    end

    ##
    # Executes the transaction
    #
    # @return [Boolean] `true` if the changes are successfully applied.
    # @raise [TransactionError] if the transaction can't be applied
    def execute
      raise TransactionError, 'Cannot execute a rolled back transaction. ' \
                              'Open a new one instead.' if @rolledback
      @changes.apply(@repository)
    end

    ##
    # Rolls back the transaction
    #
    # @note: the base class simply replaces its current `Changeset` with a 
    #   fresh one. Other implementations may need to explictly rollback 
    #   at the supporting datastore.
    #
    # @note: clients should not rely on using same transaction instance after
    #   rollback.
    #
    # @return [Boolean] `true` if the changes are successfully applied.
    def rollback
      @changes = RDF::Changeset.new
      @rolledback = true
    end

    protected

    ##
    # Appends an RDF statement to the sequence to insert when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Writable#insert_statement
    def insert_statement(statement)
      @changes.insert(statement)
    end

    ##
    # Appends an RDF statement to the sequence to delete when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#delete_statement
    def delete_statement(statement)
      @changes.delete(statement)
    end

    undef_method :load, :update, :clear

    public
    
    ##
    # An error class for transaction failures.
    class TransactionError < RuntimeError; end
  end # Transaction
end # RDF
