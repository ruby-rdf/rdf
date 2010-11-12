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
    undef_method(*(instance_methods.map(&:to_sym) - [:__id__, :__send__, :__class__, :__eval__,
      :object_id, :dup, :instance_eval, :inspect, :to_s,
      :class, :is_a?, :respond_to?, :respond_to_missing?]))

    include Enumerable

    ##
    # Initializes the query solution.
    #
    # @param  [Hash{Symbol => RDF::Value}] bindings
    # @yield  [solution]
    def initialize(bindings = {}, &block)
      @bindings = bindings.to_hash

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    # @private
    attr_reader :bindings

    ##
    # Enumerates over every variable binding in this solution.
    #
    # @yield  [name, value]
    # @yieldparam [Symbol] name
    # @yieldparam [RDF::Value] value
    # @return [Enumerator]
    def each_binding(&block)
      @bindings.each(&block)
    end
    alias_method :each, :each_binding

    ##
    # Enumerates over every variable name in this solution.
    #
    # @yield  [name]
    # @yieldparam [Symbol] name
    # @return [Enumerator]
    def each_name(&block)
      @bindings.each_key(&block)
    end
    alias_method :each_key, :each_name

    ##
    # Enumerates over every variable value in this solution.
    #
    # @yield  [value]
    # @yieldparam [RDF::Value] value
    # @return [Enumerator]
    def each_value(&block)
      @bindings.each_value(&block)
    end

    ##
    # Returns `true` if this solution contains bindings of any of the given
    # `variables`.
    #
    # @param  [Enumerable] variables
    #   an array of variables to check
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def has_variables?(variables)
      variables.any? { |variable| bound?(variable) }
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
    # @return [Boolean] `true` or `false`
    def bound?(name)
      !unbound?(name)
    end

    ##
    # Returns `true` if the variable `name` is unbound in this solution.
    #
    # @param  [Symbol] name
    # @return [Boolean] `true` or `false`
    def unbound?(name)
      @bindings[name.to_sym].nil?
    end

    ##
    # Returns the value of the variable `name`.
    #
    # @param  [Symbol, #to_sym] name
    # @return [RDF::Value]
    def [](name)
      @bindings[name.to_sym]
    end

    ##
    # Binds or rebinds the variable `name` to the given `value`.
    #
    # @param  [Symbol, #to_sym] name
    # @param  [RDF::Value] value
    # @return [RDF::Value]
    # @since  0.3.0
    def []=(name, value)
      @bindings[name.to_sym] = value
    end

    ##
    # Merges the bindings from the given `other` query solution into this
    # one, overwriting any existing ones having the same name.
    #
    # @param  [RDF::Query::Solution, #to_hash] other
    #   another query solution or hash bindings
    # @return [void] self
    # @since  0.3.0
    def merge!(other)
      @bindings.merge!(other.to_hash)
      self
    end

    ##
    # Merges the bindings from the given `other` query solution with a copy
    # of this one.
    #
    # @param  [RDF::Query::Solution, #to_hash] other
    #   another query solution or hash bindings
    # @return [RDF::Query::Solution]
    # @since  0.3.0
    def merge(other)
      self.class.new(@bindings.dup).merge!(other)
    end

    ##
    # @return [Array<Array(Symbol, RDF::Value)>}
    def to_a
      @bindings.to_a
    end

    ##
    # @return [Hash{Symbol => RDF::Value}}
    def to_hash
      @bindings.dup
    end

    ##
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, @bindings.inspect)
    end

  protected

    ##
    # @param  [Symbol] name
    # @return [RDF::Value]
    def method_missing(name, *args, &block)
      if args.empty? && @bindings.has_key?(name.to_sym)
        @bindings[name.to_sym]
      else
        super # raises NoMethodError
      end
    end
  end # Solution
end # RDF::Query
