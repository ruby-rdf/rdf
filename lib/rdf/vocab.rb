module RDF
  ##
  # A {Vocabulary} represents an RDFS or OWL vocabulary.
  #
  # ### Vocabularies:
  #
  # The following vocabularies are pre-defined for your convenience:
  #
  # * {RDF}        - Resource Description Framework (RDF)
  # * {RDF::CC}    - Creative Commons (CC)
  # * {RDF::CERT}  - W3 Authentication Certificate (CERT)
  # * {RDF::DC}    - Dublin Core (DC)
  # * {RDF::DC11}  - Dublin Core 1.1 (DC11) _deprecated_
  # * {RDF::DOAP}  - Description of a Project (DOAP)
  # * {RDF::EXIF}  - Exchangeable Image File Format (EXIF)
  # * {RDF::FOAF}  - Friend of a Friend (FOAF)
  # * {RDF::GEO}   - WGS84 Geo Positioning (GEO)
  # * {RDF::HTTP}  - Hypertext Transfer Protocol (HTTP)
  # * {RDF::OWL}   - Web Ontology Language (OWL)
  # * {RDF::RDFS}  - RDF Schema (RDFS)
  # * {RDF::RSA}   - W3 RSA Keys (RSA)
  # * {RDF::RSS}   - RDF Site Summary (RSS)
  # * {RDF::SIOC}  - Semantically-Interlinked Online Communities (SIOC)
  # * {RDF::SKOS}  - Simple Knowledge Organization System (SKOS)
  # * {RDF::WOT}   - Web of Trust (WOT)
  # * {RDF::XHTML} - Extensible HyperText Markup Language (XHTML)
  # * {RDF::XSD}   - XML Schema (XSD)
  #
  # @example Using pre-defined RDF vocabularies
  #   include RDF
  #
  #   DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
  #   FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
  #   RDF.type      #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
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
  # @see http://en.wikipedia.org/wiki/QName
  class Vocabulary
    extend ::Enumerable

    ##
    # Enumerates known RDF vocabulary classes.
    #
    # @yield  [klass]
    # @yieldparam [Class] klass
    # @return [Enumerator]
    def self.each(&block)
      if self.equal?(Vocabulary)
        # This is needed since all vocabulary classes are defined using
        # Ruby's autoloading facility, meaning that `@@subclasses` will be
        # empty until each subclass has been touched or require'd.
        RDF::VOCABS.each { |v| require "rdf/vocab/#{v}" unless v == :rdf }
        @@subclasses.each(&block)
      else
        # TODO: should enumerate vocabulary-specific defined properties.
      end
    end

    ##
    # Defines a vocabulary term called `property`.
    #
    # @param  [Symbol]
    # @return [void]
    def self.property(property)
      metaclass = class << self; self; end
      metaclass.send(:define_method, property) { self[property] } # class method
    end

    ##
    # Returns the URI for the term `property` in this vocabulary.
    #
    # @param  [#to_s] property
    # @return [RDF::URI]
    def self.[](property)
      RDF::URI.intern([to_s, property.to_s].join(''))
    end

    ##
    # Returns the base URI for this vocabulary class.
    #
    # @return [RDF::URI]
    def self.to_uri
      RDF::URI.intern(to_s)
    end

    ##
    # Returns a string representation of this vocabulary class.
    #
    # @return [String]
    def self.to_s
      @@uris.has_key?(self) ? @@uris[self].to_s : super
    end

    ##
    # Returns a developer-friendly representation of this vocabulary class.
    #
    # @return [String]
    def self.inspect
      if self == Vocabulary
        self.to_s
      else
        sprintf("%s(%s)", superclass.to_s, to_s)
      end
    end

    class << self
      # Preserve the class name so that it can be obtained even for
      # vocabularies that define a `name` property:
      alias_method :__name__, :name
    end

    ##
    # Returns a suggested CURIE/QName prefix for this vocabulary class.
    #
    # @return [Symbol]
    # @since  0.3.0
    def self.__prefix__
      self.__name__.split('::').last.downcase.to_sym
    end

    # Undefine all superfluous instance methods:
    undef_method(*(instance_methods.map(&:to_sym) - [:__id__, :__send__, :__class__, :__eval__, :object_id, :instance_eval, :inspect, :class, :is_a?]))

    ##
    # @param  [RDF::URI, String, #to_s]
    def initialize(uri)
      @uri = case uri
        when RDF::URI then uri.to_s
        else RDF::URI.parse(uri.to_s) ? uri.to_s : nil
      end
    end

    ##
    # Returns the URI for the term `property` in this vocabulary.
    #
    # @param  [#to_s] property
    # @return [URI]
    def [](property)
      RDF::URI.intern([to_s, property.to_s].join(''))
    end

    ##
    # Returns the base URI for this vocabulary.
    #
    # @return [URI]
    def to_uri
      RDF::URI.intern(to_s)
    end

    ##
    # Returns a string representation of this vocabulary.
    #
    # @return [String]
    def to_s
      @uri.to_s
    end

    ##
    # Returns a developer-friendly representation of this vocabulary.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, to_s)
    end

  protected

    def self.create(uri) # @private
      @@uri = uri
      self
    end

    def self.inherited(subclass) # @private
      @@subclasses << subclass
      unless @@uri.nil?
        subclass.send(:private_class_method, :new)
        @@uris[subclass] = @@uri
        @@uri = nil
      end
      super
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

  private

    @@subclasses = [::RDF] # @private
    @@uris       = {}      # @private
    @@uri        = nil     # @private
  end # Vocabulary
end # RDF
