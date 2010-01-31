require 'addressable/uri'

module RDF
  ##
  # A Uniform Resource Identifier (URI).
  #
  # RDF::URIs support all methods available for {Addressable::URI}.
  #
  # @example Creating a URI reference
  #   uri = RDF::URI.new("http://rdf.rubyforge.org/")
  #
  # @example Getting the string representation of a URI
  #   uri.to_s #=> "http://rdf.rubyforge.org/"
  #
  # @see http://en.wikipedia.org/wiki/Uniform_Resource_Identifier
  # @see http://addressable.rubyforge.org/
  class URI < Node
    ##
    # @param  [String] uri
    # @return [URI]
    def self.parse(uri)
      self.new(uri)
    end

    ##
    # @overload uri(uri)
    #   @param  [URI, String, #to_s]    uri
    #
    # @overload uri(options = {})
    #   @param  [Hash{Symbol => Object} options
    def initialize(uri_or_options)
      case uri_or_options
        when Hash
          @uri = Addressable::URI.new(uri_or_options)
        when Addressable::URI
          @uri = uri_or_options
        else
          @uri = Addressable::URI.parse(uri_or_options.to_s)
      end
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    def uri?
      true
    end

    ##
    # Returns `false`.
    #
    # @return [Boolean]
    def anonymous?
      false
    end

    ##
    # Returns a duplicate copy of `self`.
    #
    # @return [RDF::URI]
    def dup
      self.class.new(@uri.dup)
    end

    ##
    # @param  [URI] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(URI) && self == other
    end

    ##
    # @param  [Object] other
    # @return [Boolean]
    def ==(other)
      case other
        when Addressable::URI
          to_s == other.to_s
        else
          other.respond_to?(:to_uri) && to_s == other.to_uri.to_s
      end
    end

    ##
    # @return [URI]
    def to_uri
      self
    end

    ##
    # @return [String]
    def to_s
      @uri.to_s
    end

    protected

      def respond_to?(symbol) #:nodoc:
        @uri.respond_to?(symbol) || super
      end

      def method_missing(symbol, *args, &block) #:nodoc:
        if @uri.respond_to?(symbol)
          @uri.send(symbol, *args, &block)
        else
          super
        end
      end
  end
end
