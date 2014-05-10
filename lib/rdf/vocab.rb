module RDF
  ##
  # A {Vocabulary} represents an RDFS or OWL vocabulary.
  #
  # ### Vocabularies:
  #
  # The following vocabularies are pre-defined for your convenience:
  #
  # * {RDF}         - Resource Description Framework (RDF)
  # * {RDF::CC}     - Creative Commons (CC)
  # * {RDF::CERT}   - W3 Authentication Certificate (CERT)
  # * {RDF::DC}     - Dublin Core (DC)
  # * {RDF::DC11}   - Dublin Core 1.1 (DC11) _deprecated_
  # * {RDF::DOAP}   - Description of a Project (DOAP)
  # * {RDF::EXIF}   - Exchangeable Image File Format (EXIF)
  # * {RDF::FOAF}   - Friend of a Friend (FOAF)
  # * {RDF::GEO}    - WGS84 Geo Positioning (GEO)
  # * {RDF::GR}     - Good Relations
  # * {RDF::HTTP}   - Hypertext Transfer Protocol (HTTP)
  # * {RDF::ICAL}   - iCal
  # * {RDF::MA}     - W3C Meda Annotations
  # * {RDF::OG}     - FaceBook OpenGraph
  # * {RDF::OWL}    - Web Ontology Language (OWL)
  # * {RDF::PROV}   - W3C Provenance Ontology
  # * {RDF::RDFS}   - RDF Schema (RDFS)
  # * {RDF::RSA}    - W3 RSA Keys (RSA)
  # * {RDF::RSS}    - RDF Site Summary (RSS)
  # * {RDF::SCHEMA} - Schema.org
  # * {RDF::SIOC}   - Semantically-Interlinked Online Communities (SIOC)
  # * {RDF::SKOS}   - Simple Knowledge Organization System (SKOS)
  # * {RDF::SKOSXL} - SKOS Simple Knowledge Organization System eXtension for Labels (SKOS-XL)
  # * {RDF::V}      - Data Vocabulary
  # * {RDF::VCARD}  - vCard vocabulary
  # * {RDF::VOID}   - Vocabulary of Interlinked Datasets (VoID)
  # * {RDF::WDRS}   - Protocol for Web Description Resources (POWDER)
  # * {RDF::WOT}    - Web of Trust (WOT)
  # * {RDF::XHTML}  - Extensible HyperText Markup Language (XHTML)
  # * {RDF::XHV}    - W3C XHTML Vocabulary
  # * {RDF::XSD}    - XML Schema (XSD)
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

    class << self
      ##
      # Enumerates known RDF vocabulary classes.
      #
      # @yield  [klass]
      # @yieldparam [Class] klass
      # @return [Enumerator]
      def each(&block)
        if self.equal?(Vocabulary)
          # This is needed since all vocabulary classes are defined using
          # Ruby's autoloading facility, meaning that `@@subclasses` will be
          # empty until each subclass has been touched or require'd.
          RDF::VOCABS.each { |v| require "rdf/vocab/#{v}" unless v == :rdf }
          @@subclasses.each(&block)
        else
          properties.each(&block)
        end
      end

      ##
      # Is this a strict vocabulary, or a liberal vocabulary allowing arbitrary properties?
      def strict?; false; end

      ##
      # @overload property
      #   Returns `property` in the current vocabulary
      #   @return [RDF::URI]
      #
      # @overload property(name, options)
      #   Defines a new property or class in the vocabulary.
      #   Optional labels and comments are stripped of unnecessary whitespace.
      #
      #   @param [String, #to_s] name
      #   @param [Hash{Symbol => Object}] options
      #   @option options [String, #to_s] :label
      #   @option options [String, #to_s] :comment
      def property(*args)
        case args.length
        when 0
          RDF::URI.intern("#{self}property")
        else
          name, options = args
          options ||= {}
          prop = RDF::URI.intern([to_s, name.to_s].join(''))
          props[prop] = true
          labels[prop] = options[:label].to_s.strip.gsub(/\s+/m, ' ') if options[:label]
          comments[prop] = options[:comment].to_s.strip.gsub(/\s+/m, ' ') if options[:comment]
          (class << self; self; end).send(:define_method, name) { prop } unless name.to_s == "property"
        end
      end

      ##
      #  @return [Array<RDF::URI>] a list of properties in the current vocabulary
      def properties
        props.keys
      end

      ##
      # Returns the URI for the term `property` in this vocabulary.
      #
      # @param  [#to_s] property
      # @return [RDF::URI]
      def [](property)
        RDF::URI.intern([to_s, property.to_s].join(''))
      end

      # @return [String] The label for the named property
      def label_for(name)
        labels[self[name]]
      end

      # @return [String] The comment for the named property
      def comment_for(name)
        comments[self[name]]
      end

      ##
      # Returns the base URI for this vocabulary class.
      #
      # @return [RDF::URI]
      def to_uri
        RDF::URI.intern(to_s)
      end

      ##
      # Returns a string representation of this vocabulary class.
      #
      # @return [String]
      def to_s
        @@uris.has_key?(self) ? @@uris[self].to_s : super
      end

      ##
      # Returns a developer-friendly representation of this vocabulary class.
      #
      # @return [String]
      def inspect
        if self == Vocabulary
          self.to_s
        else
          sprintf("%s(%s)", superclass.to_s, to_s)
        end
      end

      # Preserve the class name so that it can be obtained even for
      # vocabularies that define a `name` property:
      alias_method :__name__, :name

      ##
      # Returns a suggested CURIE/QName prefix for this vocabulary class.
      #
      # @return [Symbol]
      # @since  0.3.0
      def __prefix__
        __name__.split('::').last.downcase.to_sym
      end

    protected
      def inherited(subclass) # @private
        unless @@uri.nil?
          @@subclasses << subclass
          subclass.send(:private_class_method, :new)
          @@uris[subclass] = @@uri
          @@uri = nil
        end
        super
      end

      def method_missing(property, *args, &block)
        if args.empty? && @@uris.has_key?(self)
          self[property]
        else
          super
        end
      end

    private
    def props; @properties ||= {}; end
    def labels; @labels ||= {}; end
    def comments; @comments ||= {}; end
    end

    # Undefine all superfluous instance methods:
    undef_method(*instance_methods.
                  map(&:to_s).
                  select {|m| m =~ /^\w+$/}.
                  reject {|m| %w(object_id dup instance_eval inspect to_s class).include?(m) || m[0,2] == '__'}.
                  map(&:to_sym))

    ##
    # @param  [RDF::URI, String, #to_s] uri
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

  # Represents an RDF Vocabulary. The difference from {RDF::Vocabulary} is that
  # that every concept in the vocabulary is required to be declared. To assist
  # in this, an existing RDF representation of the vocabulary can be loaded as
  # the basis for concepts being available
  class StrictVocabulary < Vocabulary
    class << self
      # Redefines method_missing to the original definition
      # By remaining a subclass of Vocabulary, we remain available to
      # Vocabulary::each etc.
      define_method(:method_missing, BasicObject.instance_method(:method_missing))

      ##
      # Is this a strict vocabulary, or a liberal vocabulary allowing arbitrary properties?
      def strict?; true; end

      def [](name)
        prop = super
        props.fetch(prop) #raises KeyError on missing value
        return prop
      end
    end
  end # StrictVocabulary
end # RDF
