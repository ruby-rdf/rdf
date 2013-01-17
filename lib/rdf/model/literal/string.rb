module RDF; class Literal
  ##
  # A String literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#string
  # @since 0.3.11
  class String < Literal
    DATATYPE = XSD.string
    GRAMMAR  = nil

    ##
    # @param  [Object] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || self.class.const_get(:DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   ||= value if value.is_a?(String)
      @object   = value.to_s
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xml-exc-c14n/
    def canonicalize!
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object
    end
  end # XML
end; end # RDF::Literal
