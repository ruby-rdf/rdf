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
  #   solution.to_h       #=> {mbox: "jrhacker@example.org", ...}
  #
  class Solution
    # Undefine all superfluous instance methods:
    alias_method :__send, :send

    # Temporarily remember instance method for deprecation message in `method_missing`.
    INSTANCE_METHODS = instance_methods
    undef_method(*instance_methods.
                  map(&:to_s).
                  select {|m| m.match?(/^\w+$/)}.
                  reject {|m| %w(object_id dup instance_eval inspect to_s private_methods public_methods class method pretty_print).include?(m) || m[0,2] == '__'}.
                  map(&:to_sym))

    include Enumerable

    ##
    # Initializes the query solution.
    #
    # @param  [Hash{Symbol => RDF::Term}] bindings
    # @yield  [solution]
    def initialize(bindings = {}, &block)
      @bindings = bindings.to_h

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
    # @yieldparam [RDF::Term] value
    # @return [Enumerator]
    def each_binding(&block)
      @bindings.each(&block) if block_given?
      enum_binding
    end
    alias_method :each, :each_binding

    ##
    # Returns an enumerator for {#each_binding}.
    #
    # @return [Enumerator<RDF::Resource>]
    # @see    #each_subject
    def enum_binding
      enum_for(:each_binding)
    end

    ##
    # Enumerates over every variable name in this solution.
    #
    # @yield  [name]
    # @yieldparam [Symbol] name
    # @return [Enumerator]
    def each_name(&block)
      @bindings.each_key(&block) if block_given?
      enum_name
    end
    alias_method :each_key, :each_name

    ##
    # Returns an enumerator for {#each_name}.
    #
    # @return [Enumerator<RDF::Resource>]
    # @see    #each_subject
    def enum_name
      enum_for(:each_name)
    end

    ##
    # Enumerates over every variable value in this solution.
    #
    # @yield  [value]
    # @yieldparam [RDF::Term] value
    # @return [Enumerator]
    def each_value(&block)
      @bindings.each_value(&block) if block_given?
      enum_value
    end

    ##
    # Returns an enumerator for {#each_value}.
    #
    # @return [Enumerator<RDF::Resource>]
    # @see    #each_subject
    def enum_value
      enum_for(:each_value)
    end

    ##
    # @overload variable?
    #   Returns `false`.
    #
    #   @return [Boolean]
    # @overload variable?(variables)
    #   Returns `true` if this solution contains bindings for any of the given
    # `variables`.
    #
    #   @param  [Array<Symbol, #to_sym>] variables
    #   @return [Boolean]
    # @since  0.3.0
    def variable?(*args)
      case args.length
      when 0 then false
      when 1
        args.first.any? { |variable| bound?(variable) }
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end
    alias_method :variables?, :variable?
    alias_method :has_variables?, :variable?

    ##
    # Enumerates over every variable in this solution.
    #
    # @yield  [variable]
    # @yieldparam [Variable]
    # @return [Enumerator]
    def each_variable
      if block_given?
        @bindings.each do |name, value|
          yield Variable.new(name, value)
        end
      end
      enum_variable
    end

    ##
    # Returns an enumerator for {#each_variable}.
    #
    # @return [Enumerator<RDF::Resource>]
    # @see    #each_subject
    def enum_variable
      enum_for(:each_variable)
    end

    ##
    # Returns `true` if the variable `name` is bound in this solution.
    #
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @return [Boolean] `true` or `false`
    def bound?(name)
      !unbound?(name)
    end

    ##
    # Returns `true` if the variable `name` is unbound in this solution.
    #
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @return [Boolean] `true` or `false`
    def unbound?(name)
      @bindings[name.to_sym].nil?
    end

    ##
    # Returns the value of the variable `name`.
    #
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @return [RDF::Term]
    def [](name)
      @bindings[name.to_sym]
    end

    ##
    # Binds or rebinds the variable `name` to the given `value`.
    #
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @param  [RDF::Term] value
    # @return [RDF::Term]
    # @since  0.3.0
    def []=(name, value)
      @bindings[name.to_sym] = value.is_a?(RDF::Term) ? value : RDF::Literal(value)
    end

    ##
    # Merges the bindings from the given `other` query solution into this
    # one, overwriting any existing ones having the same name.
    #
    # ## RDF-star
    #
    # If merging a binding for a statement to a pattern,
    # merge their embedded solutions.
    #
    # @param  [RDF::Query::Solution, #to_h] other
    #   another query solution or hash bindings
    # @return [void] self
    # @since  0.3.0
    def merge!(other)
      @bindings.merge!(other.to_h) do |key, v1, v2|
        # Don't merge a pattern over a statement
        # This happens because JOIN does a reverse merge,
        # and a pattern is set in v2.
        v2.is_a?(Pattern) ? v1 : v2
      end
      # Merge bindings from patterns
      embedded_solutions = []
      @bindings.each do |k, v|
        if v.is_a?(Pattern) && other[k].is_a?(RDF::Statement)
          embedded_solutions << v.solution(other[k])
        end
      end
      # Merge embedded solutions
      embedded_solutions.each {|soln| merge!(soln)}
      self
    end

    ##
    # Merges the bindings from the given `other` query solution with a copy
    # of this one.
    #
    # @param  [RDF::Query::Solution, #to_h] other
    #   another query solution or hash bindings
    # @return [RDF::Query::Solution]
    # @since  0.3.0
    def merge(other)
      self.class.new(@bindings.dup).merge!(other)
    end

    ##
    # Duplicate solution, preserving patterns
    # @return [RDF::Statement]
    def dup
      merge({})
    end

    ##
    # Compatible Mappings
    #
    # Two solution mappings u1 and u2 are compatible if, for every variable v in dom(u1) and in dom(u2), u1(v) = u2(v).
    #
    # @param [RDF::Query::Solution, #to_h] other
    #   another query solution or hash bindings
    # @return [Boolean]
    # @see http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#defn_algCompatibleMapping
    def compatible?(other)
      @bindings.all? do |k, v|
        !other.to_h.key?(k) || other[k].eql?(v)
      end
    end

    ##
    # Disjoint mapping
    #
    # A solution is disjoint with another solution if it shares no common variables in their domains.
    #
    # @param [RDF::Query::Solution] other
    # @return [Boolean]
    # @see http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#defn_algMinus
    def disjoint?(other)
      @bindings.none? do |k, v|
        v && other.to_h.key?(k) && other[k].eql?(v)
      end
    end

    ##
    # Isomorphic Mappings
    # Two solution mappings u1 and u2 are isomorphic if,
    # for every variable v in dom(u1) and in dom(u2), u1(v) = u2(v).
    #
    # @param [RDF::Query::Solution, #to_h] other
    #   another query solution or hash bindings
    # @return [Boolean]
    def isomorphic_with?(other)
      @bindings.all? do |k, v|
        !other.to_h.key?(k) || other[k].eql?(v)
      end
    end
    
    ##
    # @return [Array<Array(Symbol, RDF::Term)>}
    def to_a
      @bindings.to_a
    end

    ##
    # @return [Hash{Symbol => RDF::Term}}
    def to_h
      @bindings.dup
    end
    
    ##
    # Integer hash of this solution
    # @return [Integer]
    def hash
      @bindings.hash
    end

    ##
    # Equivalence of solution
    def eql?(other)
      other.is_a?(Solution) && @bindings.eql?(other.bindings)
    end

    ##
    # Equals of solution
    def ==(other)
      other.is_a?(Solution) && @bindings == other.bindings
    end

    ##
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, @bindings.inspect)
    end

  protected

    ##
    # @overload binding(name)
    #   Return the binding for this name
    #
    #   @param  [Symbol] name
    #   @return [RDF::Term]
    def method_missing(name, *args, &block)
      if args.empty? && @bindings.key?(name.to_sym)
        if INSTANCE_METHODS.include?(name)
          warn "[DEPRECATION] RDF::Query::Solution##{name} is an overridden instance method.\n" +
               "Its use as a solution accessor is deprecated and will be removed in a future version.\n" +
               "Use #[] for safe access.\n" +
               "Called from #{Gem.location_of_caller.join(':')}"
        end
        @bindings[name.to_sym]
      else
        super # raises NoMethodError
      end
    end

    ##
    # @return [Boolean]
    def respond_to_missing?(name, include_private = false)
      @bindings.key?(name.to_sym) || super
    end

    ##
    # @private
    # @param  [Symbol, #to_sym] method
    # @return [Enumerator]
    # @see    Object#enum_for
    def enum_for(method = :each)
      # Ensure that enumerators are, themselves, queryable
      this = self
      Enumerator.new do |yielder|
        this.__send(method) {|*y| yielder << (y.length > 1 ? y : y.first)}
      end
    end
    alias_method :to_enum, :enum_for
  end # Solution
end # RDF::Query
