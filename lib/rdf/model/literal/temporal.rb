module RDF; class Literal
  ##
  # Shared methods and class ancestry for date, time, and dateTime literal classes.
  #
  # @since 3.1
  class Temporal < Literal
    # Matches either -10:00 or -P1H0M forms
    ZONE_GRAMMAR  = %r(\A
       (?:(?<si>[+-])(?<hr>\d{2}):(?:(?<mi>\d{2}))?)
      |(?:(?<si>-)?PT(?<hr>\d{1,2})H(?:(?<mi>\d{1,2})M)?)
    \z)x.freeze

    YEARFRAG = %r(-?(?:(?:[1-9]\d{3,})|(?:0\d{3})))
    MONTHFRAG = %r((?:(?:0[1-9])|(?:1[0-2])))
    DAYFRAG = %r((?:(?:0[1-9])|(?:[12]\d)|(?:3[01])))
    HOURFRAG = %r((?:[01]\d)|(?:2[0-3]))
    MINUTEFRAG = %r([0-5]\d)
    SECONDFRAG = %r([0-5]\d(?:\.\d+)?)
    EODFRAG = %r(24:00:00(?:\.0+)?)
    TZFRAG = %r((?:[\+\-]\d{2}:\d{2})|UTC|GMT|Z)

    ##
    # Compares this literal to `other` for sorting purposes.
    #
    # @param  [Object] other
    # @return [Integer] `-1`, `0`, or `1`
    def <=>(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid? && (!other.respond_to?(:valid?) || other.valid?)
      return super unless other.is_a?(self.class)
      @object <=> other.object
    end

    ##
    # Returns `true` if this literal is equal to `other`.
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def ==(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid? && (!other.respond_to?(:valid?) || other.valid?)

      case other
      when self.class
        self.object == other.object
      when Literal::Temporal
        false
      else
        super
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    # with date and time normalized to UTC.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema11-2/#dateTime
    def canonicalize!
      if self.valid? && @zone && @zone != '+00:00'
        adjust_to_timezone!
      else
        @string = nil
      end
      self
    end

    ##
    # Returns the timezone part of arg as a simple literal. Returns the empty string if there is no timezone.
    #
    # @return [RDF::Literal]
    def tz
      RDF::Literal(@zone == "+00:00" ? 'Z' : @zone)
    end

    ##
    # Does the literal representation include a timezone? Note that this is only possible if initialized using a string, or `:lexical` option.
    #
    # @return [Boolean]
    # @since 1.1.6
    def timezone?
      # Can only know there's a timezone from the string represntation
      md = to_s.match(self.class.const_get(:GRAMMAR))
      md && !!md[2]
    end
    alias_method :tz?, :timezone?
    alias_method :has_tz?, :timezone?
    alias_method :has_timezone?, :timezone?

    ##
    # Returns the timezone part of arg as an xsd:dayTimeDuration, or `nil`
    # if lexical form of literal does not include a timezone.
    #
    # From [fn:timezone-from-date](https://www.w3.org/TR/xpath-functions/#func-timezone-from-date).
    #
    # @return [RDF::Literal]
    # @see https://www.w3.org/TR/xpath-functions/#func-timezone-from-date
    def timezone
      if @zone
        md = @zone.match(ZONE_GRAMMAR)
        si, hr, mi = md[:si], md[:hr].to_i, md[:mi].to_i
        si = nil unless si == "-"
        res = "#{si}PT#{hr}H#{"#{mi}M" if mi > 0}"
        RDF::Literal(res, datatype: RDF::URI("http://www.w3.org/2001/XMLSchema#dayTimeDuration"))
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
    # Does the literal representation include millisectonds?
    #
    # @return [Boolean]
    # @since 1.1.6
    def milliseconds?
      object.strftime("%L").to_i > 0
    end
    alias_method :has_milliseconds?, :milliseconds?
    alias_method :has_ms?, :milliseconds?
    alias_method :ms?, :milliseconds?

    ##
    # Returns the `timezone` of the literal. If the
    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string ||= (@object.strftime(self.class.const_get(:FORMAT)).sub('.000', '') + self.tz)
    end

    ##
    # Adjust the timezone.
    #
    # From [fn:adjust-dateTime-to-timezone](https://www.w3.org/TR/xpath-functions/#func-adjust-dateTime-to-timezone)
    #
    # @overload adjust_to_timezone!
    #   Adjusts the timezone to UTC.
    #
    #   @return [Temporal] `self`
    #   @raise [RangeError] if `zone < -14*60` or `zone > 14*60`
    # @overload adjust_to_timezone!(zone)
    #   If `zone` is nil, then the timzeone component is removed.
    #
    #   Otherwise, the timezone is set based on the difference between the current timezone offset (if any) and `zone`.
    #
    #   @param [DayTimeDuration, String] zone (nil) In the form of {ZONE_GRAMMAR}.
    #   @return [Temporal] `self`
    #   @raise [RangeError] if `zone < -14*60` or `zone > 14*60`
    # @see https://www.w3.org/TR/xpath-functions/#func-adjust-dateTime-to-timezone
    def adjust_to_timezone!(*args)
      zone = args.empty? ? '+00:00' : args.first
      if zone.to_s.empty?
        # Remove timezone component
        @object = self.class.new(@object.strftime(self.class.const_get(:FORMAT))).object
        @zone = nil
      else
        md = zone.to_s.match(ZONE_GRAMMAR)
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
        @object = self.class.new(dt.strftime(self.class.const_get(:FORMAT) + new_zone)).object
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
    #   @return [DateTime]
    #   @raise (see #adjust_to_timezone!)
    # @overload adjust_to_timezone(zone) (see #adjust_to_timezone!)
    #   @return [DateTime]
    #   @raise (see #adjust_to_timezone!)
    def adjust_to_timezone(*args)
      self.dup.adjust_to_timezone!(*args)
    end

    ##
    # Add a Duration to a Temporal.
    #
    # For YearMonthDuration, turns duration into months and adds to internal DateTime object.
    #
    # For DayTimeDuration, turns duration into rational days, and adds to internal DateTime object.
    #
    # @note This depends on the parameter responding to `#to_i` or `#to_r`, which for Duration types, is implemented in the rdf-xsd gem.
    #
    # @param [YearMonthDuration, DayTimeDuration] other
    # @return [Temporal]
    # @see https://www.w3.org/TR/xpath-functions/#func-add-yearMonthDuration-to-dateTime
    # @see https://www.w3.org/TR/xpath-functions/#func-add-dayTimeDuration-to-dateTime
    def +(other)
      new_dt = case other
      when YearMonthDuration
        @object >> other.to_i
      when DayTimeDuration
        @object + other.to_r
      else
        return super
      end

      dt = new_dt.strftime(self.class.const_get(:FORMAT)) + tz
      self.class.new(dt)
    rescue NoMethodError => e
      raise "Consider including the rdf-xsd class for method implementaions: #{e.message}"
    end

    ##
    # Subtract times or durations from a temporal.
    #
    # @overload +(other)
    #   For YearMonthDuration, turns duration into months and subtracts from internal DateTime object resulting in a new {Temporal} object.
    #
    #   For DayTimeDuration, turns duration into rational days, and subtracts from internal DateTime object resulting in a new {Temporal} object.
    #
    #   For Temporal, subtracts the two moments resulting in a `xsd:dayTimeDuration`.
    #
    #   @param [YearMonthDuration, DayTimeDurationm, Temporal] other
    #   @return [Temporal, DayTimeDuration]
    #   @note This depends on the parameter responding to `#to_i` or `#to_r`, which for Duration types, is implemented in the rdf-xsd gem.
    #   @see https://www.w3.org/TR/xpath-functions/#func-subtract-yearMonthDuration-from-dateTime
    #   @see https://www.w3.org/TR/xpath-functions/#func-subtract-dayTimeDuration-from-dateTime
    #   @see https://www.w3.org/TR/xpath-functions/#func-subtract-dateTimes
    def -(other)
      new_dt = case other
      when YearMonthDuration
        @object << other.to_i
      when DayTimeDuration
        @object - other.to_r
      when Temporal
        @object - other.object
      else
        return super
      end

      if new_dt.is_a?(Rational)
        RDF::Literal(new_dt, datatype: RDF::XSD.dayTimeDuration)
      else
        dt = new_dt.strftime(self.class.const_get(:FORMAT)) + tz
        self.class.new(dt)
      end
    rescue NoMethodError => e
      raise "Consider including the rdf-xsd class for method implementaions: #{e.message}"
    end

    # Years
    #
    # From the XQuery function [fn:year-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-year-from-dateTime).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-year-from-dateTime
    def year; Integer.new(object.year); end

    # Months
    #
    # From the XQuery function [fn:month-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-month-from-dateTime).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-month-from-dateTime
    def month; Integer.new(object.month); end

    # Days
    #
    # From the XQuery function [fn:day-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-day-from-dateTime).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-day-from-dateTime
    def day; Integer.new(object.day); end

    # Hours
    #
    # From the XQuery function [fn:hours-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-hours-from-dateTime).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-hours-from-dateTime
    def hours; Integer.new(object.hour); end

    # Minutes
    #
    # From the XQuery function [fn:minutes-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-minutes-from-dateTime).
    #
    # @return [Integer]
    # @see https://www.w3.org/TR/xpath-functions/#func-minutes-from-dateTime
    def minutes; Integer.new(object.min); end

    # Seconds
    #
    # From the XQuery function [fn:seconds-from-dateTime](https://www.w3.org/TR/xpath-functions/#func-seconds-from-dateTime).
    #
    # @return [Decimal]
    # @see https://www.w3.org/TR/xpath-functions/#func-seconds-from-dateTime
    def seconds; Decimal.new(object.strftime("%S.%L")); end
  end # Temporal
end; end # RDF::Literal
