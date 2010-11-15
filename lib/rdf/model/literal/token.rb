module RDF; class Literal
  ##
  # A token literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#token
  # @since 0.2.3
  class Token < Literal
    DATATYPE = XSD.token
    GRAMMAR  = /\A[^\x0D\x0A\x09]+\z/i.freeze # FIXME

    ##
    # @param  [Symbol, #to_s]  value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = value.is_a?(Symbol) ? value : value.to_s
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#boolean
    def canonicalize!
      @string = @object.to_s if @object
      self
    end

    ##
    # Returns the value as a symbol.
    #
    # @return [Symbol]
    def to_sym
      @object.to_sym
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.to_s
    end
  end # Token
end; end # RDF::Literal
