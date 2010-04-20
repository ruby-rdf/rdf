class RDF::Query
  ##
  # An RDF query variable.
  #
  # @example Creating an unbound variable
  #   var = RDF::Query::Variable.new(:x)
  #   var.unbound?   #=> true
  #   var.value      #=> nil
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
  class Variable < RDF::Value
    # @return [Symbol] The variable's name.
    attr_accessor :name

    alias_method :to_sym, :name

    # @return [Value] The variable's value.
    attr_accessor :value

    ##
    # @param  [Symbol] name
    # @param  [Value]  value
    def initialize(name, value = nil)
      @name, @value = name.to_sym, value
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    # @see    RDF::Value#variable?
    # @since  0.1.17
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
    # @param  [Value] value
    # @return [Value] The previous value, if any.
    def bind(value)
      old_value = self.value
      self.value = value
      old_value
    end

    alias_method :bind!, :bind

    ##
    # Unbinds this variable, discarding any currently bound value.
    #
    # @return [Value] The previous value, if any.
    def unbind
      old_value = self.value
      self.value = nil
      old_value
    end

    alias_method :unbind!, :unbind

    ##
    # Returns this variable as `Hash`.
    #
    # @return [Hash{Symbol => Variable}]
    def variables
      { name => self }
    end

    alias_method :to_hash, :variables

    ##
    # Returns this variable's bindings (if any) as a `Hash`.
    #
    # @return [Hash{Symbol => Value}]
    def bindings
      unbound? ? {} : { name => value }
    end

    ##
    # Compares this variable with the given value.
    #
    # @param  [Value] other
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
  end
end
