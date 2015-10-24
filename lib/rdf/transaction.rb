module RDF
  ##
  # An RDF transaction.
  #
  # Transactions consist of a sequence of RDF statements to delete from and
  # a sequence of RDF statements to insert into a given named graph.
  #
  # Repository implementations may choose to sub-class this class
  # to provide transactional support for repository updates, when
  # accessed through {RDF::Repository#begin_transaction}.
  #
  # @example Executing a transaction against a repository
  #   repository = ...
  #   RDF::Transaction.execute(repository) do |tx|
  #     subject = RDF::URI("http://example.org/article")
  #     tx.delete [subject, RDF::RDFS.label, "Old title"]
  #     tx.insert [subject, RDF::RDFS.label, "New title"]
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
    # Name of this graph, if it is part of an {RDF::Repository}
    # @!attribute [rw] graph_name
    # @return [RDF::Resource]
    # @since 1.1.0
    attr_accessor :graph_name

    # @deprecated Use {#graph_name} instead.
    def context
      warn "[DEPRECATION] Statement#context is being replaced with Statement@graph_name in RDF.rb 2.0. Called from #{Gem.location_of_caller.join(':')}"
	  graph_name
    end

    # @deprecated Use {#graph_name=} instead.
    def context=(value)
      warn "[DEPRECATION] Statement#context= is being replaced with Statement@graph_name= in RDF.rb 2.0. Called from #{Gem.location_of_caller.join(':')}"
	  self.graph_name = value
    end

    alias_method :graph, :graph_name
    alias_method :graph=, :graph_name=

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
    # @option options [RDF::Resource]   :context  (nil)
    #   Alias for `:graph_name`. Deprected in RDF.rb 2.0.
    # @option options [RDF::Resource]   :graph_name (nil)
    #   Name of named graph to be affected if `inserts` or `deletes`
    #   do not have a `graph_name`.
    # @option options [RDF::Resource]   :graph  (nil)
    #   Alias for `:graph_name`.
    # @option options [RDF::Enumerable] :insert (RDF::Graph.new)
    # @option options [RDF::Enumerable] :delete (RDF::Graph.new)
    # @yield  [tx]
    # @yieldparam [RDF::Transaction] tx
    def initialize(options = {}, &block)
      @options = options.dup
      if @options.has_key?(:context)
        warn "[DEPRECATION] the :contexts option to Mutable#load is deprecated in RDF.rb 2.0, use :graph_name instead. Called from #{Gem.location_of_caller.join(':')}"
        @options[:graph_name] ||= @options.delete(:context)
      end
      @graph_name = @options.delete(:graph) || @options.delete(:graph_name)
      @inserts = @options.delete(:insert)   || []
      @deletes = @options.delete(:delete)   || []
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
    # {RDF::Transaction#inserts} and {RDF::Transaction#deletes} accessors.
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
        statement.graph_name ||= graph_name
        repository.delete(statement)
      end

      inserts.each_statement do |statement|
        statement = statement.dup
        statement.graph_name ||= graph_name
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

    protected
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
  end # Transaction
end # RDF
