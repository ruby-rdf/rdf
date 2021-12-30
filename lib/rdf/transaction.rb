module RDF
  ##
  # An RDF transaction.
  #
  # Transactions provide an ACID scope for queries and mutations.
  #
  # Repository implementations may provide support for transactional updates
  # by providing an atomic implementation of {Mutable#apply_changeset} and 
  # responding to `#supports?(:atomic_write)` with `true`.
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
  # `#supports?(:atomic_write)` must respond `false`.
  #
  # @example Executing a read-only transaction
  #   repository = RDF::Repository.new
  #
  #   RDF::Transaction.begin(repository) do |tx|
  #     tx.query({predicate: RDF::Vocab::DOAP.developer}) do |statement|
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
  # The base class provides an atomic write implementation depending on
  # {RDF::Changeset} and using {Changeset#apply}. Custom {Repository} classes
  # can implement a minimial write-atomic transactions by overriding
  # {#apply_changeset}.
  #
  # Reads within a transaction run against the live repository by default
  # ({#isolation_level} is `:read_committed`). Repositories may provide support
  # for snapshots by implementing {Repository#snapshot} and responding `true` to
  # `#supports?(:snapshots)`. In this case, the transaction will use the 
  # {RDF::Dataset} returned by {#snapshot} for reads (`:repeatable_read`).
  #
  # For datastores that support transactions natively, implementation of a 
  # custom {Transaction} subclass is recommended. The {Repository} is 
  # responsible for specifying snapshot support and isolation level as 
  # appropriate. Note that repositories may provide the snapshot isolation level
  # without implementing {#snapshot}.
  #
  # @example A repository with a custom transaction class
  #  class MyRepository < RDF::Repository
  #    DEFAULT_TX_CLASS = MyTransaction
  #    # ...
  #    # custom repository logic
  #    # ...
  #  end
  #
  # @see RDF::Changeset
  # @see RDF::Mutable#apply_changeset
  # @since 0.3.0
  class Transaction
    include RDF::Mutable
    include RDF::Enumerable
    include RDF::Queryable

    ##
    # @see RDF::Enumerable#each
    def each(*args, &block)
      read_target.each(*args, &block)
    end

    ##
    # Executes a transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Boolean]                 mutable (false)
    #    Whether this is a read-only or read/write transaction.
    # @param  [Hash{Symbol => Object}]  options
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    # @return [void]
    def self.begin(repository, mutable: false, **options, &block)
      self.new(repository, mutable: mutable, **options, &block)
    end

    ##
    # The repository being operated upon.
    #
    # @return [RDF::Repository]
    # @since  2.0.0
    attr_reader :repository

    ##
    # The default graph name to apply to statements inserted or deleted by the
    # transaction.
    #
    # @return [RDF::Resource, nil]
    # @since  2.0.0
    attr_reader :graph_name

    ##
    # RDF statement mutations to apply when executed.
    #
    # @return [RDF::Changeset]
    # @since  2.0.0
    attr_reader :changes

    ##
    # Any additional options for this transaction.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Initializes this transaction.
    #
    # @param  [Hash{Symbol => Object}]  options
    # @param  [Boolean]                 mutable (false)
    #    Whether this is a read-only or read/write transaction.
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    def initialize(repository, graph_name: nil, mutable: false, **options, &block)
      @repository = repository
      @snapshot = 
        repository.supports?(:snapshots) ? repository.snapshot : repository
      @options    = options.dup
      @mutable    = mutable
      @graph_name = graph_name

      raise TransactionError, 
            'Tried to open a mutable transaction on an immutable repository' if
        @mutable && !@repository.mutable?

      @changes = RDF::Changeset.new
      
      if block_given?
        case block.arity
          when 1 then block.call(self)
          else self.instance_eval(&block)
        end
      end
    end
    
    ##
    # @see RDF::Dataset#isolation_level
    def isolation_level
      return :repeatable_read if repository.supports?(:snapshots)
      :read_committed
    end

    ##
    # Indicates whether the transaction includes changes relative to the target 
    # repository's state at transaction start time.
    #
    # The response is guaranteed to be `true` if executing the transaction 
    # against the original repository state would cause a change. It may also
    # return `true` in cases where the repository would not change (e.g. 
    # because the transaction would insert statements already present). 
    #
    # @note `Transaction` implementers may choose to `NotImplementedError`
    #   if the transaction implementation cannot be implemented efficiently.
    #
    # @return [Boolean] true if the transaction has mutated (insert/delete) 
    #   since transaction start time
    #
    # @raise [NotImplementedError] if a mutation check is not implemented
    def mutated?
      return !changes.empty? if self.class == Transaction

      raise NotImplementedError, 
            '#mutated? is not implemented for #{self.class}'
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
    # @overload statement?
    #   Returns `false` indicating this is not an RDF::Statemenet.
    #   @return [Boolean]
    #   @see RDF::Value#statement?
    # @overload statement?(statement)
    #   @see    RDF::Enumerable#statement?
    def statement?(*args)
      case args.length
      when 0 then false
      when 1 then read_target.statement?(*args)
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end
    alias_method :has_statement?, :statement?

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
                              'Open a new one instead.' if instance_variable_defined?(:@rolledback) && @rolledback
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
      @changes.insert(process_statement(statement))
    end

    ##
    # Appends an RDF statement to the sequence to delete when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#delete_statement
    def delete_statement(statement)
      @changes.delete(process_statement(statement))
    end

    def query_pattern(*args, &block)
      read_target.send(:query_pattern, *args, &block)
    end

    def query_execute(*args, &block)
      read_target.send(:query_execute, *args, &block)
    end
  
    undef_method :load, :update, :clear

    private
    
    ##
    # @private Adds the default graph_name to the statement, when one it does 
    #   not already have one.
    #
    # @param statement [RDF::Statement]
    # @return [RDF::Statement]
    def process_statement(statement)
      if graph_name
        statement = statement.dup
        statement.graph_name = graph_name
      end
      statement
    end
    
    def read_target
      return @snapshot if graph_name.nil?
      return @snapshot.project_graph(nil) if graph_name == false
      @snapshot.project_graph(graph_name)
    end

    public

    ##
    # A transaction with full serializability.
    # 
    # @todo refactor me!
    # @see RDF::Transaction
    class SerializedTransaction < Transaction
      ##
      # @see Transaction#initialize
      def initialize(*args, **options, &block)
        super(*args, **options, &block)
        @base_snapshot = @snapshot
      end
      
      ##
      # Inserts the statement to the transaction's working snapshot.
      #
      # @see Transaction#insert_statement
      def insert_statement(statement)
        @snapshot = @snapshot.class
          .new(data: @snapshot.send(:insert_to, 
                                    @snapshot.send(:data), 
                                    process_statement(statement)))
      end

      ##
      # Deletes the statement from the transaction's working snapshot.
      #
      # @see Transaction#insert_statement
      def delete_statement(statement)
        @snapshot = @snapshot.class
          .new(data: @snapshot.send(:delete_from, 
                                    @snapshot.send(:data), 
                                    process_statement(statement)))
      end

      ##
      # @see RDF::Dataset#isolation_level
      def isolation_level
        :serializable
      end
      
      ##
      # @note this is a simple object equality check.
      # 
      # @see RDF::Transaction#mutated?
      def mutated?
        !@snapshot.send(:data).equal?(repository.send(:data))
      end
      
      ##
      # Replaces repository data with the transaction's snapshot in a safely 
      # serializable fashion.
      # 
      # @note this transaction uses a pessimistic merge strategy which 
      #   fails the transaction if any data has changed in the repository
      #   since transaction start time. However, the specific guarantee is 
      #   softer: multiple concurrent conflicting transactions will not 
      #   succeed. We may choose to implement a less pessimistic merge 
      #   strategy as a non-breaking change.
      # 
      # @raise [TransactionError] when the transaction can't be merged.
      # @see Transaction#execute
      def execute
        raise TransactionError, 'Cannot execute a rolled back transaction. ' \
                                'Open a new one instead.' if instance_variable_defined?(:@rolledback) && @rolledback

        raise TransactionError, 'Error merging transaction. Repository' \
                                'has changed during transaction time.' unless 
          repository.send(:data).equal? @base_snapshot.send(:data)

        repository.send(:data=, @snapshot.send(:data))
      end
    end # SerializedTransaction

    ##
    # An error class for transaction failures.
    # 
    # This error indicates that the transaction semantics have been violated in 
    # some way.
    class TransactionError < RuntimeError; end
  end # Transaction
end # RDF
