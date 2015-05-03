module RDF
  ##
  # An RDF changeset.
  #
  # Changesets consist of a sequence of RDF statements to delete from and a
  # sequence of RDF statements to insert into a target dataset.
  #
  # @since 2.0.0
  class Changeset
    include RDF::Mutable

    ##
    # Applies a changeset to the given RDF repository.
    #
    # @param  [RDF::Repository]        repository
    # @param  [Hash{Symbol => Object}] options
    # @yield  [changes]
    # @yieldparam [RDF::Changeset] changes
    # @return [void]
    def self.apply(repository, options = {}, &block)
      self.new(&block).apply(repository, options)
    end

    ##
    # RDF statements to delete when applied.
    #
    # @return [RDF::Enumerable]
    attr_reader :deletes

    ##
    # RDF statements to insert when applied.
    #
    # @return [RDF::Enumerable]
    attr_reader :inserts

    ##
    # Any additional options for this changeset.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Initializes this changeset.
    #
    # @param  [Hash{Symbol => Object}]  options
    # @option options [RDF::Enumerable] :insert (RDF::Graph.new)
    # @option options [RDF::Enumerable] :delete (RDF::Graph.new)
    # @yield  [changes]
    # @yieldparam [RDF::Changeset] changes
    def initialize(options = {}, &block)
      @options = options.dup
      @inserts = @options.delete(:insert) || RDF::Graph.new
      @deletes = @options.delete(:delete) || RDF::Graph.new

      @inserts.extend(RDF::Enumerable) unless @inserts.kind_of?(RDF::Enumerable)
      @deletes.extend(RDF::Enumerable) unless @deletes.kind_of?(RDF::Enumerable)

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else self.instance_eval(&block)
        end
      end
    end

    ##
    # Returns `false` to indicate that this changeset is append-only.
    #
    # Changesets do not support the `RDF::Enumerable` protocol directly.
    # To enumerate the RDF statements to be inserted or deleted, use the
    # {RDF::Changeset#inserts} and {RDF::Changeset#deletes} accessors.
    #
    # @return [Boolean]
    # @see    RDF::Readable#readable?
    def readable?
      false
    end

    ##
    # Applies this changeset to the given RDF repository.
    #
    # This operation executes as a single write transaction.
    #
    # @param  [RDF::Repository]        repository
    # @param  [Hash{Symbol => Object}] options
    # @return [void]
    def apply(repository, options = {})
      repository.transaction(mutable: true) do |transaction|
        self.before_apply(transaction, options) if self.respond_to?(:before_apply)

        self.deletes.each_statement do |statement|
          transaction.delete(statement)
        end

        self.inserts.each_statement do |statement|
          transaction.insert(statement)
        end

        self.after_apply(transaction, options) if self.respond_to?(:after_apply)
      end
      self
    end

    ##
    # Returns a developer-friendly representation of this changeset.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(deletes: %d, inserts: %d)>", self.class.name,
        self.__id__, self.deletes.count, self.inserts.count)
    end

    ##
    # Outputs a developer-friendly representation of this changeset to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      $stderr.puts(self.inspect)
    end

    protected

    ##
    # Appends an RDF statement to the sequence to insert when applied.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Writable#insert_statement
    def insert_statement(statement)
      self.inserts << statement
    end

    ##
    # Appends an RDF statement to the sequence to delete when applied.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#delete_statement
    def delete_statement(statement)
      self.deletes << statement
    end

    undef_method :load, :update, :clear
  end # Changeset
end # RDF
