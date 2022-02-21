module RDF; class Literal
  ##
  # A date literal.
  #
  # @see   http://www.w3.org/TR/xmlschema11-2/#date
  # @since 0.2.1
  class Date < Literal
    DATATYPE = RDF::URI("http://www.w3.org/2001/XMLSchema#date")
    GRAMMAR  = %r(\A(-?\d{4}-\d{2}-\d{2})((?:[\+\-]\d{2}:\d{2})|UTC|GMT|Z)?\Z).freeze
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
          dt = value.to_datetime
          @zone = dt.zone
          dt
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
    # Converts this literal into its canonical lexical representation.
    #
    # Note that the timezone is recoverable for xsd:date, where it is not for xsd:dateTime and xsd:time, which are both transformed relative to Z, if a timezone is provided.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema11-2/#date
    def canonicalize!
       if self.valid? && @zone && @zone != '+00:00'
         adjust_to_timezone!
       else
         @string = nil
       end
      self
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
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || (@object.strftime(FORMAT) + self.tz)
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

    ##
    # Does the literal representation include a timezone? Note that this is only possible if initialized using a string, or `:lexical` option.
    #
    # @return [Boolean]
    # @since 1.1.6
    def timezone?
      !@zone.nil?
    end
    alias_method :tz?, :timezone?
    alias_method :has_tz?, :timezone?
    alias_method :has_timezone?, :timezone?

    ##
    # Adjust the timezone.
    #
    # From [fn:adjust-date-to-timezone](https://www.w3.org/TR/xpath-functions/#func-adjust-date-to-timezone)
    #
    # @overload adjust_to_timezone!
    #   Adjusts the timezone to UTC.
    #
    #   @return [Date] `self`
    #   @raise [RangeError] if `zone < -14*60` or `zone > 14*60`
    # @overload adjust_to_timezone!(zone)
    #   If `zone` is nil, then the timzeone component is removed.
    #
    #   Otherwise, the timezone is set based on the difference between the current timezone offset (if any) and `zone`.
    #
    #   @param [String] zone (nil) In the form of {ZONE_FORMAT}
    #   @return [Date] `self`
    #   @raise [RangeError] if `zone < -14*60` or `zone > 14*60`
    # @see https://www.w3.org/TR/xpath-functions/#func-adjust-date-to-timezone
    def adjust_to_timezone!(*args)
      zone = args.empty? ? '+00:00' : args.first
      if zone.nil?
        # Remove timezone component
        @object = ::DateTime.parse(@object.strftime('%F'))
        @zone = nil
      else
        md = zone.match(Literal::DateTime::ZONE_GRAMMAR) if zone
        raise ArgumentError,
              "expected #{zone.inspect} to be a xsd:dayTimeDuration or +/-HH:MM" unless md
        # Adjust to zone
        si, hr, mi = md[:si], md[:hr], md[:mi]
        si ||= '+'
        offset = hr.to_i * 60 + mi.to_i
        raise ArgumentError,
              "Zone adjustment of #{zone} out of range" if
              md.nil? || offset > 14*60

        new_zone = "%s%.2d:%.2d" % [si, hr.to_i, mi.to_i]
        dt = @zone.nil? ? @object : @object.new_offset(new_zone)
        @object = ::DateTime.parse(dt.strftime("%FT00:00:00#{new_zone}"))
        @zone = new_zone
      end
      @string = nil
      self
    end

    ##
    # Functional version of `#adjust_to_timezone!`.
    #
    # @overload adjust_to_timezone
    #   @param (see #adjust_to_timezone!)
    #   @return [Date]
    #   @raise (see #adjust_to_timezone!)
    # @overload adjust_to_timezone(zone) (see #adjust_to_timezone!)
    #   @return [Date]
    #   @raise (see #adjust_to_timezone!)
    def adjust_to_timezone(*args)
      self.dup.adjust_to_timezone!(*args)
    end

    ##
    # Returns the timezone part of arg as a simple literal. Returns the empty string if there is no timezone.
    #
    # @return [RDF::Literal]
    # @since 1.1.6
    def tz
      RDF::Literal(@zone == "+00:00" ? 'Z' : @zone)
    end

    ##
    # Returns the timezone part of arg as an xsd:dayTimeDuration, or `nil`
    # if lexical form of literal does not include a timezone.
    #
    # From [fn:timezone-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-timezone-from-dateTime).
    #
    # @return [RDF::Literal]
    # @see https://www.w3.org/TR/xpath-functions/#func-timezone-from-dateTime
    def timezone
      if @zone
        md = @zone.match(Literal::DateTime::ZONE_GRAMMAR)
        si, hr, mi = md[:si], md[:hr].to_i, md[:mi].to_i
        si = nil unless si == "-"
        res = "#{si}PT#{hr}H#{"#{mi}M" if mi > 0}"
        RDF::Literal(res, datatype: RDF::URI("http://www.w3.org/2001/XMLSchema#dayTimeDuration"))
      end
    end

    ##
    # Updates the date to a new timezone, or no timezone.
    ##
    # Equal compares as Date objects
    #
    # From the XQuery function [op:date-equal](https://www.w3.org/TR/xpath-functions/#func-date-equal).
    #
    # @param [Date, Literal] other
    # @return [Boolean]
    # @see https://www.w3.org/TR/xpath-functions/#func-date-equal
    def ==(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid? && (!other.respond_to?(:valid?) || other.valid?)

      case other
      when Literal::Date
        return super unless other.valid?
        self.object == other.object
      when Literal::Time, Literal::DateTime
        false
      else
        super
      end
    end

    ##
    # Compares `self` to `other` for sorting purposes (with type check).
    #
    # @param  [Object]  other
    # @return [Integer] `-1`, `0`, or `1`
    def <=>(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid? && (!other.respond_to?(:valid?) || other.valid?)
      return super unless other.is_a?(Date)
      @object <=> other.object
    end

    # Years
    #
    # From the XQuery function [fn:year-from-date](https://www.w3.org/TR/xpath-functions/#func-year-from-date).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-year-from-date
    def year; Integer.new(object.year); end

    # Months
    #
    # From the XQuery function [fn:month-from-date](https://www.w3.org/TR/xpath-functions/#func-month-from-date).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-month-from-date
    def month; Integer.new(object.month); end

    # Days
    #
    # From the XQuery function [fn:day-from-date](https://www.w3.org/TR/xpath-functions/#func-day-from-date).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-day-from-date
    def day; Integer.new(object.day); end
  end # Date
end; end # RDF::Literal
