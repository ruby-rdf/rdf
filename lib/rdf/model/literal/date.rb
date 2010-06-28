module RDF; class Literal
  ##
  # A date literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#date
  # @since 0.2.1
  class Date < Literal
    DATATYPE = XSD.date
    GRAMMAR  = %r(\A-?\d{4}-\d{2}-\d{2}(([\+\-]\d{2}:\d{2})|UTC|Z)?\Z).freeze

    ##
    # @param  [Date] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || DATATYPE
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when value.is_a?(::Date)         then value
        when value.respond_to?(:to_date) then value.to_date # Ruby 1.9+
        else ::Date.parse(value.to_s)
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#date
    def canonicalize
      @string = @object.strftime('%Y-%m-%d%Z').sub(/\+00:00|UTC/, 'Z')
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.strftime('%Y-%m-%d%Z').sub(/\+00:00|UTC/, 'Z')
    end
  end # class Date
end; end # class RDF::Literal
