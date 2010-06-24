module RDF; class Literal
  ##
  # A date/time literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#dateTime
  # @since 0.2.1
  class DateTime < Literal
    DATATYPE = XSD.dateTime
    GRAMMAR  = nil # TODO

    ##
    # @param  [DateTime] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || DATATYPE
      @string   = options[:lexical] if options.has_key?(:lexical)
      @object   = case
        when value.respond_to?(:xmlschema) then value
        else ::DateTime.parse(value.to_s)
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#dateTime
    def canonicalize
      # TODO: implement xsd:dateTime canonicalization
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.respond_to?(:xmlschema) ? @object.xmlschema : @object.to_s
    end
  end # class DateTime
end; end # class RDF::Literal
