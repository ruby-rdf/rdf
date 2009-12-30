module RDF
  ##
  # An RDF literal.
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
          when Fixnum     then XSD.int
          when Integer    then XSD.long # FIXME
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
        end
      end

      @value = @value.to_s
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
    # @return [Boolean]
    def plain?
      language.nil? && datatype.nil?
    end

    ##
    # @return [Boolean]
    def typed?
      !datatype.nil?
    end

    ##
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
