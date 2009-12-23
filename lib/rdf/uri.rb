require 'addressable/uri'

module RDF
  ##
  # A Uniform Resource Identifier (URI).
  class URI < Resource
    attr_accessor :uri

    def self.parse(uri)
      self.new(uri)
    end

    def initialize(uri)
      @uri = Addressable::URI.parse(uri.to_s)
    end

    def to_s
      @uri.to_s
    end

    def respond_to?(symbol)
      @uri.respond_to?(symbol) || super
    end

    def method_missing(symbol, *args, &block)
      if @uri.respond_to?(symbol)
        @uri.send(symbol, *args, &block)
      else
        super
      end
    end
  end
end
