module RDF; class Literal
  ##
  # An floating point number literal.
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
      @datatype = options[:datatype] || DATATYPE
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
      @string = to_canonical if @object
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || to_canonical
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

    private

    def to_canonical
      # Can't use simple %f transformation due to special requirements from
      # N3 tests in representation
      case
        when @object.nan?      then 'NaN'
        when @object.infinite? then @object.to_s[0...-'inity'.length].upcase
        when @object.zero?     then '0.0E0'
        else
          i, f, e = ('%.16E' % @object.to_f).split(/[\.E]/)
          f.sub!(/0*$/, '')           # remove any trailing zeroes
          f = '0' if f.empty?         # ...but there must be a digit to the right of the decimal point
          e.sub!(/^\+?0+(\d)$/, '\1') # remove the optional leading '+' sign and any extra leading zeroes
          "#{i}.#{f}E#{e}"
      end
    end
  end # class Double
end; end # class RDF::Literal
