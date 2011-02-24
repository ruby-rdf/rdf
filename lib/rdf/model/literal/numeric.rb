module RDF; class Literal
  ##
  # Shared methods and class ancestry for numeric literal classes.
  #
  # @since 0.3.0
  class Numeric < Literal
    ##
    # Compares this literal to `other` for sorting purposes.
    #
    # @param  [Object] other
    # @return [Integer] `-1`, `0`, or `1`
    # @since  0.3.0
    def <=>(other)
      case other
        when ::Numeric
          to_d <=> other
        when Numeric
          to_d <=> other.to_d
        else super
      end
    end

    ##
    # Returns `self`.
    #
    # @return [RDF::Literal::Numeric]
    # @since  0.2.3
    def +@
      self # unary plus
    end

    ##
    # Returns `self` negated.
    #
    # @return [RDF::Literal::Numeric]
    # @since  0.2.3
    def -@
      if (self.class == NonPositiveInteger || self.class == NegativeInteger) && object != 0
        # XXX Raise error?
      end
      self.class.new(-self.object)
    end

    ##
    # Returns the sum of `self` plus `other`.
    #
    # For xs:float or xs:double values, if one of the operands is a zero or a finite number
    # and the other is INF or -INF, INF or -INF is returned. If both operands are INF, INF is returned.
    # If both operands are -INF, -INF is returned. If one of the operands is INF
    # and the other is -INF, NaN is returned.
    # @param  [Literal::Numeric, #to_i, #to_f, #to_d] other
    # @return [RDF::Literal::Numeric]
    # @since  0.2.3
    # @see http://www.w3.org/TR/xpath-functions/#func-numeric-add
    def +(other)
      if self.class == Double || other.class == Double
        RDF::Literal::Double.new(to_f + other.to_f)
      elsif self.class == Float || other.class == Float
        RDF::Literal::Float.new(to_f + other.to_f)
      elsif self.class == Decimal || other.class == Decimal
        RDF::Literal::Decimal.new(to_d + (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
      else
        RDF::Literal::Integer.new(to_i + other.to_i)
      end
    end

    ##
    # Returns the difference of `self` minus `other`.
    #
    # @param  [Literal::Numeric, #to_i, #to_f, #to_d] other
    # @return [RDF::Literal::Numeric]
    # @since  0.2.3
    # @see http://www.w3.org/TR/xpath-functions/#func-numeric-subtract
    def -(other)
      if self.class == Double || other.class == Double
        RDF::Literal::Double.new(to_f - other.to_f)
      elsif self.class == Float || other.class == Float
        RDF::Literal::Float.new(to_f - other.to_f)
      elsif self.class == Decimal || other.class == Decimal
        RDF::Literal::Decimal.new(to_d - (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
      else
        RDF::Literal::Integer.new(to_i - other.to_i)
      end
    end

    ##
    # Returns the product of `self` times `other`.
    #
    # @param  [Literal::Numeric, #to_i, #to_f, #to_d] other
    # @return [RDF::Literal::Numeric]
    # @since  0.2.3
    # @see http://www.w3.org/TR/xpath-functions/#func-numeric-multiply
    def *(other)
      if self.class == Double || other.class == Double
        RDF::Literal::Double.new(to_f * other.to_f)
      elsif self.class == Float || other.class == Float
        RDF::Literal::Float.new(to_f * other.to_f)
      elsif self.class == Decimal || other.class == Decimal
        RDF::Literal::Decimal.new(to_d * (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
      else
        RDF::Literal::Integer.new(to_i * other.to_i)
      end
    end

    ##
    # Returns the quotient of `self` divided by `other`.
    #
    # As a special case, if the types of both $arg1 and $arg2 are xs:integer,
    # then the return type is xs:decimal.
    #
    # @param  [Literal::Numeric, #to_i, #to_f, #to_d] other
    # @return [RDF::Literal::Numeric]
    # @raise  [ZeroDivisionError] if divided by zero
    # @since  0.2.3
    # @see http://www.w3.org/TR/xpath-functions/#func-numeric-divide
    def /(other)
      if self.class == Double || other.class == Double
        RDF::Literal::Double.new(to_f / other.to_f)
      elsif self.class == Float || other.class == Float
        RDF::Literal::Float.new(to_f / other.to_f)
      elsif self.class == Decimal || other.class == Decimal
        RDF::Literal::Decimal.new(to_d / (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
      else
        RDF::Literal::Integer.new(to_i / other.to_i)
      end
    end

    ##
    # Returns the value as an integer.
    #
    # @return [Integer]
    def to_i
      @object.to_i
    end
    alias_method :to_int, :to_i
    alias_method :ord,    :to_i

    ##
    # Returns the value as a floating point number.
    #
    # The usual accuracy limits and errors of binary float arithmetic apply.
    #
    # @return [Float]
    # @see    BigDecimal#to_f
    def to_f
      @object.to_f
    end

    ##
    # Returns the value as a decimal number.
    #
    # @return [BigDecimal]
    def to_d
      @object.respond_to?(:to_d) ? @object.to_d : BigDecimal(@object.to_s)
    end

    ##
    # Returns the value as a rational number.
    #
    # @return [Rational]
    def to_r
      @object.to_r
    end
  end # Numeric
end; end # RDF::Literal
