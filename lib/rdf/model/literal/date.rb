module RDF; class Literal
  ##
  # A date literal.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#date
  # @see   https://www.w3.org/TR/xmlschema11-2/#rf-lexicalMappings-datetime
  # @since 0.2.1
  class Date < Temporal
    DATATYPE = RDF::URI("http://www.w3.org/2001/XMLSchema#date")
    GRAMMAR  = %r(\A(#{YEARFRAG}-#{MONTHFRAG}-#{DAYFRAG})(#{TZFRAG})?\z).freeze
    FORMAT   = '%Y-%m-%d'.freeze

    ##
    # Internally, a `Date` is represented using a native `::DateTime` object at midnight. If initialized from a `::Date`, there is no timezone component, If initialized from a `::DateTime`, the timezone is taken from that native object, otherwise, a timezone (or no timezone) is taken from the string representation having a matching `zzzzzz` component.
    #
    # @note If initialized using the `#to_datetime` method, time component is unchanged. Otherewise, it is set to 00:00 (midnight).
    #
    # @param  [String, Date, #to_datetime] value
    # @param  (see Literal#initialize)
    def initialize(value, datatype: nil, lexical: nil, **options)
      @datatype = RDF::URI(datatype || self.class.const_get(:DATATYPE))
      @string   = lexical || (value if value.is_a?(String))
      @object   = case
        when value.class == ::Date
          @zone = nil
          # Use midnight as midpoint of the interval
          ::DateTime.parse(value.strftime('%FT00:00:00'))
        when value.respond_to?(:to_datetime)
          value.to_datetime
        else
          md = value.to_s.match(GRAMMAR)
          _, dt, tz = Array(md)
          if tz
            @zone = tz == 'Z' ? '+00:00' : tz
          else
            @zone = nil # No timezone
          end
          # Use midnight as midpoint of the interval
          ::DateTime.parse("#{dt}T00:00:00#{@zone}")
      end rescue ::DateTime.new
    end

    ##
    # Returns a human-readable value for the literal
    #
    # @return [String]
    # @since 1.1.6
    def humanize(lang = :en)
      d = object.strftime("%A, %d %B %Y")
      if timezone?
        d += if @zone == '+00:00'
          " UTC"
        else
          " #{@zone}"
        end
      end
      d
    end
  end # Date
end; end # RDF::Literal
