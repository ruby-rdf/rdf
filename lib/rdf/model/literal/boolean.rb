module RDF; class Literal
  ##
  # A boolean literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#boolean
  # @since 0.2.1
  class Boolean < Literal
    DATATYPE = XSD.boolean
    GRAMMAR  = /^(true|false|1|0)$/i.freeze
    TRUES    = %w(true  1).freeze
    FALSES   = %w(false 0).freeze

    ##
    # @param  [Boolean] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when true.equal?(value)  then true
        when false.equal?(value) then false
        when TRUES.include?(value.to_s.downcase)  then true
        when FALSES.include?(value.to_s.downcase) then false
        else value
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#boolean-canonical-representation
    def canonicalize!
      @string = (@object ? :true : :false).to_s
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
        when TrueClass, FalseClass
          to_i <=> (other ? 1 : 0)
        when RDF::Literal::Boolean
          to_i <=> other.to_i
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
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.to_s
    end

    ##
    # Returns the value as an integer.
    #
    # @return [Integer] `0` or `1`
    # @since  0.3.0
    def to_i
      @object ? 1 : 0
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
  end # Boolean
end; end # RDF::Literal
