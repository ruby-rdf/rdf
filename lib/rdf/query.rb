module RDF
  ##
  # An RDF basic graph pattern (BGP) query.
  #
  # Named queries either match against a specifically named
  # contexts if the name is an RDF::Resource or bound RDF::Query::Variable.
  # Names that are against unbound variables match either default
  # or named contexts.
  # The name of `false` will only match against the default context.
  #
  # Variable names cause the variable to be added to the solution set
  # elements.
  #
  # @example Constructing a basic graph pattern query (1)
  #   query = RDF::Query.new do
  #     pattern [:person, RDF.type,  FOAF.Person]
  #     pattern [:person, FOAF.name, :name]
  #     pattern [:person, FOAF.mbox, :email]
  #   end
  #
  # @example Constructing a basic graph pattern query (2)
  #   query = RDF::Query.new({
  #     :person => {
  #       RDF.type  => FOAF.Person,
  #       FOAF.name => :name,
  #       FOAF.mbox => :email,
  #     }
  #   })
  #
  # @example Executing a basic graph pattern query
  #   graph = RDF::Graph.load('etc/doap.nt')
  #   query.execute(graph).each do |solution|
  #     puts solution.inspect
  #   end
  #
  # @example Constructing and executing a query in one go (1)
  #   solutions = RDF::Query.execute(graph) do
  #     pattern [:person, RDF.type, FOAF.Person]
  #   end
  #
  # @example Constructing and executing a query in one go (2)
  #   solutions = RDF::Query.execute(graph, {
  #     :person => {
  #       RDF.type => FOAF.Person,
  #     }
  #   })
  #
  # @example In this example, the default graph contains the names of the publishers of two named graphs. The triples in the named graphs are not visible in the default graph in this example.
  #   # default graph
  #   @prefix dc: <http://purl.org/dc/elements/1.1/
  #
  #   <http://example.org/bob>    dc:publisher  "Bob" .
  #   <http://example.org/alice>  dc:publisher  "Alice" .
  #
  #   # Named graph: http://example.org/bob
  #   @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  #
  #   _:a foaf:name "Bob" .
  #   _:a foaf:mbox <mailto:bob@oldcorp.example.org> .
  #
  #   # Named graph: http://example.org/alice
  #   @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  #
  #   _:a foaf:name "Alice" .
  #   _:a foaf:mbox <mailto:alice@work.example.org> .
  #
  # @see http://www.w3.org/TR/rdf-sparql-query/#rdfDataset
  # @since 0.3.0
  class Query
    include Enumerable
    autoload :Pattern,   'rdf/query/pattern'
    autoload :Solution,  'rdf/query/solution'
    autoload :Solutions, 'rdf/query/solutions'
    autoload :Variable,  'rdf/query/variable'
    autoload :HashPatternNormalizer, 'rdf/query/hash_pattern_normalizer'

    ##
    # Executes a query on the given `queryable` graph or repository.
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Object => Object}] patterns
    #   optional hash patterns to initialize the query with
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options (see {RDF::Query#initialize})
    # @yield  [query]
    # @yieldparam  [RDF::Query] query
    # @yieldreturn [void] ignored
    # @return [RDF::Query::Solutions]
    #   the resulting solution sequence
    # @see    RDF::Query#execute
    def self.execute(queryable, patterns = {}, options = {}, &block)
      self.new(patterns, options, &block).execute(queryable, options)
    end

    ##
    # Cast values as Solutions
    # @overload Solutions()
    #   @return [Solutions] returns Solutions.new()
    #
    # @overload Solutions(solutions)
    #   @return [Solutions] returns the argument
    #
    # @overload Solutions(array)
    #   @param [Array] array
    #   @return [Solutions] returns the array extended with solutions
    #
    # @overload Solutions(*args)
    #   @param [Array<Solution>] args
    #   @return [Solutions] returns new solutions including the arguments, which must each be a {Solution}
    def self.Solutions(*args)
      return args.first if args.length == 1 && args.first.is_a?(Solutions)
      args = args.first if args.first.is_a?(Array) && args.length == 1
      return Solutions.new(args)
    end

    ##
    # The variables used in this query.
    #
    # @return [Hash{Symbol => RDF::Query::Variable}]
    attr_reader :variables

    ##
    # The patterns that constitute this query.
    #
    # @return [Array<RDF::Query::Pattern>]
    attr_reader :patterns

    ##
    # The solution sequence for this query.
    #
    # @return [RDF::Query::Solutions]
    attr_reader :solutions

    ##
    # Any additional options for this query.
    #
    # @return [Hash]
    attr_reader :options

    ##
    # Initializes a new basic graph pattern query.
    #
    # @overload initialize(patterns = [], options = {})
    #   @param  [Array<RDF::Query::Pattern>] patterns
    #     ...
    #   @param  [Hash{Symbol => Object}] options
    #     any additional keyword options
    #   @option options [RDF::Query::Solutions] :solutions (Solutions.new)
    #   @option options [RDF::Resource, RDF::Query::Variable, false] :context (nil)
    #     Default context for matching against queryable.
    #     Named queries either match against a specifically named
    #     graphs if the name is an {RDF::Resource} or bound {RDF::Query::Variable}.
    #     Names that are against unbound variables match either default
    #     or named graphs.
    #     The name of `false` will only match against the default context.
    #   @option options [RDF::Resource, RDF::Query::Variable, false] :name (nil)
    #     Alias for `:context`.
    #   @yield  [query]
    #   @yieldparam  [RDF::Query] query
    #   @yieldreturn [void] ignored
    #
    # @overload initialize(patterns, options = {})
    #   @param  [Hash{Object => Object}] patterns
    #     ...
    #   @param  [Hash{Symbol => Object}] options
    #     any additional keyword options
    #   @option options [RDF::Query::Solutions] :solutions (Solutions.new)
    #   @option options [RDF::Resource, RDF::Query::Variable, false] :context (nil)
    #     Default context for matching against queryable.
    #     Named queries either match against a specifically named
    #     graphs if the name is an {RDF::Resource} or bound {RDF::Query::Variable}.
    #     Names that are against unbound variables match either default
    #     or named graphs.
    #   @option options [RDF::Resource, RDF::Query::Variable, false] :name (nil)
    #     Alias for `:context`.
    #   @yield  [query]
    #   @yieldparam  [RDF::Query] query
    #   @yieldreturn [void] ignored
    def initialize(*patterns, &block)
      @options  = patterns.last.is_a?(Hash) ? patterns.pop.dup : {}
      patterns << @options if patterns.empty?
      @variables = {}
      @solutions = Query::Solutions(@options.delete(:solutions))
      context = @options.fetch(:context, @options.fetch(:name, nil))
      @options.delete(:context)
      @options.delete(:name)

      @patterns  = case patterns.first
        when Hash  then compile_hash_patterns(HashPatternNormalizer.normalize!(patterns.first.dup, @options))
        when Array then patterns.first
        else patterns
      end

      self.context = context

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Appends the given query `pattern` to this query.
    #
    # @param  [RDF::Query::Pattern] pattern
    #   a triple query pattern
    # @return [void] self
    def <<(pattern)
      @patterns << Pattern.from(pattern)
      self
    end

    ##
    # Appends the given query `pattern` to this query.
    #
    # @param  [RDF::Query::Pattern] pattern
    #   a triple query pattern
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options
    # @option options [Boolean] :optional (false)
    #   whether this is an optional pattern
    # @return [void] self
    def pattern(pattern, options = {})
      @patterns << Pattern.from(pattern, options)
      self
    end

    ##
    # Returns an optimized copy of this query.
    #
    # @param  [Hash{Symbol => Object}] options
    #   any additional options for optimization
    # @return [RDF::Query] a copy of `self`
    # @since  0.3.0
    def optimize(options = {})
      self.dup.optimize!(options)
    end

    ##
    # Optimizes this query by reordering its constituent triple patterns
    # according to their cost estimates.
    #
    # @param  [Hash{Symbol => Object}] options
    #   any additional options for optimization
    # @return [void] `self`
    # @see    RDF::Query::Pattern#cost
    # @since  0.3.0
    def optimize!(options = {})
      @patterns.sort! do |a, b|
        (a.cost || 0) <=> (b.cost || 0)
      end
      self
    end

    ##
    # Executes this query on the given `queryable` graph or repository.
    #
    # Named queries either match against a specifically named
    # contexts if the name is an RDF::Resource or bound RDF::Query::Variable.
    # Names that are against unbound variables match either detault
    # or named contexts.
    # The name of `false` will only match against the default context.
    #
    # If the query nas no patterns, it returns a single empty solution as
    # per SPARQL 1.1 _Empty Group Pattern_.
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options
    # @option options [Hash{Symbol => RDF::Term}] bindings
    #   optional variable bindings to use
    # @option options [RDF::Resource, RDF::Query::Variable, false] context (nil)
    #   Specific context for matching against queryable;
    #   overrides default context defined on query.
    # @option options [RDF::Resource, RDF::Query::Variable, false] name (nil)
    #   Alias for `:context`.
    # @option options [RDF::Query::Solutions] solutions
    #   optional initial solutions for chained queries
    # @yield  [solution]
    #   each matching solution
    # @yieldparam  [RDF::Query::Solution] solution
    # @yieldreturn [void] ignored
    # @return [RDF::Query::Solutions]
    #   the resulting solution sequence
    # @see    http://www.holygoat.co.uk/blog/entry/2005-10-25-1
    # @see    http://www.w3.org/TR/sparql11-query/#emptyGroupPattern
    def execute(queryable, options = {}, &block)
      validate!
      options = options.dup

      # just so we can call #keys below without worrying
      options[:bindings] ||= {}

      # Use provided solutions to allow for query chaining
      # Otherwise, a quick empty solution simplifies the logic below; no special case for
      # the first pattern
      @solutions = Query::Solutions(options[:solutions] || Solution.new)

      # If there are no patterns, just return the empty solution
      if empty?
        @solutions.each(&block) if block_given?
        return @solutions
      end

      patterns = @patterns
      context = options.fetch(:context, options.fetch(:name, self.context))

      # Add context to pattern, if necessary
      unless context.nil?
        if patterns.empty?
          patterns = [Pattern.new(nil, nil, nil, :context => context)]
        else
          apply_context(context)
        end
      end

      patterns.each do |pattern|

        old_solutions, @solutions = @solutions, Query::Solutions()

        options[:bindings].keys.each do |variable|
          if pattern.variables.include?(variable)
            unbound_solutions, old_solutions = old_solutions, Query::Solutions()
            options[:bindings][variable].each do |binding|
              unbound_solutions.each do |solution|
                old_solutions << solution.merge(variable => binding)
              end
            end
            options[:bindings].delete(variable)
          end
        end

        old_solutions.each do |solution|
          found_match = false
          pattern.execute(queryable, solution) do |statement|
            found_match = true
            @solutions << solution.merge(pattern.solution(statement))
          end
          # If this pattern was optional, and we didn't find any matches,
          # just copy it over as-is.
          if !found_match && pattern.optional?
            @solutions << solution
          end
        end

        #puts "solutions after #{pattern} are #{@solutions.to_a.inspect}"

        # It's important to abort failed queries quickly because later patterns
        # that can have constraints are often broad without them.
        # We have no solutions at all:
        return @solutions if @solutions.empty?

        if !pattern.optional?
          # We have no solutions for variables we should have solutions for:
          need_vars = pattern.variables.keys
          @solutions.each do |solution|
            break if need_vars.empty?
            need_vars -= solution.bindings.keys
          end
          return Query::Solutions() unless need_vars.empty?
        end
      end
      @solutions.each(&block) if block_given?
      @solutions
    end

    ##
    # Returns `true` if this query did not match when last executed.
    #
    # When the solution sequence is empty, this method can be used to
    # determine whether the query failed to match or not.
    #
    # @return [Boolean]
    # @see    #matched?
    def failed?
      @solutions.empty?
    end

    ##
    # Returns `true` if this query matched when last executed.
    #
    # When the solution sequence is empty, this method can be used to
    # determine whether the query matched successfully or not.
    #
    # @return [Boolean]
    # @see    #failed?
    def matched?
      !failed?
    end

    # Add patterns from another query to form a new Query
    # @param [RDF::Query] other
    # @return [RDF::Query]
    def +(other)
      Query.new(self.patterns + other.patterns)
    end
    
    # Is this query scoped to a named graph?
    # @return [Boolean]
    def named?
      !!options[:context]
    end
    
    # Is this query scoped to the default graph?
    # @return [Boolean]
    def default?
      options[:context] == false
    end
    
    # Is this query unscoped? This indicates that it can return results from
    # either a named graph or the default graph.
    # @return [Boolean]
    def unnamed?
      options[:context].nil?
    end
    
    # Scope the query to named graphs matching value
    # @param [RDF::IRI, RDF::Query::Variable] value
    # @return [RDF::IRI, RDF::Query::Variable]
    def context=(value)
      options[:context] = value
    end
    
    # Scope of this query, if any
    # @return [RDF::IRI, RDF::Query::Variable]
    def context
      options[:context]
    end

    # Apply the context specified (or configured) to all patterns that have no context
    # @param [RDF::IRI, RDF::Query::Variable] context (self.context)
    def apply_context(context = options[:context])
      patterns.each {|pattern| pattern.context = context if pattern.context.nil?} unless context.nil?
    end

    ##
    # Returns `true` if any pattern contains a variable.
    #
    # @return [Boolean]
    def variable?
      patterns.any?(&:variable?) || context && context.variable?
    end

    ##
    # Returns `true` if any pattern contains a blank node.
    #
    # @return [Boolean]
    def has_blank_nodes?
      patterns.any?(&:has_blank_nodes?) || context && context.node?
    end

    # Query has no patterns
    # @return [Boolean]
    def empty?
      patterns.empty?
    end

    ##
    # Enumerates over each matching query solution.
    #
    # @yield  [solution]
    # @yieldparam [RDF::Query::Solution] solution
    # @return [Enumerator]
    def each_solution(&block)
      @solutions.each(&block)
    end
    alias_method :each, :each_solution

    ##
    # Enumerates over each statement (pattern).
    #
    # @yield  [RDF::Query::Pattern]
    # @yieldparam [::Query::Pattern] pattern
    # @return [Enumerator]
    def each_statement(&block)
      apply_context
      patterns.each(&block)
    end

    ##
    # Duplicate query, including patterns and solutions
    # @return [RDF::Query]
    def dup
      patterns = @patterns.map {|p| p.dup}
      patterns << @options.merge(:solutions => @solutions.dup)
      Query.new(*patterns)
    end

    ##
    # Determine if the URI is a valid according to RFC3987
    #
    # @return [Boolean] `true` or `false`
    # @since 0.3.9
    def valid?
      !!validate!
    rescue
      false
    end

    ##
    # Validate this query, making sure it can be executed by our query engine.
    # This method is public so that it may be called by implementations of
    # RDF::Queryable#query_execute that bypass our built-in query engine.
    #
    # @return [RDF::Query] `self`
    # @raise [ArgumentError] This query cannot be executed.
    def validate!
      # All patterns must be valid
      @patterns.each(&:validate!)

      # All optional patterns must appear after the regular patterns.
      if i = @patterns.find_index(&:optional?)
        unless @patterns[i..-1].all?(&:optional?)
          raise ArgumentError.new("Optional patterns must appear at end of query")
        end
      end

      self
    end

  protected

    ##
    # @private
    def compile_hash_patterns(hash_patterns)
      patterns = []
      hash_patterns.each do |s, pos|
        raise ArgumentError, "invalid hash pattern: #{hash_patterns.inspect}" unless pos.is_a?(Hash)
        pos.each do |p, os|
          case os
            when Hash
              patterns += os.keys.map { |o| [s, p, o] }
              patterns += compile_hash_patterns(os)
            when Array
              patterns += os.map { |o| [s, p, o] }
            else
              patterns << [s, p, os]
          end
        end
      end
      patterns.map { |pattern| Pattern.from(pattern) }
    end
  end # Query
end # RDF
