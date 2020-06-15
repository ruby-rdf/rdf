module RDF
  ##
  # An RDF changeset that can be applied to an {RDF::Mutable}.
  #
  # Changesets consist of a sequence of RDF statements to delete from and a
  # sequence of RDF statements to insert into a target dataset. 
  # 
  # @example Applying a Changeset with block syntax
  #   graph = RDF::Graph.new
  #   graph << [RDF::URI('s_del'), RDF::URI('p_del'), RDF::URI('o_del')]
  #
  #   RDF::Changeset.apply(graph) do |c|
  #     c.insert [RDF::URI('s1'), RDF::URI('p1'), RDF::URI('o1')]
  #     c.insert [RDF::URI('s2'), RDF::URI('p2'), RDF::URI('o2')]
  #     c.delete [RDF::URI('s_del'), RDF::URI('p_del'), RDF::URI('o_del')]
  #   end
  #
  # @example Defining a changeset for later application to a Mutable
  #   changes = RDF::Changeset.new do |c|
  #     c.insert [RDF::URI('s1'), RDF::URI('p1'), RDF::URI('o1')]
  #     c.insert [RDF::URI('s2'), RDF::URI('p2'), RDF::URI('o2')]
  #     c.delete [RDF::URI('s_del'), RDF::URI('p_del'), RDF::URI('o_del')]
  #   end
  #
  #   graph = RDF::Graph.new
  #   graph << [RDF::URI('s_del'), RDF::URI('p_del'), RDF::URI('o_del')]
  # 
  #   changes.apply(graph) # or graph.apply_changeset(changes)
  #
  # @note When applying a Changeset, deletes are resolved before inserts.
  #
  # @since 2.0.0
  class Changeset
    # include RDF::Mutable
    include RDF::Util::Coercions

    ##
    # Applies a changeset to the given {RDF::Mutable} object.
    #
    # @param  [RDF::Mutable] mutable
    # @param  [Hash{Symbol => Object}] options
    # @yield  [changes]
    # @yieldparam [RDF::Changeset] changes
    # @return [void]
    def self.apply(mutable, **options, &block)
      self.new(&block).apply(mutable, **options)
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
    # @param [RDF::Enumerable] insert (RDF::Graph.new)
    # @param [RDF::Enumerable] delete (RDF::Graph.new)
    # @yield  [changes]
    # @yieldparam [RDF::Changeset] changes
    def initialize(insert: [], delete: [], &block)
      @inserts = insert
      @deletes = delete

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
    # Returns `false` as changesets are not {RDF::Writable}.
    #
    # @return [Boolean]
    # @see    RDF::Writable#writable?
    def writable?
      false
    end

    ##
    # Returns `false` as changesets are not {RDF::Mutable}.
    #
    # @return [Boolean]
    # @see    RDF::Mutable#mutable?
    def mutable?
      false
    end

    ##
    # Applies this changeset to the given mutable RDF::Enumerable.
    #
    # This operation executes as a single write transaction.
    #
    # @param  [RDF::Mutable] mutable
    # @param  [Hash{Symbol => Object}] options
    # @return [void]
    def apply(mutable, **options)
      mutable.apply_changeset(self)
    end

    ##
    # @return [Boolean] `true` iff inserts and deletes are both empty
    def empty?
      deletes.empty? && inserts.empty?
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
    # `$stderr`.
    #
    # @return [void]
    def inspect!
      $stderr.puts(self.inspect)
    end

    ##
    # Returns the sum of both the `inserts` and `deletes` counts.
    #
    # @return [Integer]
    def count
      inserts.count + deletes.count
    end

    # Append statements to `inserts`. Statements _should_ be constant
    # as variable statements will at best be ignored or at worst raise
    # an error when applied.
    #
    # @param statements [Enumerable, RDF::Statement] Some statements
    # @return [self]
    def insert(*statements)
      coerce_statements(statements) do |stmts|
        append_statements :inserts, stmts
      end

      self
    end
    alias_method :insert!, :insert
    alias_method :<<, :insert

    # Append statements to `deletes`. Statements _may_ contain
    # variables, although support will depend on the {RDF::Mutable}
    # target.
    #
    # @param statements [Enumerable, RDF::Statement] Some statements
    # @return [self]
    def delete(*statements)
      coerce_statements(statements) do |stmts|
        append_statements :deletes, stmts
      end

      self
    end
    alias_method :delete!, :delete
    alias_method :>>, :delete

    private

    ##
    # Append statements to the appropriate target. This is a little
    # shim to go in between the other shim and the target.
    #
    # @param target [Symbol] the method to send
    # @param arg [Enumerable, RDF::Statement]
    #
    def append_statements(target, arg)
      # coerce to an enumerator 
      stmts = case
              when arg.is_a?(RDF::Statement)
                [arg]
              when arg.respond_to?(:each_statement)
                arg.each_statement
              when arg.respond_to?(:each)
                arg
              else
                raise ArgumentError, "Invalid statement: #{arg.class}"
              end

      stmts.each { |s| send(target) << s }
    end

    # This simply returns its argument as a query in order to trick
    # {RDF::Mutable#delete} into working.
    def query(stmt)
      RDF::Query.new RDF::Query::Pattern.from(stmt)
    end

    undef_method :load
  end # Changeset
end # RDF
