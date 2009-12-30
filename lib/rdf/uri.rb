require 'addressable/uri'

module RDF
  ##
  # A Uniform Resource Identifier (URI).
  class URI < Node
    ##
    # @param  [String] uri
    # @return [URI]
    def self.parse(uri)
      self.new(uri)
    end

    ##
    # @param  [URI, String, #to_s] uri
    def initialize(uri)
      @uri = case uri
        when Addressable::URI then uri
        else Addressable::URI.parse(uri.to_s)
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
    # @param  [URI] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(URI) && self == other
    end

    ##
    # @param  [Object] other
    # @return [Boolean]
    def ==(other)
      other.respond_to?(:to_uri) && @uri == other.to_uri
    end

    ##
    # @return [URI]
    def to_uri
      @uri
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
