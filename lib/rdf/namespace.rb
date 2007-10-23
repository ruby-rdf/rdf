module RDF
  class Namespace

    class << self
      @@prefixes ||= {}

      def prefixes
        @@prefixes
      end

      def prefix_for(uri)
        @@prefixes.index(uri)
      end

      def register!(*args)
        if args.length == 1
          args.first.each { |k, v| @@prefixes[k.to_sym] = v.to_s }
        else
          prefix, uri = args
          @@prefixes[prefix.to_sym] = uri.to_s
        end
      end

      def unregister!(prefix)
        @@prefixes.delete(prefix.to_sym)
      end

      def [](prefix)
        raise ArgumentError.new("prefix must be a symbol, but #{prefix.inspect} given") unless prefix.is_a?(Symbol)
        raise ArgumentError.new("prefix #{prefix.inspect} not registered") unless @@prefixes.has_key?(prefix)
        self.new(@@prefixes[prefix.to_sym])
      end
    end

    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    def [](suffix)
      Resource.new("#{uri}#{suffix}", :rdfs)
    end

    def method_missing(method, *args, &block)
      self[method.to_s.gsub('_', '-')]
    end

    def prefix
      self.class.prefix_for(uri)
    end

    def to_s
      "{#{uri}}"
    end

    def inspect
      "#<#{self.class} #{uri}>"
    end

  end
end
