module RDF
  class URIRef < Node

    attr_reader :uri

    @@uris = {}

    def self.new(uri) #:nodoc:
      # URI references are interned here, meaning that only one URIRef
      # instance is ever created and returned for the same URI reference
      @@uris[uri.to_s] ||= super
    end

    def initialize(uri)
      @uri = uri
    end

    def ==(other)
      uri == other.uri
    end

    def qname
      if uri =~ /([\w\d\-_]+)$/
        suffix = $1
        if prefix = Namespace.prefix_for(uri[0...-suffix.length])
          "#{prefix}:#{suffix}"
        else
          nil
        end
      end
    end

    def to_uri
      @uri
    end

    def to_s
      "<#{qname || uri}>"
    end

    def inspect
      "#<#{self.class} #{qname || uri}>"
    end

  end
end
