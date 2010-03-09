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
  class Literal < Value
    # @return [String] The normalized string representation of the value.
    attr_accessor :value

    # @return [Symbol] The language tag (optional).
    attr_accessor :language

    # @return [URI] The XML Schema datatype URI (optional).
    attr_accessor :datatype

    ##
    # @param  [Object]
    # @option options [Symbol] :language (nil)
    # @option options [URI]    :datatype (nil)
    def initialize(value, options = {})
      @value = value
      @language = options[:language] ? options[:language].to_s.to_sym : nil

      if datatype = options[:datatype]
        @datatype = datatype.respond_to?(:to_uri) ? datatype.to_uri : URI.new(datatype.to_s)
      else
        @datatype = case value
          when String     then nil # implicit XSD.string
          when TrueClass  then XSD.boolean
          when FalseClass then XSD.boolean
          when Fixnum     then XSD.integer
          when Integer    then XSD.integer
          when Float
            @value = case
              when value.nan? then 'NaN'
              when value.infinite? then value.to_s[0...-'inity'.length].upcase
              else value.to_f
            end
            XSD.double
          when Time, Date, DateTime
            require 'time'
            @value = value.respond_to?(:xmlschema) ? value.xmlschema : value.to_s
            case value
              when DateTime then XSD.dateTime
              when Date     then XSD.date
              when Time     then XSD.dateTime
            end
          else
            require 'bigdecimal' unless defined?(BigDecimal)
            case value
              when BigDecimal
                case
                  when value.nan?      then 'NaN'
                  when value.infinite? then value.to_s[0...-'inity'.length].upcase
                  when value.finite?   then value.to_s('F')
              end
            end
        end
      end

      @value = @value.to_s
    end

    ##
    # @return [Object]
    def object
      case datatype
        when XSD.string, nil
          value
        when XSD.boolean
          %w(true 1).include?(value)
        when XSD.double, XSD.float
          value.to_f
        when XSD.integer, XSD.long, XSD.int, XSD.short, XSD.byte
          value.to_i
        when XSD.decimal
          require 'bigdecimal' unless defined?(BigDecimal)
          BigDecimal.new(value)
        when XSD.date
          require 'date' unless defined?(Date)
          Date.parse(value)
        when XSD.dateTime
          require 'date' unless defined?(DateTime)
          DateTime.parse(value)
        when XSD.time
          require 'time'
          Time.parse(value)
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
    # Returns a string representation of this literal.
    #
    # @return [String]
    def to_s
      quoted = value # FIXME
      output = "\"#{quoted}\""
      output << "@#{language}" if language
      output << "^^<#{datatype}>" if datatype
      output
    end
  end
end
