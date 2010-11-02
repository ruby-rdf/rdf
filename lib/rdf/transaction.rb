module RDF
  ##
  # An RDF transaction.
  #
  # Transactions consist of a sequence of RDF statements to delete from and
  # a sequence of RDF statements to insert into a given named graph.
  #
  # @example Executing a transaction against a repository
  #   repository = ...
  #   RDF::Transaction.execute(repository) do |tx|
  #     subject = RDF::URI("http://example.org/article")
  #     tx.delete [subject, RDF::DC.title, "Old title"]
  #     tx.insert [subject, RDF::DC.title, "New title"]
  #   end
  #
  # @since 0.3.0
  class Transaction
    include RDF::Mutable

    ##
    # Executes a transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Hash{Symbol => Object}]  options
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    # @return [void]
    def self.execute(repository, options = {}, &block)
      self.new(&block).execute(repository, options)
    end

    ##
    # RDF graph to modify when executed.
    #
    # @return [RDF::Resource]
    attr_reader :graph

    ##
    # RDF statements to delete when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :deletes

    ##
    # RDF statements to insert when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :inserts

    ##
    # Any additional options for this transaction.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Initializes this transaction.
    #
    # @param  [Hash{Symbol => Object}]  options
    # @option options [RDF::Resource]   :graph  (nil)
    # @option options [RDF::Enumerable] :insert (RDF::Graph.new)
    # @option options [RDF::Enumerable] :delete (RDF::Graph.new)
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    def initialize(options = {}, &block)
      @options = options.dup
      @graph   = @options.delete(:graph)  || @options.delete(:context)
      @inserts = @options.delete(:insert) || RDF::Graph.new
      @deletes = @options.delete(:delete) || RDF::Graph.new
      @inserts.extend(RDF::Enumerable) unless @inserts.kind_of?(RDF::Enumerable)
      @deletes.extend(RDF::Enumerable) unless @deletes.kind_of?(RDF::Enumerable)

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `false` to indicate that this transaction is append-only.
    #
    # Transactions do not support the `RDF::Enumerable` protocol directly.
    # To enumerate the RDF statements to be inserted or deleted, use the
    # {#inserts} and {#deletes} accessors.
    #
    # @return [Boolean]
    # @see    RDF::Readable#readable?
    def readable?
      false
    end

    ##
    # Executes this transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Hash{Symbol => Object}]  options
    # @return [void]
    def execute(repository, options = {})
      before_execute(repository, options) if respond_to?(:before_execute)

      deletes.each_statement do |statement|
        statement = statement.dup
        statement.context = graph
        repository.delete(statement)
      end

      inserts.each_statement do |statement|
        statement = statement.dup
        statement.context = graph
        repository.insert(statement)
      end

      after_execute(repository, options) if respond_to?(:after_execute)
      self
    end

    ##
    # Returns a developer-friendly representation of this transaction.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(graph: %s, deletes: %d, inserts: %d)>", self.class.name, __id__,
        graph ? graph.to_s : 'nil', deletes.count, inserts.count)
    end

    ##
    # Outputs a developer-friendly representation of this transaction to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      warn(inspect)
    end

    ##
    # Appends an RDF statement to the sequence to insert when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Writable#insert_statement
    def insert_statement(statement)
      inserts << statement
    end

    ##
    # Appends an RDF statement to the sequence to delete when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#delete_statement
    def delete_statement(statement)
      deletes << statement
    end

    undef_method :load, :update, :clear
    protected :insert_statement
    protected :delete_statement
  end # Transaction
end # RDF
