module RDF
  ##
  # An RDF vocabulary.
  class Vocabulary

    def self.inspect
      if self == Vocabulary
        self.to_s
      else
        sprintf("%s(%s)", superclass.to_s, to_s)
      end
    end

    def self.to_uri() RDF::URI.parse(to_s) end
    def self.to_s()   @@uris.has_key?(self) ? @@uris[self].to_s : super end

    def self.[](property)
      RDF::URI.parse([to_s, property.to_s].join(''))
    end

    def self.property(symbol) end # TODO

    def initialize(uri)
      case uri
        when RDF::URI then @uri = uri.to_s
        else @uri = RDF::URI.parse(uri.to_s) ? uri.to_s : nil
      end
    end

    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    def to_uri() RDF::URI.parse(to_s) end
    def to_s()   @uri.to_s end

    def [](property)
      RDF::URI.parse([to_s, property.to_s].join(''))
    end

    protected
      @@uris = {}
      @@uri  = nil

      # @private
      def self.create(uri)
        @@uri = uri
        self
      end

      # @private
      def self.inherited(subclass)
        unless @@uri.nil?
          subclass.send(:private_class_method, :new)
          @@uris[subclass] = @@uri
          @@uri = nil
        end
      end

      def self.method_missing(property, *args, &block)
        if args.empty? && @@uris.has_key?(self)
          self[property]
        else
          super
        end
      end

      def method_missing(property, *args, &block)
        if args.empty?
          self[property]
        else
          raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)")
        end
      end

  end

  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end
end
