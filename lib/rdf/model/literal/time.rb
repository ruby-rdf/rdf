# coding: utf-8
module RDF; class Literal
  ##
  # A time literal.
  #
  # The lexical representation for time is the left truncated lexical
  # representation for `xsd:dateTime`: "hh:mm:ss.sss" with an optional
  # following time zone indicator.
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#time
  # @since 0.2.1
  class Time < Literal
    DATATYPE = XSD.time
    GRAMMAR  = %r(\A\d{2}:\d{2}:\d{2}(\.\d+)?(([\+\-]\d{2}:\d{2})|UTC|GMT|Z)?\Z).freeze

    ##
    # @param  [Time] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || self.class.const_get(:DATATYPE))
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   ||= value if value.is_a?(String)
      @object   = case
        when value.is_a?(::Time)         then value
        when value.respond_to?(:to_time) then value.to_time rescue ::Time.parse(value.to_s)
        else ::Time.parse(value.to_s)
      end rescue nil
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # §3.2.8.2 Canonical representation
    #
    # The canonical representation for time is defined by prohibiting
    # certain options from the Lexical representation (§3.2.8.1).
    # Specifically, either the time zone must be omitted or, if present, the
    # time zone must be Coordinated Universal Time (UTC) indicated by a "Z".
    # Additionally, the canonical representation for midnight is 00:00:00.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#time
    def canonicalize!
      @string = @object.utc.strftime('%H:%M:%SZ') if self.valid?
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
      super && !object.nil?
    end

    ##
    # Returns the value as a string.
    # Does not normalize timezone
    #
    # @return [String]
    def to_s
      @string || if RUBY_PLATFORM != 'java'
        @object.strftime('%H:%M:%S%:z').
        sub(/\+00:00|UTC|GMT/, 'Z')
      else
        # JRuby doesn't do timezone's properly, use utc_offset
        off = @object.utc_offset == 0 ? "Z" : ("%0.2d:00" % (@object.utc_offset/3600))
        @object.strftime("%H:%M:%S#{off}")
      end
    end

    ##
    # Equal compares as Time objects
    def ==(other)
      # If lexically invalid, use regular literal testing
      return super unless self.valid?

      case other
      when Literal::Time
        return super unless other.valid?
        # Compare as strings, as time includes a date portion, and adjusting for UTC
        # can create a mismatch in the date portion.
        self.object.utc.strftime('%H%M%S') == other.object.utc.strftime('%H%M%S')
      when Literal::DateTime, Literal::Date
        false
      else
        super
      end
    end
  end # Time
end; end # RDF::Literal
