module RDF
  ##
  # An RDF basic graph pattern query.
  class Query
    include Enumerable

    # @return [Hash{Symbol => Variable}]
    attr_reader :variables

    # @return [Array<Pattern>]
    attr_reader :patterns

    # @return [Array<Hash{Symbol => Value}>]
    attr_accessor :solutions

    ##
    # @param  [Hash{Symbol => Object}] options
    # @yield  [query]
    # @yieldparam [Query]
    def initialize(options = {}, &block)
      @variables = options.delete(:variables) || {}
      @patterns  = options.delete(:patterns)  || []
      @solutions = options.delete(:solutions) || []
      @options   = options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Enumerates over each query solution.
    #
    # @yield  [solution]
    # @yieldparam [Hash{Symbol => Value}]
    # @return [Enumerable]
    def each_solution(&block)
      solutions.each(&block)
    end

    alias_method :each, :each_solution

    ##
    # Limits the the solution sequence to the given `variables` only.
    #
    # @param  [Enumerable<Symbol>] variables
    # @return [Query]
    def select(*variables)
      unless variables.empty?
        variables.map! { |variable| variable.to_sym }
        solutions.each do |bindings|
          bindings.delete_if { |k, v| !variables.include?(k) }
        end
      end
      self
    end
  end
end
