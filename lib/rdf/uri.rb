require 'addressable/uri'

module RDF
  ##
  # A Uniform Resource Identifier (URI).
  class URI < Node
    def self.parse(uri)
      self.new(uri)
    end

    def initialize(uri)
      @uri = case uri
        when Addressable::URI then uri
        else Addressable::URI.parse(uri.to_s)
      end
    end

    def anonymous?
      false
    end

    def eql?(other)
      other.is_a?(URI) && self == other
    end

    def ==(other)
      other.respond_to?(:to_uri) && @uri == other.to_uri
    end

    def to_uri
      @uri
    end

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
