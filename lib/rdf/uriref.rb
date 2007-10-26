module RDF
  class URIRef < Node

    attr_reader :uri

    @@uris = {}

    # Yields every interned URI reference.
    def self.each(&block)
      !block_given? ? @@uris : @@uris.each(&block)
    end

    # Returns +true+ if the given URI reference has previously been interned.
    def self.known?(uri)
      @@uris.has_key? uri.to_s
    end

    def self.new(uri) #:nodoc:
      # URI references are interned here, meaning that only one URIRef
      # instance is ever created and returned for the same URI reference
      @@uris[uri.to_s] ||= super
    end

    def initialize(uri)
      @uri = uri
    end

    def anonymous?
      false
    end

    def ==(other)
      other.respond_to?(:to_uri) && uri == other.to_uri
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
