module RDF
  ##
  # An RDF basic graph pattern query.
  #
  # @example Filtering solutions using a hash
  #   query.filter(:author  => RDF::URI.new("http://ar.to/#self"))
  #   query.filter(:author  => "Arto Bendiken")
  #   query.filter(:author  => [RDF::URI.new("http://ar.to/#self"), "Arto Bendiken"])
  #   query.filter(:updated => RDF::Literal.new(Date.today))
  #
  # @example Filtering solutions using a block
  #   query.filter { |solution| solution.author.literal? }
  #   query.filter { |solution| solution.title =~ /^SPARQL/ }
  #   query.filter { |solution| solution.price < 30.5 }
  #   query.filter { |solution| solution.bound?(:date) }
  #   query.filter { |solution| solution.age.datatype == RDF::XSD.integer }
  #   query.filter { |solution| solution.name.language == :es }
  #
  # @example Reordering solutions based on a variable
  #   query.order_by(:updated)
  #   query.order_by(:updated, :created)
  #
  # @example Selecting particular variables only
  #   query.select(:title)
  #   query.select(:title, :description)
  #
  # @example Eliminating duplicate solutions
  #   query.distinct!
  #
  # @example Limiting the number of solutions
  #   query.offset(25).limit(10)
  #
  # @example Counting the number of solutions
  #   query.count
  #
  # @example Iterating over all found solutions
  #   query.each_solution { |solution| puts solution.inspect }
  #
  class Query
    autoload :Pattern,  'rdf/query/pattern'
    autoload :Solution, 'rdf/query/solution'
    autoload :Variable, 'rdf/query/variable'

    include ::Enumerable

    # @return [Hash{Symbol => RDF::Query::Variable}]
    attr_reader :variables

    # @return [Array<RDF::Query::Pattern>]
    attr_reader :patterns

    # @return [Array<Hash{Symbol => RDF::Value}>] An unordered sequence of query solutions.
    attr_accessor :solutions

    # @return [Hash]
    attr_reader :options

    ##
    # @param  [Hash{Symbol => Object}] options
    # @yield  [query]
    # @yieldparam [Query]
    def initialize(options = {}, &block)
      @options   = options.dup
      @variables = @options.delete(:variables) || {}
      @patterns  = @options.delete(:patterns)  || []
      @solutions = @options.delete(:solutions) || []

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Inserts a new query `pattern` into this query.
    #
    # @param  [RDF::Query::Pattern] pattern
    # @return [void] self
    def <<(pattern)
      self.patterns << Pattern.from(pattern)
      self
    end

    ##
    # Executes this query on the given `queryable` object.
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Symbol => Object}] options
    #   any additional keyword options
    # @return [Array]
    #   the query solution sequence
    def execute(queryable, options = {})
      self.solutions = []
      patterns.each do |pattern|
        case pattern.variable_count
          when 0 # no variables
            if pattern.execute(queryable).empty?
              # return an empty solution sequence:
              self.solutions.clear
              break
            end

          when 3 # only variables
            pattern.execute(queryable) do |statement|
              self.solutions << pattern.solution(statement)
            end

          else case # 1 or 2 variables

            when self.solutions.all? { |solution| !solution.has_variables?(pattern.variables.values) }
              pattern.execute(queryable) do |statement|
                self.solutions << pattern.solution(statement)
              end

            else
              self.solutions.each_with_index do |solution, index|
                failed = true
                pattern.execute(queryable, solution) do |statement|
                  failed = false
                  solution.merge!(pattern.solution(statement))
                end
                self.solutions[index] = nil if failed
              end
              self.solutions.compact! # remove `nil` entries
          end
        end
      end
      self.solutions
    end

    ##
    # Enumerates over each query solution.
    #
    # @yield  [solution]
    # @yieldparam [Solution] solution
    # @return [Enumerator]
    def each_solution(&block)
      unless block_given?
        enum_for(:each_solution)
      else
        solutions.each do |solution|
          block.call(solution.is_a?(Solution) ? solution : Solution.new(solution))
        end
      end
    end
    alias_method :each, :each_solution

    ##
    # Returns the number of query solutions.
    #
    # @return [Integer]
    def count
      solutions.size
    end
    alias_method :size, :count

    ##
    # Filters the solution sequence by the given criteria.
    #
    # @param  [Hash{Symbol => Object}] criteria
    # @yield  [solution]
    # @yieldparam  [Solution] solution
    # @yieldreturn [Boolean]
    # @return [Query]
    def filter(criteria = {}, &block)
      if block_given?
        solutions.reject! do |solution|
          !block.call(solution.is_a?(Solution) ? solution : Solution.new(solution))
        end
      else
        solutions.reject! do |solution|
          solution = solution.is_a?(Solution) ? solution : Solution.new(solution)
          results = criteria.map do |name, value|
            solution[name] == value
          end
          !results.all?
        end
      end
      self
    end
    alias_method :filter!, :filter

    ##
    # Reorders the solution sequence based on `variables`.
    #
    # @param  [Array<Symbol>] variables
    # @return [Query]
    def order(*variables)
      if variables.empty?
        raise ArgumentError.new("wrong number of arguments (0 for 1)")
      else
        # TODO: support for descending sort, e.g. order(:s => :asc, :p => :desc)
        variables.map!(&:to_sym)
        solutions.sort! do |a, b|
          a = variables.map { |variable| a[variable].to_s }
          b = variables.map { |variable| b[variable].to_s }
          a <=> b
        end
      end
      self
    end
    alias_method :order_by, :order

    ##
    # Restricts the the solution sequence to the given `variables` only.
    #
    # @param  [Array<Symbol>] variables
    # @return [Query]
    def project(*variables)
      unless variables.empty?
        variables.map!(&:to_sym)
        solutions.each do |bindings|
          bindings.delete_if { |k, v| !variables.include?(k) } # FIXME
        end
      end
      self
    end
    alias_method :select, :project

    ##
    # Ensures solutions in the solution sequence are unique.
    #
    # @return [Query]
    def distinct
      solutions.uniq!
      self
    end
    alias_method :distinct!, :distinct
    alias_method :reduced,   :distinct
    alias_method :reduced!,  :distinct

    ##
    # Limits the solution sequence to bindings starting from the `start`
    # offset in the overall solution sequence.
    #
    # @param  [Integer, #to_i] start
    # @return [Query]
    def offset(start)
      slice(start, solutions.size - start.to_i)
    end
    alias_method :offset!, :offset

    ##
    # Limits the number of solutions to `length`.
    #
    # @param  [Integer, #to_i] length
    # @return [Query]
    def limit(length)
      slice(0, length)
    end
    alias_method :limit!, :limit

    ##
    # Limits the solution sequence to `length` bindings starting from the
    # `start` offset in the overall solution sequence.
    #
    # @param  [Integer, #to_i] start
    # @param  [Integer, #to_i] length
    # @return [Query]
    def slice(start, length)
      if (start = start.to_i) < solutions.size
        solutions.slice!(start, length.to_i)
      else
        solutions = []
      end
      self
    end
    alias_method :slice!, :slice
  end # Query
end # RDF
