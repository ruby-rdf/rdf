module RDF
  ##
  # An RDF vocabulary.
  #
  # @example Using pre-defined RDF vocabularies
  #   include RDF
  #   DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
  #   FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
  #   RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
  #   RSS.title     #=> RDF::URI("http://purl.org/rss/1.0/title")
  #   OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
  #   XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
  #
  # @example Using ad-hoc RDF vocabularies
  #   foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
  #   foaf.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
  #   foaf[:name]   #=> RDF::URI("http://xmlns.com/foaf/0.1/name")
  #   foaf['mbox']  #=> RDF::URI("http://xmlns.com/foaf/0.1/mbox")
  #
  # @see http://www.w3.org/TR/curie/
  class Vocabulary
    ##
    # @return [String]
    def self.inspect
      if self == Vocabulary
        self.to_s
      else
        sprintf("%s(%s)", superclass.to_s, to_s)
      end
    end

    ##
    # @return [URI]
    def self.to_uri
      RDF::URI.parse(to_s)
    end

    ##
    # @return [String]
    def self.to_s
      @@uris.has_key?(self) ? @@uris[self].to_s : super
    end

    ##
    # @param  [#to_s] property
    # @return [URI]
    def self.[](property)
      RDF::URI.parse([to_s, property.to_s].join(''))
    end

    ##
    # @param  [Symbol]
    # @return [void]
    def self.property(symbol) end # TODO

    ##
    # @param  [URI, String]
    def initialize(uri)
      case uri
        when RDF::URI then @uri = uri.to_s
        else @uri = RDF::URI.parse(uri.to_s) ? uri.to_s : nil
      end
    end

    ##
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    ##
    # @return [URI]
    def to_uri
      RDF::URI.parse(to_s)
    end

    ##
    # @return [String]
    def to_s() @uri.to_s end

    ##
    # @param  [#to_s] property
    # @return [URI]
    def [](property)
      RDF::URI.parse([to_s, property.to_s].join(''))
    end

    protected
      @@uris = {}
      @@uri  = nil

      ##
      # @private
      def self.create(uri) #:nodoc:
        @@uri = uri
        self
      end

      ##
      # @private
      def self.inherited(subclass) #:nodoc:
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

  ##
  # @param  [String] uri
  # @return [Class]
  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end
end
