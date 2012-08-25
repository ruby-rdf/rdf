module RDF; class Literal
  ##
  # An XML literal.
  #
  # This class exists mostly as a stub. See RDF::XSD gem for full support.
  
  # @see   https://github.com/ruby-rdf/rdf-xsd/blob/master/lib/rdf/xsd/xml.rb
  # @see   http://www.w3.org/TR/rdf-concepts/#section-XMLLiteral
  # @see   http://www.w3.org/TR/rdfa-core/#s_xml_literals
  # @since 0.2.1
  class XML < Literal
    DATATYPE = RDF.XMLLiteral
    GRAMMAR  = nil

    ##
    # @param  [Object] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || self.class.const_get(:DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @object   = value # TODO: parse XML string using REXML
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
      @string || @object.to_s
    end
  end # XML
end; end # RDF::Literal
