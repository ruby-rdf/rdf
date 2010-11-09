module RDF; class Literal
  ##
  # An floating point number literal.
  #
  # @example Arithmetic with floating point literals
  #   RDF::Literal(1.0) + 0.5                 #=> RDF::Literal(1.5)
  #   RDF::Literal(3.0) - 6                   #=> RDF::Literal(-3.0)
  #   RDF::Literal(Math::PI) * 2              #=> RDF::Literal(Math::PI * 2)
  #   RDF::Literal(Math::PI) / 2              #=> RDF::Literal(Math::PI / 2)
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#double
  # @since 0.2.1
  class Double < Literal
    DATATYPE = XSD.double
    GRAMMAR  = /^[\+\-]?\d+(\.\d*([eE][\+\-]?\d+)?)?$/.freeze # FIXME: support 'INF', '-INF' and 'NaN'

    ##
    # @param  [Float, #to_f] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when value.is_a?(::String)    then Float(value) rescue nil
        when value.is_a?(::Float)     then value
        when value.respond_to?(:to_f) then value.to_f
        else Float(value.to_s) rescue nil
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#double
    def canonicalize
      # Can't use simple %f transformation due to special requirements from
      # N3 tests in representation
      @string = case
        when @object.nan?      then 'NaN'
        when @object.infinite? then @object.to_s[0...-'inity'.length].upcase
        when @object.zero?     then '0.0E0'
        else
          i, f, e = ('%.16E' % @object.to_f).split(/[\.E]/)
          f.sub!(/0*$/, '')           # remove any trailing zeroes
          f = '0' if f.empty?         # ...but there must be a digit to the right of the decimal point
          e.sub!(/^\+?0+(\d)$/, '\1') # remove the optional leading '+' sign and any extra leading zeroes
          "#{i}.#{f}E#{e}"
      end unless @object.nil?
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
        when Numeric
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
    # Returns `true` if the value is an invalid IEEE floating point number.
    #
    # @example
    #   RDF::Literal(-1.0).nan?           #=> false
    #   RDF::Literal(1.0/0.0).nan?        #=> false
    #   RDF::Literal(0.0/0.0).nan?        #=> true
    #
    # @return [Boolean]
    # @since  0.2.3
    def nan?
      to_f.nan?
    end

    ##
    # Returns `true` if the value is a valid IEEE floating point number (it
    # is not infinite, and `nan?` is `false`).
    #
    # @example
    #   RDF::Literal(-1.0).finite?        #=> true
    #   RDF::Literal(1.0/0.0).finite?     #=> false
    #   RDF::Literal(0.0/0.0).finite?     #=> false
    #
    # @return [Boolean]
    # @since  0.2.3
    def finite?
      to_f.finite?
    end

    ##
    # Returns `nil`, `-1`, or `+1` depending on whether the value is finite,
    # `-INF`, or `+INF`.
    #
    # @example
    #   RDF::Literal(0.0/0.0).infinite?   #=> nil
    #   RDF::Literal(-1.0/0.0).infinite?  #=> -1
    #   RDF::Literal(+1.0/0.0).infinite?  #=> 1
    #
    # @return [Integer]
    # @since  0.2.3
    def infinite?
      to_f.infinite?
    end

    ##
    # Returns the smallest integer greater than or equal to `self`.
    #
    # @example
    #   RDF::Literal(1.2).ceil            #=> RDF::Literal(2)
    #   RDF::Literal(-1.2).ceil           #=> RDF::Literal(-1)
    #   RDF::Literal(2.0).ceil            #=> RDF::Literal(2)
    #   RDF::Literal(-2.0).ceil           #=> RDF::Literal(-2)
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def ceil
      RDF::Literal(to_f.ceil)
    end

    ##
    # Returns the largest integer less than or equal to `self`.
    #
    # @example
    #   RDF::Literal(1.2).floor           #=> RDF::Literal(1)
    #   RDF::Literal(-1.2).floor          #=> RDF::Literal(-2)
    #   RDF::Literal(2.0).floor           #=> RDF::Literal(2)
    #   RDF::Literal(-2.0).floor          #=> RDF::Literal(-2)
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def floor
      RDF::Literal(to_f.floor)
    end

    ##
    # Returns the absolute value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def abs
      (f = to_f) && f > 0 ? self : RDF::Literal(f.abs)
    end

    ##
    # Returns `true` if the value is zero.
    #
    # @return [Boolean]
    # @since  0.2.3
    def zero?
      to_f.zero?
    end

    ##
    # Returns `self` if the value is not zero, `nil` otherwise.
    #
    # @return [Boolean]
    # @since  0.2.3
    def nonzero?
      to_f.nonzero? ? self : nil
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
      RDF::Literal(-to_f) # unary minus
    end

    ##
    # Returns the sum of `self` plus `other`.
    #
    # @param  [#to_f] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def +(other)
      RDF::Literal(to_f + other.to_f)
    end

    ##
    # Returns the difference of `self` minus `other`.
    #
    # @param  [#to_f] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def -(other)
      RDF::Literal(to_f - other.to_f)
    end

    ##
    # Returns the product of `self` times `other`.
    #
    # @param  [#to_f] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def *(other)
      RDF::Literal(to_f * other.to_f)
    end

    ##
    # Returns the quotient of `self` divided by `other`.
    #
    # @param  [#to_f] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def /(other)
      RDF::Literal(to_f / other.to_f)
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || case
        when @object.nan?      then 'NaN'
        when @object.infinite? then @object.to_s[0...-'inity'.length].upcase
        else @object.to_s
      end
    end

    ##
    # Returns the value as an integer.
    #
    # @return [Integer]
    def to_i
      @object.to_i
    end

    ##
    # Returns the value as a floating point number.
    #
    # @return [Float]
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
      @object.to_r # only available on Ruby 1.9+
    end
  end # class Double
end; end # class RDF::Literal
