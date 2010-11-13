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
  #   var === 42     #=> true
  #
  # @example Creating a bound variable
  #   var = RDF::Query::Variable.new(:y, 123)
  #   var.bound?     #=> true
  #   var.value      #=> 123
  #
  # @example Bound variables match only their actual value
  #   var === 42     #=> false
  #   var === 123    #=> true
  #
  # @example Getting the variable name
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
    include RDF::Value

    ##
    # The variable's name.
    #
    # @return [Symbol]
    attr_accessor :name
    alias_method :to_sym, :name

    ##
    # The variable's value.
    #
    # @return [RDF::Value]
    attr_accessor :value

    ##
    # @param  [Symbol, #to_sym] name
    #   the variable name
    # @param  [RDF::Value]  value
    #   an optional variable value
    def initialize(name = nil, value = nil)
      @name  = (name || "g#{__id__.to_i.abs}").to_sym
      @value = value
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    # @see    RDF::Value#variable?
    # @since  0.1.7
    def variable? 
      true
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
    # Rebinds this variable to the given `value`.
    #
    # @param  [RDF::Value] value
    # @return [RDF::Value] the previous value, if any.
    def bind(value)
      old_value = self.value
      self.value = value
      old_value
    end
    alias_method :bind!, :bind

    ##
    # Unbinds this variable, discarding any currently bound value.
    #
    # @return [RDF::Value] the previous value, if any.
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
    alias_method :to_hash, :variables

    ##
    # Returns this variable's bindings (if any) as a `Hash`.
    #
    # @return [Hash{Symbol => RDF::Value}]
    def bindings
      unbound? ? {} : {name => value}
    end

    ##
    # Returns a hash code for this variable.
    #
    # @return [Fixnum]
    # @since  0.3.0
    def hash
      @name.hash
    end

    ##
    # Returns `true` if this variable is equivalent to a given `other`
    # variable.
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def eql?(other)
      other.is_a?(RDF::Query::Variable) && @name.eql?(other.name)
    end

    ##
    # Compares this variable with the given value.
    #
    # @param  [RDF::Value] other
    # @return [Boolean]
    def ===(other)
      if unbound?
        true # match anything when unbound
      else
        value === other
      end
    end

    ##
    # Returns a string representation of this variable.
    #
    # @return [String]
    def to_s
      unbound? ? "?#{name}" : "?#{name}=#{value}"
    end
  end # Variable
end # RDF::Query
