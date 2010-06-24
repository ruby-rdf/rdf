module RDF; class Literal
  ##
  # A date literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#date
  # @since 0.2.1
  class Date < Literal
    DATATYPE = XSD.date
    GRAMMAR  = nil # TODO

    ##
    # @param  [Date] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || DATATYPE
      @string   = options[:lexical] if options.has_key?(:lexical)
      @object   = case
        when value.respond_to?(:xmlschema) then value
        else ::Date.parse(value.to_s)
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#date
    def canonicalize
      # TODO: implement xsd:date canonicalization
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.respond_to?(:xmlschema) ? @object.xmlschema : @object.to_s
    end
  end # class Date
end; end # class RDF::Literal
