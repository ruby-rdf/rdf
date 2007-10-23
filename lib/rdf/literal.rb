module RDF
  class Literal < Node
    XSD = RDF::Namespaces::XSD

    attr_reader :value
    attr_reader :language
    attr_reader :type

    def self.wrap(value) # FIXME
      literal = self.new(value)
      literal.type.nil? ? value : literal
    end

    def initialize(value, options = {})
      @value = value
      @language = options[:language] ? options[:language].to_s.downcase.to_sym : nil

      if type = options[:type]
        @type = type.respond_to?(:uri) ? type : Resource.new(type.to_s)
      else
        @type = case value
          when String   then nil # XSD.string
          when TrueClass, FalseClass then XSD.boolean
          when Fixnum   then XSD.int
          when Integer  then XSD.long # FIXME
          when Float
            @value = case
              when value.nan? then 'NaN'
              when value.infinite? then value.to_s[0...-'inity'.length].upcase
              else value.to_f
            end
            @type = XSD.double
          when Time, Date, DateTime
            require 'time'
            @value = value.respond_to?(:xmlschema) ? value.xmlschema : value.to_s
            @type = case value
              when DateTime then XSD.dateTime
              when Date     then XSD.date
              when Time     then XSD.dateTime
            end
        end
      end

      @value = @value.to_s
    end

    def ==(other)
      value == other.value && language == other.language && type == other.type
    end

    def to_s
      quoted = value # FIXME
      output = "\"#{quoted}\""
      output << "@#{language}" if language
      output << "^^#{type}" if type
      output
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

  end
end
