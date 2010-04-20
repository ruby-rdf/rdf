class RDF::Query
  ##
  # An RDF query solution.
  #
  # @example Iterating over every binding in the solution
  #   solution.each_binding  { |name, value| puts value.inspect }
  #   solution.each_variable { |variable| puts variable.value.inspect }
  #
  # @example Iterating over every value in the solution
  #   solution.each_value    { |value| puts value.inspect }
  #
  # @example Checking whether a variable is bound or unbound
  #   solution.bound?(:title)
  #   solution.unbound?(:mbox)
  #
  # @example Retrieving the value of a bound variable
  #   solution[:mbox]
  #   solution.mbox
  #
  # @example Retrieving all bindings in the solution as a `Hash`
  #   solution.to_hash       #=> {:mbox => "jrhacker@example.org", ...}
  #
  class Solution
    # Undefine all superfluous instance methods:
    undef_method *(instance_methods.map { |s| s.to_sym } - [:__id__, :__send__, :__class__, :__eval__, :object_id, :instance_eval, :inspect, :class, :is_a?])

    include Enumerable

    ##
    # @param  [Hash{Symbol => Value}] bindings
    def initialize(bindings = {})
      @bindings = bindings.to_hash
    end

    ##
    # Enumerates over every variable binding in this solution.
    #
    # @yield  [name, value]
    # @yieldparam [Symbol, Value]
    # @return [Enumerator]
    def each_binding(&block)
      @bindings.each(&block)
    end

    alias_method :each, :each_binding

    ##
    # Enumerates over every variable name in this solution.
    #
    # @yield  [name]
    # @yieldparam [Symbol]
    # @return [Enumerator]
    def each_name(&block)
      @bindings.each_key(&block)
    end

    alias_method :each_key, :each_name

    ##
    # Enumerates over every variable value in this solution.
    #
    # @yield  [value]
    # @yieldparam [Value]
    # @return [Enumerator]
    def each_value(&block)
      @bindings.each_value(&block)
    end

    ##
    # Enumerates over every variable in this solution.
    #
    # @yield  [variable]
    # @yieldparam [Variable]
    # @return [Enumerator]
    def each_variable(&block)
      @bindings.each do |name, value|
        block.call(Variable.new(name, value))
      end
    end

    ##
    # Returns `true` if the variable `name` is bound in this solution.
    #
    # @param  [Symbol] name
    # @return [Boolean]
    def bound?(name)
      !unbound?(name)
    end

    ##
    # Returns `true` if the variable `name` is unbound in this solution.
    #
    # @param  [Symbol] name
    # @return [Boolean]
    def unbound?(name)
      @bindings[name.to_sym].nil?
    end

    ##
    # Returns the value of the variable `name`.
    #
    # @param  [Symbol] name
    # @return [Value]
    def [](name)
      @bindings[name.to_sym]
    end

    ##
    # @return [Array<Array(Symbol, Value)>}
    def to_a
      @bindings.to_a
    end

    ##
    # @return [Hash{Symbol => Value}}
    def to_hash
      @bindings.dup
    end

    ##
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, @bindings.inspect)
    end

    protected

      ##
      # @param  [Symbol] name
      # @return [Value]
      def method_missing(name, *args, &block)
        if args.empty? && @bindings.has_key?(name.to_sym)
          @bindings[name.to_sym]
        else
          super
        end
      end

  end
end
