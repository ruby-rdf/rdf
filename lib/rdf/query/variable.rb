class RDF::Query
  ##
  # An RDF query variable.
  #
  # @example Creating a named unbound variable
  #   var = RDF::Query::Variable.new(:x)
  #   var.unbound?   #=> true
  #   var.value      #=> nil
  #
  # @example Creating an anonymous unbound variable
  #   var = RDF::Query::Variable.new
  #   var.name       #=> :g2166151240
  #
  # @example Unbound variables match any value
  #   var === RDF::Literal(42)     #=> true
  #
  # @example Creating a bound variable
  #   var = RDF::Query::Variable.new(:y, 123)
  #   var.bound?     #=> true
  #   var.value      #=> 123
  #
  # @example Bound variables match only their actual value
  #   var = RDF::Query::Variable.new(:y, 123)
  #   var === 42     #=> false
  #   var === 123    #=> true
  #
  # @example Getting the variable name
  #   var = RDF::Query::Variable.new(:y, 123)
  #   var.named?     #=> true
  #   var.name       #=> :y
  #   var.to_sym     #=> :y
  #
  # @example Rebinding a variable returns the previous value
  #   var.bind!(456) #=> 123
  #   var.value      #=> 456
  #
  # @example Unbinding a previously bound variable
  #   var.unbind!
  #   var.unbound?   #=> true
  #
  # @example Getting the string representation of a variable
  #   var = RDF::Query::Variable.new(:x)
  #   var.to_s       #=> "?x"
  #   var = RDF::Query::Variable.new(:y, 123)
  #   var.to_s       #=> "?y=123"
  #
  class Variable
    include RDF::Term

    ##
    # The variable's name.
    #
    # @return [Symbol]
    attr_accessor :name
    alias_method :to_sym, :name

    ##
    # The variable's value.
    #
    # @return [RDF::Term]
    attr_accessor :value

    ##
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @param  [RDF::Term] value
    #   an optional variable value
    # @param [Boolean] distinguished (true) Also interpreted by leading '?' or '$' in name. If non-distinguished, '??' or '$$'.
    # @param [Boolean] existential (true) Also interpreted by leading '$' in name
    def initialize(name = nil, value = nil, distinguished: nil, existential: nil)
      name = (name || "g#{__id__.to_i.abs}").to_s
      if name.start_with?('??')
        name, dis, ex = name[2..-1], false, false
      elsif name.start_with?('?')
        name, dis, ex = name[1..-1], true, false
      elsif name.start_with?('$$')
        name, dis, ex = name[2..-1], false, true
      elsif name.start_with?('$')
        name, dis, ex = name[1..-1], true, true
      else
        dis, ex = true, false
      end
      @name = name.to_sym
      @value = value
      @distinguished = distinguished.nil? ? dis : distinguished
      @existential = existential.nil? ? ex : existential
    end

    ##
    # @overload variable?
    #   Returns `true` if `self` is a {RDF::Query::Variable}, or does it contain a variable?
    #
    #   @return [Boolean]
    # @overload variable?(variable)
    #   Returns `true` if `self` contains the given variable.
    #
    #   @param  [RDF::Resource] value
    #   @return [Boolean]
    # @since  0.1.7
    def variable?(*args)
      case args.length
      when 0 then true
      when 1
        case variable = args.first
        when RDF::Query::Variable then self == variable
        when Symbol then to_sym == variable
        else false
        end
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end

    ##
    # Returns `true` if this variable has a name.
    #
    # @return [Boolean]
    def named?
      true
    end

    ##
    # Returns `true` if this variable is bound.
    #
    # @return [Boolean]
    def bound?
      !unbound?
    end

    ##
    # Returns `true` if this variable is unbound.
    #
    # @return [Boolean]
    def unbound?
      value.nil?
    end

    ##
    # Returns `true` if this variable is distinguished.
    #
    # @return [Boolean]
    def distinguished?
      @distinguished
    end

    ##
    # Sets if variable is distinguished or non-distinguished.
    # By default, variables are distinguished
    #
    # @return [Boolean]
    def distinguished=(value)
      @distinguished = value
    end

    ##
    # Returns `true` if this variable is existential.
    #
    # @return [Boolean]
    def existential?
      @existential
    end

    ##
    # Sets if variable is existential or univeresal.
    # By default, variables are universal
    #
    # @return [Boolean]
    def existential=(value)
      @existential = value
    end

    ##
    # Rebinds this variable to the given `value`.
    #
    # @overload bind(value)
    #   @param [RDF::Query::Solution] value
    #   @return [self] the bound variable
    #
    # @overload bind(value)
    #   @param [RDF::Term] value
    #   @return [RDF::Term] the previous value, if any.
    def bind(value)
      if value.is_a?(RDF::Query::Solution)
        self.value = value.to_h.fetch(name, self.value)
        self
      else
        warn "[DEPRECATION] RDF::Query::Variable#bind should be used with a solution, not a term.\n" +
             "Called from #{Gem.location_of_caller.join(':')}"
        old_value = self.value
        self.value = value
        old_value
      end
    end
    alias_method :bind!, :bind

    ##
    # Unbinds this variable, discarding any currently bound value.
    #
    # @return [RDF::Term] the previous value, if any.
    def unbind
      old_value = self.value
      self.value = nil
      old_value
    end
    alias_method :unbind!, :unbind

    ##
    # Returns this variable as `Hash`.
    #
    # @return [Hash{Symbol => RDF::Query::Variable}]
    def variables
      {name => self}
    end
    alias_method :to_h, :variables

    ##
    # Returns this variable's bindings (if any) as a `Hash`.
    #
    # @return [Hash{Symbol => RDF::Term}]
    def bindings
      unbound? ? {} : {name => value}
    end

    ##
    # Returns a hash code for this variable.
    #
    # @return [Integer]
    # @since  0.3.0
    def hash
      @name.hash
    end

    ##
    # Returns `true` if this variable is equivalent to a given `other`
    # variable. Or, to another Term if bound, or to any other Term
    #
    # @note when comparing against the default graph in an {RDF::Dataset}, `other` will be `false` and not be equal to an unbound variable.
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def eql?(other)
      if unbound?
        other.is_a?(RDF::Term) # match any Term when unbound
      elsif other.is_a?(RDF::Query::Variable)
        @name.eql?(other.name)
      else
        value.eql?(other)
      end
    end
    alias_method :==, :eql?

    ##
    # Compares this variable with the given value.
    #
    # @param  [RDF::Term] other
    # @return [Boolean]
    def ===(other)
      if unbound?
        other.is_a?(RDF::Term) # match any Term when unbound
      else
        value === other
      end
    end

    ##
    # Returns term if var is the same as this variable.
    #
    # @param [Symbol] var
    # @param [RDF::Term] term
    # @return [RDF::Term]
    def var_values(var, term)
      term if var == name
    end

    ##
    # Returns a string representation of this variable.
    #
    # Distinguished variables are indicated with a single `?`.
    #
    # Non-distinguished variables are indicated with a double `??`
    #
    # Existential variables are indicated using a single `$`, or with `$$` if also non-distinguished
    # @example
    #   v = Variable.new("a")
    #   v.to_s => '?a'
    #   v.distinguished = false
    #   v.to_s => '??a'
    #
    # @return [String]
    def to_s
      prefix = distinguished? ? (existential? ? '$' : '?') : (existential? ? '$$' : '??')
      unbound? ? "#{prefix}#{name}" : "#{prefix}#{name}=#{value}"
    end
    alias_method :to_base, :to_s
  end # Variable
end # RDF::Query
