module RDF; class Literal
  ##
  # A boolean literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#boolean
  # @since 0.2.1
  class Boolean < Literal
    DATATYPE = XSD.boolean
    GRAMMAR  = /^(true|false|1|0)$/.freeze
    TRUE     = %w(true  1).freeze
    FALSE    = %w(false 0).freeze

    ##
    # @param  [Boolean] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = options[:datatype] || DATATYPE
      @string   = options[:lexical] if options.has_key?(:lexical)
      @object   = case
        when true.equal?(value)         then true
        when false.equal?(value)        then false
        when TRUE.include?(value.to_s)  then true
        when FALSE.include?(value.to_s) then false
        else raise ArgumentError.new("expected true or false, but got #{value.inspect}")
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#boolean
    def canonicalize
      @string = (@object ? :true : :false).to_s
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.to_s
    end

    ##
    # Returns `true` if this value is `true`.
    #
    # @return [Boolean]
    def true?
      @object.equal?(true)
    end

    ##
    # Returns `true` if this value is `false`.
    #
    # @return [Boolean]
    def false?
      @object.equal?(false)
    end
  end # class Boolean
end; end # class RDF::Literal
