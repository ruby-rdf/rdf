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
  # @see   http://www.w3.org/TR/xmlschema11-2/#decimal
  # @since 0.2.1
  class Decimal < Numeric
    DATATYPE = RDF::URI("http://www.w3.org/2001/XMLSchema#decimal")
    GRAMMAR  = /^[\+\-]?(?:(?:\d+(?:\.\d*)?)|(?:\.\d+))$/.freeze

    ##
    # @param  [String, BigDecimal, Numeric] value
    # @param  (see Literal#initialize)
    def initialize(value, datatype: nil, lexical: nil, **options)
      @datatype = RDF::URI(datatype || self.class.const_get(:DATATYPE))
      @string   = lexical || (value if value.is_a?(String))
      @object   = case
        when value.is_a?(::BigDecimal) then value
        when value.is_a?(::Float)      then BigDecimal(value.to_s)
        when value.is_a?(::Numeric)    then BigDecimal(value)
        else
          value = value.to_s
          value += "0" if value.end_with?(".")
          BigDecimal(value) rescue BigDecimal(0)
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema11-2/#decimal
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
      @object = BigDecimal(@string) unless @object.nil?
      self
    end

    ##
    # Returns the absolute value of `self`.
    #
    # From the XQuery function [fn:abs](https://www.w3.org/TR/xpath-functions/#func-abs).
    #
    # @return [RDF::Literal]
    # @see https://www.w3.org/TR/xpath-functions/#func-abs
    # @since  0.2.3
    def abs
      (d = to_d) && d > 0 ? self : RDF::Literal(d.abs)
    end

    ##
    # Returns the number with no fractional part that is closest to the argument. If there are two such numbers, then the one that is closest to positive infinity is returned. An error is raised if arg is not a numeric value.
    #
    # From the XQuery function [fn:round](https://www.w3.org/TR/xpath-functions/#func-round).
    #
    # @return [RDF::Literal::Decimal]
    # @see https://www.w3.org/TR/xpath-functions/#func-round
    def round
      rounded = to_d.round(half: (to_d < 0 ? :down : :up))
      if rounded == -0.0
        # to avoid -0.0
        self.class.new(0.0)
      else
        self.class.new(rounded)
      end
    end

    ##
    # Returns the smallest integer greater than or equal to `self`.
    #
    # From the XQuery function [fn:ceil](https://www.w3.org/TR/xpath-functions/#func-ceil).
    #
    # @example
    #   RDF::Literal(1).ceil            #=> RDF::Literal(1)
    #
    # @return [RDF::Literal::Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-ceil
    def ceil
      RDF::Literal::Integer.new(to_d.ceil)
    end

    ##
    # Returns the largest integer less than or equal to `self`.
    #
    # From the XQuery function [fn:floor](https://www.w3.org/TR/xpath-functions/#func-floor).
    #
    # @example
    #   RDF::Literal(1).floor            #=> RDF::Literal(1)
    #
    # @return [RDF::Literal::Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-floor
    def floor
      RDF::Literal::Integer.new(to_d.floor)
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
    # Returns the value as a string.
    #
    # @return [String]
    # @see    BigDecimal#to_s
    def to_s
      @string || @object.to_s('F')
    end
  end # Decimal
end; end # RDF::Literal
