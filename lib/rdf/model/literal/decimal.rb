module RDF; class Literal
  ##
  # A decimal literal.
  #
  # @example Arithmetic with decimal literals
  #   RDF::Literal(BigDecimal('1.0')) + 0.5   #=> RDF::Literal(BigDecimal('1.5'))
  #   RDF::Literal(BigDecimal('1.0')) - 0.5   #=> RDF::Literal(BigDecimal('0.5'))
  #   RDF::Literal(BigDecimal('1.0')) * 0.5   #=> RDF::Literal(BigDecimal('0.5'))
  #   RDF::Literal(BigDecimal('1.0')) / 0.5   #=> RDF::Literal(BigDecimal('2.0'))
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#decimal
  # @since 0.2.1
  class Decimal < Literal
    DATATYPE = XSD.decimal
    GRAMMAR  = /^[\+\-]?\d+(\.\d*)?$/.freeze

    include RDF::Literal::Numeric

    ##
    # @param  [BigDecimal] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when value.is_a?(BigDecimal) then value
        else BigDecimal(value.to_s)
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#decimal
    def canonicalize!
      # Can't use simple %f transformation due to special requirements from
      # N3 tests in representation
      @string = begin
        i, f = @object.to_s('F').split('.')
        i.sub!(/^\+?0+(\d)$/, '\1') # remove the optional leading '+' sign and any extra leading zeroes
        f = f[0, 16]                # truncate the fractional part after 15 decimal places
        f.sub!(/0*$/, '')           # remove any trailing zeroes
        f = '0' if f.empty?         # ...but there must be a digit to the right of the decimal point
        "#{i}.#{f}"
      end
      self
    end

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
        when RDF::Literal::Decimal, RDF::Literal::Double
          to_d <=> other.to_d
        else super
      end
    end

    ##
    # Returns `true` if this literal is equivalent to `other`.
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def ==(other)
      (self <=> other).zero?
    end
    alias_method :===, :==

    ##
    # Returns the absolute value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def abs
      (d = to_d) && d > 0 ? self : RDF::Literal(d.abs)
    end

    ##
    # Returns `true` if the value is zero.
    #
    # @return [Boolean]
    # @since  0.2.3
    def zero?
      to_d.zero?
    end

    ##
    # Returns `self` if the value is not zero, `nil` otherwise.
    #
    # @return [Boolean]
    # @since  0.2.3
    def nonzero?
      to_d.nonzero? ? self : nil
    end

    ##
    # Returns `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def +@
      self # unary plus
    end

    ##
    # Returns `self` negated.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def -@
      RDF::Literal(-to_d) # unary minus
    end

    ##
    # Returns the sum of `self` plus `other`.
    #
    # @param  [#to_d] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def +(other)
      RDF::Literal(to_d + (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
    end

    ##
    # Returns the difference of `self` minus `other`.
    #
    # @param  [#to_d] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def -(other)
      RDF::Literal(to_d - (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
    end

    ##
    # Returns the product of `self` times `other`.
    #
    # @param  [#to_d] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def *(other)
      RDF::Literal(to_d * (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
    end

    ##
    # Returns the quotient of `self` divided by `other`.
    #
    # @param  [#to_d] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def /(other)
      RDF::Literal(to_d / (other.respond_to?(:to_d) ? other.to_d : BigDecimal(other.to_s)))
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    # @see    BigDecimal#to_s
    def to_s
      @string || @object.to_s('F')
    end

    ##
    # Returns the value as an integer.
    #
    # @return [Integer]
    # @see    BigDecimal#to_i
    def to_i
      @object.to_i
    end

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
    # @see    BigDecimal#to_d
    def to_d
      @object.respond_to?(:to_d) ? @object.to_d : BigDecimal(@object.to_s)
    end

    ##
    # Returns the value as a rational number.
    #
    # @return [Rational]
    # @see    BigDecimal#to_r
    def to_r
      @object.to_r # only available on Ruby 1.9+
    end
  end # Decimal
end; end # RDF::Literal
