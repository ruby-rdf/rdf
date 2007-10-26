module RDF
  class URIRef < Node

    attr_reader :uri

    @@uris = {}

    def self.new(uri)
      @@uris[uri.to_s] ||= super
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

    protected

      def initialize(uri)
        @uri = uri
      end

  end
end
