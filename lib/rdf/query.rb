module RDF
  ##
  # An RDF basic graph pattern (BGP) query.
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
  #     solution.inspect
  #   end
  #
  # @since 0.3.0
  class Query
    autoload :Pattern,   'rdf/query/pattern'
    autoload :Solution,  'rdf/query/solution'
    autoload :Solutions, 'rdf/query/solutions'
    autoload :Variable,  'rdf/query/variable'

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
    #   @yield  [query]
    #   @yieldparam  [RDF::Query] query
    #   @yieldreturn [void] ignored
    def initialize(patterns = nil, options = {}, &block)
      @options   = options.dup
      @variables = {}
      @solutions = @options.delete(:solutions) || Solutions.new

      @patterns  = case patterns
        when Hash  then compile_hash_patterns(patterns.dup)
        when Array then patterns
        else []
      end

      if block_given?
        case block.arity
          when 0 then instance_eval(&block)
          else block.call(self)
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
    # Executes this query on the given `queryable` graph or repository.
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options
    # @return [RDF::Query::Solutions]
    #   the resulting solution sequence
    # @see    http://www.holygoat.co.uk/blog/entry/2005-10-25-1
    def execute(queryable, options = {})
      @solutions = Solutions.new
      @failed = false
      @patterns.each do |pattern|
        case pattern.variable_count
          when 0 # no variables
            if pattern.execute(queryable).empty?
              # return an empty solution sequence:
              @solutions.clear
              @failed = true
              break
            end

          when 3 # only variables
            pattern.execute(queryable) do |statement|
              @solutions << pattern.solution(statement)
            end

          else case # 1 or 2 variables

            when !@solutions.have_variables?(pattern.variables.values)
              if @solutions.empty?
                pattern.execute(queryable) do |statement|
                  @solutions << pattern.solution(statement)
                end
              else # union
                old_solutions, @solutions = @solutions, Solutions.new
                old_solutions.each do |solution|
                  pattern.execute(queryable) do |statement|
                    @solutions << solution.merge(pattern.solution(statement))
                  end
                end
              end

            else # intersection
              @solutions.each_with_index do |solution, index|
                failed = true
                pattern.execute(queryable, solution) do |statement|
                  failed = false
                  solution.merge!(pattern.solution(statement))
                end
                @solutions[index] = nil if failed && !pattern.optional?
              end
              @solutions.compact! # remove `nil` entries
          end
        end
      end
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
      @failed
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
      !@failed
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
