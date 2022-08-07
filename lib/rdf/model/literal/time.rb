# coding: utf-8
module RDF; class Literal
  ##
  # A time literal.
  #
  # The lexical representation for time is the left truncated lexical
  # representation for `xsd:dateTime`: "hh:mm:ss.sss" with an optional
  # following time zone indicator.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#time
  # @see   https://www.w3.org/TR/xmlschema11-2/#rf-lexicalMappings-datetime
  # @since 0.2.1
  class Time < Temporal
    DATATYPE = RDF::URI("http://www.w3.org/2001/XMLSchema#time")
    GRAMMAR  = %r(\A((?:#{HOURFRAG}:#{MINUTEFRAG}:#{SECONDFRAG})|#{EODFRAG})(#{TZFRAG})?\z).freeze
    FORMAT   = '%H:%M:%S.%L'.freeze

    ##
    # Internally, a `DateTime` is represented using a native `::DateTime`. If initialized from a `::DateTime`, the timezone is taken from that native object, otherwise, a timezone (or no timezone) is taken from the string representation having a matching `zzzzzz` component.
    #
    # @param  [String, DateTime, #to_datetime] value
    # @param  (see Literal#initialize)
    def initialize(value, datatype: nil, lexical: nil, **options)
      @datatype = RDF::URI(datatype || self.class.const_get(:DATATYPE))
      @string   = lexical || (value if value.is_a?(String))
      @object   = case
        when value.respond_to?(:to_datetime)
          dt = value.to_datetime
          @zone = dt.zone
          # Normalize to 1972-12-31 dateTime base
          hms = dt.strftime(FORMAT)
          ::DateTime.parse("1972-12-31T#{hms}#{@zone}")
        else
          md = value.to_s.match(GRAMMAR)
          _, tm, tz = Array(md)
          if tz
            @zone = tz == 'Z' ? '+00:00' : tz
          else
            @zone = nil # No timezone
          end
          # Normalize 24:00:00 to 00:00:00
          hr, mi, se = tm.split(':')
          if hr.to_i > 23
            hr = "%.2i" % (hr.to_i % 24)
            @string = nil
          end
          value = "#{hr}:#{mi}:#{se}"
          # Normalize to 1972-12-31 dateTime base
          ::DateTime.parse("1972-12-31T#{hr}:#{mi}:#{se}#{@zone}")
      end rescue ::DateTime.new
    end

    ##
    # Returns a human-readable value for the literal
    #
    # @return [String]
    # @since 1.1.6
    def humanize(lang = :en)
      t = object.strftime("%r")
      if timezone?
        z = @zone == '+00:00' ? "UTC" : @zone
        t += " #{z}"
      end
      t
    end
  end # Time
end; end # RDF::Literal
