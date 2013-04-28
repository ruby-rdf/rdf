module RDF; class Literal
  ##
  # A date/time literal.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#dateTime
  # @since 0.2.1
  class DateTime < Literal
    DATATYPE = XSD.dateTime
    GRAMMAR  = %r(\A-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(([\+\-]\d{2}:\d{2})|UTC|GMT|Z)?\Z).freeze

    ##
    # @param  [DateTime] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || self.class.const_get(:DATATYPE))
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   ||= value if value.is_a?(String)
      @has_timezone = @string.nil? || if md = @string.match(GRAMMAR)
        !!md[2] # If lexical value contains timezone
      end
      @object   = case
        when value.is_a?(::DateTime)         then value
        when value.respond_to?(:to_datetime) then value.to_datetime
        else ::DateTime.parse(value.to_s)
      end rescue nil
    end

    ##
    # Converts this literal into its canonical lexical representation.
    # with date and time normalized to UTC.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#dateTime
    def canonicalize!
      @string = @object.new_offset(0).strftime('%Y-%m-%dT%H:%M:%SZ') if self.valid?
      self
    end

    ##
    # Returns the timezone part of arg as a simple literal. Returns the empty string if there is no timezone.
    #
    # @return [RDF::Literal]
    # @see http://www.w3.org/TR/sparql11-query/#func-tz
    def tz
      zone =  @has_timezone ? object.zone : ""
      zone = "Z" if zone == "+00:00"
      RDF::Literal(zone)
    end

    ##
    # Returns the timezone part of arg as an xsd:dayTimeDuration, or `nil`
    # if lexical form of literal does not include a timezone.
    #
    # @return [RDF::Literal]
    def timezone
      if tz == 'Z'
        RDF::Literal("PT0S", :datatype => RDF::XSD.dayTimeDuration)
      elsif md = tz.to_s.match(/^([+-])?(\d+):(\d+)?$/)
        plus_minus, hour, min = md[1,3]
        plus_minus = nil unless plus_minus == "-"
        hour = hour.to_i
        min = min.to_i
        res = "#{plus_minus}PT#{hour}H#{"#{min}M" if min > 0}"
        RDF::Literal(res, :datatype => RDF::XSD.dayTimeDuration)
      end
    end

    ##
    # Returns `true` if the value adheres to the defined grammar of the
    # datatype.
    #
    # Special case for date and dateTime, for which '0000' is not a valid year
    #
    # @return [Boolean]
    # @since  0.2.1
    def valid?
      super && object && value !~ %r(\A0000)
    end

    ##
    # Returns the `timezone` of the literal. If the
    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.strftime('%Y-%m-%dT%H:%M:%S%:z').sub(/\+00:00|UTC|GMT/, 'Z')
    end

    ##
    # Equal compares as DateTime objects
    def ==(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid?

      case other
      when Literal::DateTime
        return super unless other.valid?
        self.object == other.object
      when Literal::Time, Literal::Date
        false
      else
        super
      end
    end
  end # DateTime
end; end # RDF::Literal
