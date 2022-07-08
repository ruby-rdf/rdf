module RDF; class Literal
  ##
  # A date/time literal.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#dateTime
  # @see   https://www.w3.org/TR/xmlschema11-2/#rf-lexicalMappings-datetime
  # @since 0.2.1
  class DateTime < Temporal
    DATATYPE = RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
    GRAMMAR  = %r(\A
      (#{YEARFRAG}
      -#{MONTHFRAG}
      -#{DAYFRAG}
      T
      (?:
       (?:
        #{HOURFRAG}
       :#{MINUTEFRAG}
       :#{SECONDFRAG})
      | #{EODFRAG}))
     (#{TZFRAG})?\z)x.freeze
    FORMAT   = '%Y-%m-%dT%H:%M:%S.%L'.freeze

    ##
    # Internally, a `DateTime` is represented using a native `::DateTime`. If initialized from a `::Date`, there is no timezone component, If initialized from a `::DateTime`, the timezone is taken from that native object, otherwise, a timezone (or no timezone) is taken from the string representation having a matching `zzzzzz` component.
    #
    # @param  [DateTime] value
    # @option options [String] :lexical (nil)
    def initialize(value, datatype: nil, lexical: nil, **options)
      @datatype = RDF::URI(datatype || self.class.const_get(:DATATYPE))
      @string   = lexical || (value if value.is_a?(String))
      @object   = case
        when value.is_a?(::DateTime)
          @zone = value.zone
          value
        when value.respond_to?(:to_datetime) 
          @zone = value.to_datetime.zone
          value.to_datetime
        else
          md = value.to_s.match(GRAMMAR)
          _, _, tz = Array(md)
          if tz
            @zone = tz == 'Z' ? '+00:00' : tz
          else
            @zone = nil # No timezone
          end
          ::DateTime.parse(value.to_s)
      end rescue ::DateTime.new
    end

    ##
    # Returns a human-readable value for the literal
    #
    # @return [String]
    # @since 1.1.6
    def humanize(lang = :en)
      d = object.strftime("%r on %A, %d %B %Y")
      if timezone?
        z = @zone == '+00:00' ? "UTC" : @zone
        d.sub!(" on ", " #{z} on ")
      end
      d
    end
  end # DateTime
end; end # RDF::Literal
