module RDF
  ##
  # An RDF basic graph pattern (BGP) query.
  #
  # @example Constructing a basic graph pattern query
  #   query = RDF::Query.new do
  #     pattern [:person, RDF.type, RDF::FOAF.Person]
  #     pattern [:person, RDF::FOAF.name, :name]
  #     pattern [:person, RDF::FOAF.mbox, :email], :optional => true
  #   end
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
    # Initializes a new query.
    #
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options
    # @option options [Array<RDF::Query::Pattern>] :patterns  (Array.new)
    # @option options [RDF::Query::Solutions]      :solutions (Solutions.new)
    # @yield  [query]
    # @yieldparam [RDF::Query] query
    def initialize(options = {}, &block)
      @options   = options.dup
      @variables = @options.delete(:variables) || {}
      @patterns  = @options.delete(:patterns)  || []
      @solutions = @options.delete(:solutions) || Solutions.new

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
      # TODO: handle any given additional options
      @patterns << Pattern.from(pattern)
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

            when @solutions.all? { |solution| !solution.has_variables?(pattern.variables.values) }
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
                @solutions[index] = nil if failed # TODO: `options[:optional]`
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
  end # Query
end # RDF
