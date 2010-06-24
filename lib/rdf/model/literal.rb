module RDF
  ##
  # An RDF literal.
  #
  # @example Creating a plain literal
  #   value = RDF::Literal.new("Hello, world!")
  #   value.plain?                                   #=> true
  #
  # @example Creating a language-tagged literal (1)
  #   value = RDF::Literal.new("Hello!", :language => :en)
  #   value.has_language?                            #=> true
  #   value.language                                 #=> :en
  #
  # @example Creating a language-tagged literal (2)
  #   RDF::Literal.new("Wazup?", :language => :"en-US")
  #   RDF::Literal.new("Hej!",   :language => :sv)
  #   RDF::Literal.new("¡Hola!", :language => :es)
  #
  # @example Creating an explicitly datatyped literal
  #   value = RDF::Literal.new("2009-12-31", :datatype => RDF::XSD.date)
  #   value.has_datatype?                            #=> true
  #   value.datatype                                 #=> RDF::XSD.date
  #
  # @example Creating an implicitly datatyped literal
  #   value = RDF::Literal.new(Date.today)
  #   value.has_datatype?                            #=> true
  #   value.datatype                                 #=> RDF::XSD.date
  #
  # @example Creating implicitly datatyped literals
  #   RDF::Literal.new(false).datatype               #=> XSD.boolean
  #   RDF::Literal.new(true).datatype                #=> XSD.boolean
  #   RDF::Literal.new(123).datatype                 #=> XSD.integer
  #   RDF::Literal.new(9223372036854775807).datatype #=> XSD.integer
  #   RDF::Literal.new(3.1415).datatype              #=> XSD.double
  #   RDF::Literal.new(Time.now).datatype            #=> XSD.dateTime
  #   RDF::Literal.new(Date.new(2010)).datatype      #=> XSD.date
  #   RDF::Literal.new(DateTime.new(2010)).datatype  #=> XSD.dateTime
  #
  # @see http://www.w3.org/TR/rdf-concepts/#section-Literals
  # @see http://www.w3.org/TR/rdf-concepts/#section-Datatypes-intro
  class Literal
    autoload :Boolean,  'rdf/model/literal/boolean'
    autoload :Integer,  'rdf/model/literal/integer'
    autoload :Double,   'rdf/model/literal/double'
    autoload :Decimal,  'rdf/model/literal/decimal'
    autoload :Date,     'rdf/model/literal/date'
    autoload :DateTime, 'rdf/model/literal/datetime'
    autoload :XML,      'rdf/model/literal/xml'

    include RDF::Value

    ##
    # @private
    def self.new(value, options = {})
      klass = case value
        when ::TrueClass  then RDF::Literal::Boolean
        when ::FalseClass then RDF::Literal::Boolean
        when ::Integer    then RDF::Literal::Integer
        when ::Float      then RDF::Literal::Double
        when ::BigDecimal then RDF::Literal::Decimal
        when ::DateTime   then RDF::Literal::DateTime
        when ::Date       then RDF::Literal::Date
        when ::Time       then RDF::Literal::DateTime
        else RDF::Literal
      end
      literal = klass.allocate
      literal.send(:initialize, value, options)
      literal
    end

    # @return [Symbol] The language tag (optional).
    attr_accessor :language

    # @return [URI] The XML Schema datatype URI (optional).
    attr_accessor :datatype

    ##
    # @param  [Object] value
    # @option options [Symbol] :language (nil)
    # @option options [URI]    :datatype (nil)
    def initialize(value, options = {})
      @object   = value
      @string   = options[:lexical] if options.has_key?(:lexical)
      @language = options[:language].to_s.to_sym if options[:language]
      @datatype = RDF::URI(options[:datatype]) if options[:datatype]
    end

    ##
    # Returns the value as a string.
    #
    # @return [String] 
    def value
      @string || @object.to_s
    end

    ##
    # @return [Object]
    def object
      @object || case datatype
        when XSD.string, nil
          value
        when XSD.boolean
          %w(true 1).include?(value)
        when XSD.double, XSD.float
          value.to_f
        when XSD.integer, XSD.long, XSD.int, XSD.short, XSD.byte
          value.to_i
        when XSD.decimal
          ::BigDecimal.new(value)
        when XSD.date
          ::Date.parse(value)
        when XSD.dateTime
          ::DateTime.parse(value)
        when XSD.time
          ::Time.parse(value)
        when XSD.nonPositiveInteger, XSD.negativeInteger
          value.to_i
        when XSD.nonNegativeInteger, XSD.positiveInteger
          value.to_i
        when XSD.unsignedLong, XSD.unsignedInt, XSD.unsignedShort, XSD.unsignedByte
          value.to_i
      end
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    def literal?
      true
    end

    ##
    # Returns `false`.
    #
    # @return [Boolean]
    def anonymous?
      false
    end

    ##
    # @return [Boolean]
    def eql?(other)
      other.is_a?(Literal) && self == other
    end

    ##
    # @return [Boolean]
    def ==(other)
      case other
        when Literal
          value.eql?(other.value) &&
          language.eql?(other.language) &&
          datatype.eql?(other.datatype)
        when String
          value.eql?(other) &&
            language.nil? &&
            datatype.nil?
        else false
      end
    end

    ##
    # Returns `true` if this is a plain literal.
    #
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-plain-literal
    def plain?
      language.nil? && datatype.nil?
    end

    ##
    # Returns `true` if this is a language-tagged literal.
    #
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-plain-literal
    def has_language?
      !language.nil?
    end

    alias_method :language?, :has_language?

    ##
    # Returns `true` if this is a datatyped literal.
    #
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-typed-literal
    def has_datatype?
      !datatype.nil?
    end

    alias_method :datatype?,  :has_datatype?
    alias_method :typed?,     :has_datatype?
    alias_method :datatyped?, :has_datatype?

    ##
    # Returns `true` if the value adheres to the defined grammar of the
    # datatype.
    #
    # @return [Boolean]
    # @since  0.2.1
    def valid?
      grammar = self.class.const_get(:GRAMMAR) rescue nil
      grammar.nil? || !!(value =~ grammar)
    end

    ##
    # Returns `true` if the value does not adhere to the defined grammar of
    # the datatype.
    #
    # @return [Boolean]
    # @since  0.2.1
    def invalid?
      !valid?
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @since  0.2.1
    def canonicalize
      # subclasses should override this as needed
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      value
    end
  end
end
