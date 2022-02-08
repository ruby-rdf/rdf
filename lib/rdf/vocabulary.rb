module RDF
  ##
  # A {Vocabulary} represents an RDFS or OWL vocabulary.
  #
  # A {Vocabulary} can also serve as a Domain Specific Language (DSL) for generating an RDF Graph definition for the vocabulary (see {RDF::Vocabulary#to_enum}).
  #
  # ### Defining a vocabulary using the DSL
  # Vocabularies can be defined based on {RDF::Vocabulary} or {RDF::StrictVocabulary} using a simple Domain Specific Language (DSL).
  #
  # * Ontology information for the vocabulary itself can be specified using the {ontology} method.
  # * Terms of the vocabulary are specified using either `property` or `term` (alias), with the attributes of the term listed in a hash. See {property} for description of the hash. Term attributes become properties of the associated {RDF::Vocabulary::Term} (see {RDF::Vocabulary::Term#attributes}).
  #
  # Note that, by default, the prefix associated with the vocabulary for forming and interpreting PNames is created from the class name of the vocabulary. See {\_\_prefix\_\_=} for overriding this at runtime.
  #
  # The simplest way to generate a DSL representation of a vocabulary is using {RDF::Vocabulary::Writer} given an {RDF::Graph} representation of the vocabulary.
  #
  # ### Vocabularies:
  #
  # The following vocabularies are pre-defined for your convenience:
  #
  # * {RDF}         - Resource Description Framework (RDF)
  # * {RDF::OWL}    - Web Ontology Language (OWL)
  # * {RDF::RDFS}   - RDF Schema (RDFS)
  # * {RDF::XSD}    - XML Schema (XSD)
  #
  # Other vocabularies are defined in the [rdf-vocab](https://rubygems.org/gems/rdf-vocab) gem
  #
  # @example Using pre-defined RDF vocabularies
  #   include RDF
  #
  #   RDF.type      #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
  #   RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
  #   OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
  #   XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
  #
  # @example Using ad-hoc RDF vocabularies
  #   foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
  #   foaf.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
  #   foaf[:name]   #=> RDF::URI("http://xmlns.com/foaf/0.1/name")
  #   foaf['mbox']  #=> RDF::URI("http://xmlns.com/foaf/0.1/mbox")
  #
  # @example Defining a simple vocabulary
  #   EX = Class.new(RDF::StrictVocabulay("http://example/ns#")) do
  #     # Ontology definition
  #     ontology :"http://example/ns#",
  #       label: "The RDF Example Vocablary",
  #       type: "http://www.w3.org/2002/07/owl#Ontology"
  #
  #     # Class definitions
  #     term :Class,
  #       label: "My Class",
  #       comment: "Good to use as an example",
  #       type: "rdfs:Class",
  #       subClassOf: "http://example/SuperClass",
  #       "ex:prop": "Some annotation property not having a shortcut"
  #
  #     # Property definitions
  #     property :prop,
  #       comment: "A description of the property",
  #       label: "property",
  #       domain: "http://example/ns#Class",
  #       range: "rdfs:Literal",
  #       isDefinedBy: %(ex:),
  #       type: "rdf:Property"
  #   end
  # 
  # @example Method calls are converted to the typical RDF camelcase convention
  #   foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
  #   foaf.family_name    #=> RDF::URI("http://xmlns.com/foaf/0.1/familyName")
  #   owl.same_as         #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
  #   # []-style access is left as is
  #   foaf['family_name'] #=> RDF::URI("http://xmlns.com/foaf/0.1/family_name")
  #   foaf[:family_name]  #=> RDF::URI("http://xmlns.com/foaf/0.1/family_name")
  #
  # @example Generating RDF from a vocabulary definition
  #   graph = RDF::Graph.new << RDF::RDFS.to_enum
  #   graph.dump(:ntriples)
  #
  # @see https://www.w3.org/TR/rdf-sparql-query/#prefNames
  class Vocabulary
    extend ::Enumerable

    autoload :Format, 'rdf/vocab/writer'
    autoload :Writer, 'rdf/vocab/writer'

    class << self
      ##
      # Enumerates known RDF vocabulary classes.
      #
      # @yield  [klass]
      # @yieldparam [Class] klass
      # @return [Enumerator]
      def each(&block)
        if self.equal?(Vocabulary)
          if instance_variable_defined?(:@vocabs) && @vocabs
            @vocabs.select(&:name).each(&block)
          else
            # This is needed since all vocabulary classes are defined using
            # Ruby's autoloading facility, meaning that `@@subclasses` will be
            # empty until each subclass has been touched or require'd.
            RDF::VOCABS.each { |v, p| RDF.const_get(p[:class_name].to_sym) unless v == :rdf }
            @@subclasses.select(&:name).each(&block)
          end
        else
          __properties__.each(&block)
        end
      end

      ##
      # A hash of all vocabularies by prefix showing relevant URI and
      # associated vocabulary Class Name
      #
      # @return [Hash{Symbol => Hash{Symbol => String}}]
      def vocab_map
        # Create an initial duplicate of RDF::VOCABS. We want to
        # ensure the hash itself is modifiable but the values are
        # frozen.
        @vocab_map ||= RDF::VOCABS.transform_values(&:freeze)
      end

      ##
      # Return the vocabulary based on it's class_name symbol
      #
      # @param [Symbol] sym
      # @return [RDF::Vocabulary]
      def from_sym(sym)
        RDF.const_get(sym.to_sym)
      end

      ##
      # Register a vocabulary for internal prefix lookups. Parameters
      # of interest include `:uri`, `:class_name`, `:source`, and `:skip`.
      #
      # @param prefix [Symbol] the prefix to use
      # @param vocab  [String, Class] either the URI or the vocab class
      # @param params [Hash{Symbol => String}] Relevant parameters
      # @return [Hash] The parameter hash, but frozen
      def register(prefix, vocab, **params)
        # check the input
        raise ArgumentError, "#{prefix} must be symbol-able" unless
          [String, Symbol].any? { |c| prefix.is_a? c }

        # note an explicit uri: param overrides
        case vocab
        when String then params[:uri] ||= vocab
        when Class
          raise ArgumentError, 'vocab must be an RDF::(Strict)Vocabulary' unless
            vocab.ancestors.include? RDF::Vocabulary
          params[:class] = vocab
          params[:uri] ||= vocab.to_uri.to_s
        end

        # fill in the class name
        params[:class_name] ||= prefix.to_s.upcase

        # now freeze and assign
        vocab_map[prefix.to_s.to_sym] = params.freeze
      end

      ##
      # Limits iteration over vocabularies to just those selected
      #
      # @example limit to set of vocabularies by symbol
      #     RDF::Vocabulary.limit_vocabs(:rdf, :rdfs
      #     RDF::Vocabulary.find_term('http://www.w3.org/2000/01/rdf-schema#Resource').pname
      #     # => 'rdfs:Resource'
      #
      # @example limit to set of vocabularies by class name
      #     RDF::Vocabulary.limit_vocabs(RDF::RDFV, RDF::RDFS)
      #     RDF::Vocabulary.find_term('http://www.w3.org/2000/01/rdf-schema#Resource').pname
      #     # => 'rdfs:Resource'
      #
      # @param [Array<symbol, RDF::Vocabulary>] vocabs
      #   A list of vocabularies (symbols or classes) which may
      #   be returned by {Vocabulary.each}. Also limits
      #   vocabularies that will be inspeced for other methods.
      #   Set to nil, or an empty array to reset.
      # @return [Array<RDF::Vocabulary>]
      def limit_vocabs(*vocabs)
        @vocabs = if Array(vocabs).empty?
          nil
        else
          vocabs.map do |vocab|
            vocab = :rdfv if vocab == :rdf
            vocab.is_a?(Symbol) && RDF::VOCABS.key?(vocab) ?
              RDF.const_get(RDF::VOCABS[vocab][:class_name].to_sym) :
              vocab
          end.compact
        end
      end

      ##
      # Is this a strict vocabulary, or a liberal vocabulary allowing arbitrary properties?
      def strict?; false; end

      ##
      # @overload property
      #   Returns `property` in the current vocabulary
      #   @return [RDF::Vocabulary::Term]
      #
      # @overload property(name, options)
      #   Defines a new property or class in the vocabulary as a {RDF::Vocabulary::Term}.
      #
      #   @example A simple term definition
      #       property :domain,
      #         comment: %(A domain of the subject property.),
      #         domain: "rdf:Property",
      #         label: "domain",
      #         range: "rdfs:Class",
      #         isDefinedBy: %(rdfs:),
      #         type: "rdf:Property"
      #
      #   @example A term definition with tagged values
      #       property :actor,
      #       comment: {en: "Subproperty of as:attributedTo that identifies the primary actor"},
      #       domain: "https://www.w3.org/ns/activitystreams#Activity",
      #       label: {en: "actor"},
      #       range: term(
      #           type: "http://www.w3.org/2002/07/owl#Class",
      #           unionOf: list("https://www.w3.org/ns/activitystreams#Object", "https://www.w3.org/ns/activitystreams#Link")
      #         ),
      #       subPropertyOf: "https://www.w3.org/ns/activitystreams#attributedTo",
      #       type: "http://www.w3.org/2002/07/owl#ObjectProperty"
      #
      #   @example A SKOS term with anonymous values
      #         term: :af,
      #           type: "jur:Country",
      #           isDefinedBy: "http://eulersharp.sourceforge.net/2003/03swap/countries#",
      #           "skos:exactMatch": [
      #             Term.new(
      #               type: "skos:Concept",
      #               inScheme: "iso3166-1-alpha-2",
      #               notation: "ax"),
      #             Term.new(
      #               type: "skos:Concept",
      #               inScheme: "iso3166-1-alpha-3",
      #               notation: "ala")
      #           ],
      #           "foaf:name": "Aland Islands"
      #
      #   @param [String, #to_s] name
      #   @param [Hash{Symbol=>String,Array<String>}] options
      #     Any other values are expected to expands to a {URI} using built-in vocabulary prefixes. The value is a `String`, 'Hash{Symbol=>String,Array<String>}' or `Array<String,Hash{Symbol=>Array<String>}>` which is interpreted according to the `range` of the associated property and by heuristically determining the value datatype. See `attributes` argument to {Term#initialize}.
      #   @return [RDF::Vocabulary::Term]
      def property(*args)
        case args.length
        when 0
          Term.intern("#{self}property", vocab: self, attributes: {})
        else
          name = args.shift unless args.first.is_a?(Hash)
          options = args.last
          if name
            uri_str = [to_s, name.to_s].join('')
            URI.cache.delete(uri_str.to_sym)  # Clear any previous entry

            # Term attributes passed in a block for lazy evaluation. This helps to avoid load-time circular dependencies
            prop = Term.intern(uri_str, vocab: self, attributes: options || {})
            props[name.to_sym] = prop

            # If name is empty, also treat it as the ontology
            @ontology ||= prop if name.to_s.empty?

            # Define an accessor, except for problematic properties
            (class << self; self; end).send(:define_method, name) { prop } unless %w(property term hash).include?(name.to_s)
          else
            # Define the term without a name
            # Term attributes passed in a block for lazy evaluation. This helps to avoid load-time circular dependencies
            prop = Term.new(vocab: self, attributes: options)
          end
          prop
        end
      end

      # Alternate use for vocabulary terms, functionally equivalent to {#property}.
      alias_method :term, :property
      alias_method :__property__, :property

      ##
      # @overload ontology
      #   Returns the ontology definition of the current vocabulary as a term.
      #   @return [RDF::Vocabulary::Term]
      #
      # @overload ontology(name, options)
      #   Defines the vocabulary ontology.
      #
      #   @param [String, #to_s] uri
      #     The URI of the ontology.
      #   @param [Hash{Symbol => Object}] options
      #     See {property}
      #   @param [Hash{Symbol=>String,Array<String,Term>}] options
      #     Any other values are expected to expands to a {URI} using built-in vocabulary prefixes. The value is a `String`, `Array<String>` or `Array<Term>` which is interpreted according to the `range` of the associated property.
      #   @option options [String, Array<String,Term>] :type
      #     Shortcut for `rdf:type`, values are interpreted as a {Term}.
      #   @option options [String, Array<String>] :comment
      #     Shortcut for `rdfs:comment`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String,Term>] :isDefinedBy
      #     Shortcut for `rdfs:isDefinedBy`, values are interpreted as a {Term}.
      #   @option options [String, Array<String>] :label
      #     Shortcut for `rdfs:label`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String>] :altLabel
      #     Shortcut for `skos:altLabel`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String>] :definition
      #     Shortcut for `skos:definition`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String>] :editorialNote
      #     Shortcut for `skos:editorialNote`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String>] :note
      #     Shortcut for `skos:note`, values are interpreted as a {Literal}.
      #   @option options [String, Array<String>] :prefLabel
      #     Shortcut for `skos:prefLabel`, values are interpreted as a {Literal}.
      #   @return [RDF::Vocabulary::Term]
      #
      # @note If the ontology URI has the vocabulary namespace URI as a prefix, it may also be defined using `#property` or `#term`
      def ontology(*args)
        case args.length
        when 0
          @ontology if instance_variable_defined?(:@ontology)
        else
          uri, options = args
          URI.cache.delete(uri.to_s.to_sym)  # Clear any previous entry
          # Term attributes passed in a block for lazy evaluation. This helps to avoid load-time circular dependencies
          @ontology = Term.intern(uri.to_s, vocab: self, attributes: options || {})

          # If the URI is the same as the vocabulary namespace, also define it as a term
          props[:""] ||= @ontology if self.to_s == uri.to_s

          @ontology
        end
      end
      alias_method :__ontology__, :ontology

      ##
      #  @return [Array<RDF::URI>] a list of properties in the current vocabulary
      def properties
        props.values
      end
      alias_method :__properties__, :properties

      ##
      # Attempt to expand a Compact IRI/PName using loaded vocabularies
      #
      # @param [String, #to_s] pname
      # The local-part of the PName will will have [reserved character escapes](https://www.w3.org/TR/turtle/#reserved) unescaped.
      # @return [Term]
      # @raise [KeyError] if pname suffix not found in identified vocabulary.
      # @raise [ArgumentError] if resulting URI is not valid
      def expand_pname(pname)
        return pname unless pname.is_a?(String) || pname.is_a?(Symbol)
        prefix, suffix = pname.to_s.split(":", 2)
        # Unescape escaped PN_ESCAPE_CHARS
        if suffix.match?(RDF::URI::PN_ESCAPES)
          suffix = suffix.gsub(RDF::URI::PN_ESCAPES) {|matched| matched[1..-1]}
        end
        if prefix == "rdf"
          RDF[suffix]
        elsif vocab_detail = RDF::Vocabulary.vocab_map[prefix.to_sym]
          vocab = vocab_detail[:class] ||
            RDF::Vocabulary.from_sym(vocab_detail[:class_name])
          suffix.to_s.empty? ? vocab.to_uri : vocab[suffix]
        else
          (RDF::Vocabulary.find_term(pname) rescue nil) || RDF::URI(pname, validate: true)
        end
      end

      ##
      # Return the Vocabulary associated with a URI. Allows the trailing '/' or '#' to be excluded
      #
      # @param [RDF::URI] uri
      # @return [Vocabulary]
      def find(uri)
        uri = RDF::URI(uri) if uri.is_a?(String)
        return nil unless uri.uri? && uri.valid?
        RDF::Vocabulary.detect do |v|
          if uri.length >= v.to_uri.length
            uri.start_with?(v.to_uri)
          else
            v.to_uri.to_s.sub(%r([/#]$), '') == uri.to_s
          end
        end
      end

      ##
      # Return the Vocabulary term associated with a URI
      #
      # @param [RDF::URI, String] uri
      #   If `uri` has is a pname in a locded vocabulary, the suffix portion of the PName will have escape characters unescaped before resolving against the vocabulary.
      # @return [Vocabulary::Term]
      def find_term(uri)
        uri = RDF::URI(uri)
        return uri if uri.is_a?(Vocabulary::Term)
        if vocab = find(uri)
          if vocab.ontology == uri
            vocab.ontology
          else
            suffix = uri.to_s[vocab.to_uri.to_s.length..-1].to_s
            vocab[suffix]
          end
        end
      end

      ##
      # Returns the URI for the term `property` in this vocabulary.
      #
      # @param  [#to_s] property
      # @return [RDF::URI]
      def [](property)
        if props.key?(property.to_sym)
          props[property.to_sym]
        else
          Term.intern([to_s, property.to_s].join(''), vocab: self, attributes: {})
        end
      end

      ##
      # List of vocabularies this vocabulary `owl:imports`
      #
      # @note the alias {__imports__} guards against `RDF::OWL.imports` returning a term, rather than an array of vocabularies
      # @return [Array<RDF::Vocabulary>]
      def imports
        return [] unless self.ontology
        @imports ||= begin
          Array(self.ontology.properties[:"http://www.w3.org/2002/07/owl#imports"]).compact
        rescue KeyError
          []
        end
      end
      alias_method :__imports__, :imports

      ##
      # List of vocabularies which import this vocabulary
      # @return [Array<RDF::Vocabulary>]
      def imported_from
        @imported_from ||= begin
          RDF::Vocabulary.select {|v| v.__imports__.include?(self)}
        end
      end

      ##
      # Returns the base URI for this vocabulary class.
      #
      # @return [RDF::URI]
      def to_uri
        RDF::URI.intern(@@uris[self].to_s)
      end

      # For IRI compatibility
      alias_method :to_iri, :to_uri

      ##
      # Return an enumerator over {RDF::Statement} defined for this vocabulary.
      # @return [RDF::Enumerable::Enumerator]
      # @see    Object#enum_for
      def enum_for(method = :each_statement, *args)
        # Ensure that enumerators are, themselves, queryable
        this = self
        Enumerable::Enumerator.new do |yielder|
          this.send(method, *args) {|*y| yielder << (y.length > 1 ? y : y.first)}
        end
      end
      alias_method :to_enum, :enum_for

      ##
      # Enumerate each statement constructed from the defined vocabulary terms
      #
      # If a property value is known to be a {URI}, or expands to a {URI}, the `object` is a URI, otherwise, it will be a {Literal}.
      #
      # @yield statement
      # @yieldparam [RDF::Statement]
      def each_statement(&block)
        props.each do |name, subject|
          subject.each_statement(&block)
        end

        # Also include the ontology, if it's not also a property
        @ontology.each_statement(&block) if self.ontology && self.ontology != self
      end

      ##
      # Returns a string representation of this vocabulary class.
      #
      # @return [String]
      def to_s
        @@uris.key?(self) ? @@uris[self].to_s : super
      end

      ##
      # Create a vocabulary from a graph or enumerable
      #
      # @param [RDF::Enumerable] graph
      # @param [URI, #to_s] url
      # @param [RDF::Vocabulary, String] class_name
      #   The class_name associated with the vocabulary, used for creating the class name of the vocabulary. This will create a new class named with a top-level constant based on `class_name`. If given an existing vocabulary, it replaces the existing definitions for that vocabulary with those from the graph.
      # @param [Array<Symbol>, Hash{Symbol => Hash}] extra
      #   Extra terms to add to the vocabulary. In the first form, it is an array of symbols, for which terms are created. In the second, it is a Hash mapping symbols to property attributes, as described in {RDF::Vocabulary.property}.
      # @return [RDF::Vocabulary] the loaded vocabulary
      def from_graph(graph, url: nil, class_name: nil, extra: nil)
        vocab = case class_name
        when RDF::Vocabulary
          class_name.instance_variable_set(:@ontology, nil)
          class_name.instance_variable_set(:@properties, nil)
          class_name
        when String
          Object.const_set(class_name, Class.new(self.create(url)))
        else
          Class.new(self.create(url))
        end

        ont_url = url.to_s.sub(%r([/#]$), '')
        term_defs = {}
        embedded_defs = {}
        graph.each do |statement|
          #next unless statement.subject.uri?
          if statement.subject.start_with?(url) || statement.subject == ont_url
            name = statement.subject.to_s[url.to_s.length..-1].to_s
            term = (term_defs[name.to_sym] ||= {})
          else
            # subject is not a URI or is not associated with the vocabulary
            term = (embedded_defs[statement.subject] ||= {})
          end

          key = Term::URI_ATTRs.fetch(statement.predicate) do
            statement.predicate.to_s.to_sym
          end

          (term[key] ||= []) << statement.object
        end

        # Create extra terms
        term_defs = case extra
        when Array
          extra.inject({}) {|memo, s| memo[s.to_sym] = {}; memo}.merge(term_defs)
        when Hash
          extra.merge(term_defs)
        else
          term_defs
        end

        # Pass over embedded_defs with anonymous references, once
        embedded_defs.each do |term, attributes|
          attributes.each do |ak, avs|
            # Turn embedded BNodes into either their Term definition or a List
            avs = [avs] unless avs.is_a?(Array)
            attributes[ak] = avs.map do |av|
              l = RDF::List.new(subject: av, graph: graph)
              if l.valid?
                RDF::List.new(subject: av) do |nl|
                  l.each do |lv|
                    nl << (embedded_defs[lv] ? Term.new(vocab: vocab, attributes: embedded_defs[lv]) : lv)
                  end
                end
              elsif av.is_a?(RDF::Node)
                Term.new(vocab: vocab, attributes: embedded_defs[av]) if embedded_defs[av]
              else
                av
              end
            end.compact
          end
        end

        term_defs.each do |term, attributes|
          # Turn embedded BNodes into either their Term definition or a List
          attributes.each do |ak, avs|
            attributes[ak] = avs.is_a?(Array) ? (avs.map do |av|
              l = RDF::List.new(subject: av, graph: graph)
              if l.valid?
                RDF::List.new(subject: av) do |nl|
                  l.each do |lv|
                    nl << (embedded_defs[lv] ? Term.new(vocab: vocab, attributes: embedded_defs[lv]) : lv)
                  end
                end
              elsif av.is_a?(RDF::Node)
                Term.new(vocab: vocab, attributes: embedded_defs[av]) if embedded_defs[av]
              else
                av
              end
            end).compact : avs
          end

          if term == :""
            vocab.__ontology__ vocab, attributes
          else
            vocab.__property__ term, attributes
          end
        end

        vocab
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
      # Returns a suggested vocabulary prefix for this vocabulary class.
      #
      # @return [Symbol]
      # @since  0.3.0
      def __prefix__
        instance_variable_defined?(:@__prefix__) ?
          @__prefix__ :
          __name__.split('::').last.downcase.to_sym
      end

      ##
      # Sets the vocabulary prefix to use for this vocabulary..
      #
      # @example Overriding a standard vocabulary prefix.
      #   RDF::Vocab::DC.__prefix__ = :dcterms
      #   RDF::Vocab::DC.title.pname #=> 'dcterms:title'
      #
      # @param [Symbol] prefix
      # @return [Symbol]
      # @since  3.2.3
      def __prefix__=(prefix)
        params = RDF::Vocabulary.vocab_map[__prefix__]
        @__prefix__ = prefix.to_sym
        RDF::Vocabulary.register(@__prefix__, self, **params)
        @__prefix__
      end

    protected
      def inherited(subclass) # @private
        unless @@uri.nil?
          @@subclasses << subclass unless %w(http://www.w3.org/1999/02/22-rdf-syntax-ns#).include?(@@uri)
          subclass.send(:private_class_method, :new)
          @@uris[subclass] = @@uri
          @@uri = nil
        end
        super
      end

      def method_missing(property, *args, &block)
        property = RDF::Vocabulary.camelize(property.to_s)
        if args.empty? && !to_s.empty?
          Term.intern([to_s, property.to_s].join(''), vocab: self, attributes: {})
        else
          super
        end
      end

      # Create a list of terms
      # @param [Array<String>] values
      #   Each value treated as a URI or PName
      # @return [RDF::List]
      def list(*values)
        RDF::List[*values.map {|v| expand_pname(v) rescue RDF::Literal(v)}]
      end
    private

      def props; @properties ||= {}; end
    end

    # Undefine all superfluous instance methods:
    undef_method(*instance_methods.
                  map(&:to_s).
                  select {|m| m.match?(/^\w+$/)}.
                  reject {|m| %w(object_id dup instance_eval inspect to_s class send public_send).include?(m) || m[0,2] == '__'}.
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
      Term.intern([to_s, property.to_s].join(''), vocab: self, attributes: {})
    end

    ##
    # Returns the base URI for this vocabulary.
    #
    # @return [URI]
    def to_uri
      RDF::URI.intern(to_s)
    end

    # For IRI compatibility
    alias_method :to_iri, :to_uri

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
      property = self.class.camelize(property.to_s)
      if %w(to_ary).include?(property.to_s)
        super
      elsif args.empty?
        self[property]
      else
        super
      end
    end

    def self.camelize(str)
      str.split('_').inject([]) do |buffer, e| 
        buffer.push(buffer.empty? ? e : e.capitalize)
      end.join
    end

  private

    @@subclasses = [::RDF] # @private
    @@uris       = {}      # @private
    @@uri        = nil     # @private

    # A Vocabulary Term is a {RDF::Resource} that can also act as an {Enumerable} to generate the RDF definition of vocabulary terms as defined within the vocabulary definition.
    #
    # Terms include {Term#attributes} where values a embedded resources, lists or other terms. This allows, for example, navigation of a concept heirarchy.
    #
    # Term attributes can also be accessed using {Term#properties} where the attribute values are transformed into different types of {RDF::Value}. Properties can be indexed by key, where a key is defined (See {Term::ATTR_URIs}), absolute URI, or PName, where the prefix is associated with a loaded vocabulary.
    module Term
      include RDF::Resource

      ##
      # Look up URIs for attribute symbols
      #
      # @return [Hash{Symbol => RDF::URI}]
      ATTR_URIs = {
        allValuesFrom:      RDF::URI("http://www.w3.org/2002/07/owl#allValuesFrom"),
        altLabel:           RDF::URI("http://www.w3.org/2004/02/skos/core#altLabel"),
        broader:            RDF::URI("http://www.w3.org/2004/02/skos/core#broader"),
        cardinality:        RDF::URI("http://www.w3.org/2002/07/owl#cardinality"),
        comment:            RDF::URI("http://www.w3.org/2000/01/rdf-schema#comment"),
        definition:         RDF::URI("http://www.w3.org/2004/02/skos/core#definition"),
        domain:             RDF::URI("http://www.w3.org/2000/01/rdf-schema#domain"),
        domainIncludes:     RDF::URI("http://schema.org/domainIncludes"),
        editorialNote:      RDF::URI("http://www.w3.org/2004/02/skos/core#editorialNote"),
        equivalentClass:    RDF::URI("http://www.w3.org/2002/07/owl#equivalentClass"),
        equivalentProperty: RDF::URI("http://www.w3.org/2002/07/owl#equivalentProperty"),
        exactMatch:         RDF::URI("http://www.w3.org/2004/02/skos/core#exactMatch"),
        hasTopConcept:      RDF::URI("http://www.w3.org/2004/02/skos/core#hasTopConcept"),
        inScheme:           RDF::URI("http://www.w3.org/2004/02/skos/core#inScheme"),
        intersectionOf:     RDF::URI("http://www.w3.org/2002/07/owl#intersectionOf"),
        inverseOf:          RDF::URI("http://www.w3.org/2002/07/owl#inverseOf"),
        isDefinedBy:        RDF::URI("http://www.w3.org/2000/01/rdf-schema#isDefinedBy"),
        label:              RDF::URI("http://www.w3.org/2000/01/rdf-schema#label"),
        maxCardinality:     RDF::URI("http://www.w3.org/2002/07/owl#maxCardinality"),
        member:             RDF::URI("http://www.w3.org/2004/02/skos/core#member"),
        minCardinality:     RDF::URI("http://www.w3.org/2002/07/owl#minCardinality"),
        narrower:           RDF::URI("http://www.w3.org/2004/02/skos/core#narrower"),
        notation:           RDF::URI("http://www.w3.org/2004/02/skos/core#notation"),
        note:               RDF::URI("http://www.w3.org/2004/02/skos/core#note"),
        onProperty:         RDF::URI("http://www.w3.org/2002/07/owl#onProperty"),
        prefLabel:          RDF::URI("http://www.w3.org/2004/02/skos/core#prefLabel"),
        range:              RDF::URI("http://www.w3.org/2000/01/rdf-schema#range"),
        rangeIncludes:      RDF::URI("http://schema.org/rangeIncludes"),
        related:            RDF::URI("http://www.w3.org/2004/02/skos/core#related"),
        someValuesFrom:     RDF::URI("http://www.w3.org/2002/07/owl#someValuesFrom"),
        subClassOf:         RDF::URI("http://www.w3.org/2000/01/rdf-schema#subClassOf"),
        subPropertyOf:      RDF::URI("http://www.w3.org/2000/01/rdf-schema#subPropertyOf"),
        type:               RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
        unionOf:            RDF::URI("http://www.w3.org/2002/07/owl#unionOf"),
      }.freeze

      ##
      # Look up attribute symbols from URIs
      #
      # @return [Hash{RDF::URI => Symbol}]
      URI_ATTRs = ATTR_URIs.invert.freeze

      # @!attribute [r] comment
      #   `rdfs:comment` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] label
      #   `rdfs:label` accessor
      #   @return [Literal]
      # @!attribute [r] type
      #   `rdf:type` accessor
      #   @return [Array<Term>]
      # @!attribute [r] subClassOf
      #   `rdfs:subClassOf` accessor
      #   @return [Array<Term>]
      # @!attribute [r] subPropertyOf
      #   `rdfs:subPropertyOf` accessor
      #   @return [Array<Term>]
      # @!attribute [r] domain
      #   `rdfs:domain` accessor
      #   @return [Array<Term>]
      # @!attribute [r] range
      #   `rdfs:range` accessor
      #   @return [Array<Term>]
      # @!attribute [r] isDefinedBy
      #   `rdfs:isDefinedBy` accessor
      #   @return [Array<Term>]

      # @!attribute [r] allValuesFrom
      #   `owl:allValuesFrom` accessor
      #   @return [Array<Term>]
      # @!attribute [r] cardinality
      #   `owl:cardinality` accessor
      #   @return [Array<Literal>]
      # @!attribute [r] equivalentClass
      #   `owl:equivalentClass` accessor
      #   @return [Array<Term>]
      # @!attribute [r] equivalentProperty
      #   `owl:equivalentProperty` accessor
      #   @return [Array<Term>]
      # @!attribute [r] intersectionOf
      #   `owl:intersectionOf` accessor
      #   @return [Array<Term>]
      # @!attribute [r] inverseOf
      #   `owl:inverseOf` accessor
      #   @return [Array<Term>]
      # @!attribute [r] maxCardinality
      #   `owl:maxCardinality` accessor
      #   @return [Array<Literal>]
      # @!attribute [r] minCardinality
      #   `owl:minCardinality` accessor
      #   @return [Array<Literal>]
      # @!attribute [r] onProperty
      #   `owl:onProperty` accessor
      #   @return [Array<Term>]
      # @!attribute [r] someValuesFrom
      #   `owl:someValuesFrom` accessor
      #   @return [Array<Term>]
      # @!attribute [r] unionOf
      #   `owl:unionOf` accessor
      #   @return [List<Term>, Array<Term>]

      # @!attribute [r] domainIncludes
      #   `schema:domainIncludes` accessor
      #   @return [Array<Term>]
      # @!attribute [r] rangeIncludes
      #   `schema:rangeIncludes` accessor
      #   @return [Array<Term>]

      # @!attribute [r] altLabel
      #   `skos:altLabel` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] broader
      #   `skos:broader` accessor
      #   @return [Array<Term>]
      # @!attribute [r] definition
      #   `skos:definition` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] editorialNote
      #   `skos:editorialNote` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] exactMatch
      #   `skos:exactMatch` accessor
      #   @return [Array<Term>]
      # @!attribute [r] hasTopConcept
      #   `skos:hasTopConcept` accessor
      #   @return [Array<Term>]
      # @!attribute [r] inScheme
      #   `skos:inScheme` accessor
      #   @return [Array<Term>]
      # @!attribute [r] member
      #   `skos:member` accessor
      #   @return [Array<Term>]
      # @!attribute [r] narrower
      #   `skos:narrower` accessor
      #   @return [Array<Term>]
      # @!attribute [r] notation
      #   `skos:notation` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] note
      #   `skos:note` accessor
      #   @return [Literal, Array<Literal>]
      # @!attribute [r] prefLabel
      #   `skos:prefLabel` accessor
      #   @return [Literal]
      # @!attribute [r] related
      #   `skos:related` accessor
      #   @return [Array<Term>]

      ##
      # Vocabulary of this term.
      #
      # @return [RDF::Vocabulary]
      attr_reader :vocab

      # Attributes of this vocabulary term, used for finding `label` and `comment` and to serialize the term back to RDF.
      #
      # Attributes are indexed by symbol. Symbols directly interpreted by a term are the accessors defined for the {RDF::Vocabulary::Term} class, also in {Term::ATTR_URIs}. Other keys are interpreted as absolute URIs or PNames for properties defined on this term.
      #
      # Symbols which are accessors may also be looked up by their associated URI.
      #
      # Values may be Strings, Hash (Map), or Terms, or an Array including a combination of these. A Hash (Map) is used to create a datatype/language map to one or more string values which represent either datatyped literals, or language-tagged literals as interpreted by {#attribute_value}.
      #
      # In general, this accessor is used internally. The {#properties} method interprets these values as {RDF::Value}.
      #
      # @note lookup by PName is DEPRECATED and will be removed in a future version.
      #
      # @example looking up term label
      #   RDF::RDFS.Literal.attributes[:label] #=> "Literal"
      #   RDF::RDFS.Literal.attributes[:"rdfs:label"] #=> "Literal"
      #   RDF::RDFS.Literal.attributes[RDF::RDFS.label] #=> "Literal"
      #   RDF::RDFS.Literal.attributes["http://www.w3.org/2000/01/rdf-schema#label"] #=> "Literal"
      #   RDF::RDFS.Literal.attributes[:"http://www.w3.org/2000/01/rdf-schema#label"] #=> "Literal"
      # @return [Hash{Symbol => String, Term, Hash{Symbol => String}, Array<String, Term, Hash{Symbol => String}>}]
      # @see #properties
      attr_reader :attributes

      ##
      # @overload new(uri, attributes:, vocab:, **options)
      #   @param  [URI, String, #to_s]    uri
      #   @param [Vocabulary] vocab Vocabulary of this term.
      #   @param [Hash{Symbol => String,Term,Hash{Symbol=>String,Array<String>},Array<String>}] attributes ({})
      #     Attributes of this vocabulary term, used for finding `label` and `comment` and to serialize the term back to RDF. See {#attributes} and {#properties} for other ways to access.
      #   @param  [Hash{Symbol => Object}] options
      #     Options from {URI#initialize}
      #
      # @overload new(attributes:, vocab:, **options)
      #   @param [Vocabulary] vocab Vocabulary of this term.
      #   @param [Hash{Symbol => String,Term,Hash{Symbol=>String,Array<String>},Array<String>}] attributes ({})
      #     Attributes of this vocabulary term, used for finding `label`,  `comment` and other term properties, and to serialize the term back to RDF. See {#attributes} and {#properties} for other ways to access.
      #   @param  [Hash{Symbol => Object}] options
      #     Options from {URI#initialize}
      def self.new(*args, vocab: nil, attributes: {}, **options)
        klass = if args.first.nil?
          RDF::Node
        elsif args.first.is_a?(Hash)
          args.unshift(nil)
          RDF::Node
        elsif args.first.to_s.start_with?("_:")
          args = args[1..-1].unshift($1)
          RDF::Node
        else RDF::URI
        end

        # Create default proc on attributes to allow lookup by different key types.
        attributes = attributes.dup if attributes.frozen?
        attributes.default_proc = -> (hash, key) do
          sym = case key
          when RDF::URI
            URI_ATTRs.fetch(key, key.to_s.to_sym)
          when String
            URI_ATTRs.fetch(RDF::URI(key), key.to_s.to_sym)
          when Symbol
            case key.to_s
            when /^https?:/
              # Lookup by associated attribute, or pname
              URI_ATTRs.fetch(RDF::URI(key.to_s), RDF::URI(key).pname.to_sym)
            when /:/
              uri = RDF::Vocabulary.expand_pname(key)
              # Lookup by associated attribute or URI
              URI_ATTRs.fetch(uri, uri.to_s.to_sym)
            end
          end
          hash.fetch(sym, nil)
        end

        term = klass.allocate.extend(Term)
        term.send(:initialize, *args)
        term.instance_variable_set(:@vocab, vocab)
        term.instance_variable_set(:@attributes, attributes)
        term
      end

      ##
      # Returns an interned `RDF::URI` instance based on the given `uri`
      # string.
      #
      # The maximum number of cached interned URI references is given by the
      # `CACHE_SIZE` constant. This value is unlimited by default, in which
      # case an interned URI object will be purged only when the last strong
      # reference to it is garbage collected (i.e., when its finalizer runs).
      #
      # Excepting special memory-limited circumstances, it should always be
      # safe and preferred to construct new URI references using
      # `RDF::URI.intern` instead of `RDF::URI.new`, since if an interned
      # object can't be returned for some reason, this method will fall back
      # to returning a freshly-allocated one.
      #
      # @param (see #initialize)
      # @return [RDF::URI] an immutable, frozen URI object
      def self.intern(str, *args, **options)
        (URI.cache[(str = str.to_s).to_sym] ||= self.new(str, *args, **options)).freeze
      end

      ##
      # Returns a duplicate copy of `self`.
      #
      # @return [RDF::URI]
      def dup
        term = super.extend(Term)
        term.instance_variable_set(:@vocab, vocab)
        term.instance_variable_set(:@attributes, attributes)
        term
      end

      ##
      # Determine if the URI is a valid according to RFC3987
      #
      # @return [Boolean] `true` or `false`
      # @since 0.3.9
      def valid?
        # Validate relative to RFC3987
        node? || RDF::URI::IRI.match?(to_s) || false
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def class?
        Array(self.type).any? {|t| t.to_s.include?('Class')}
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def property?
        Array(self.type).any? {|t| t.to_s.include?('Property')}
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def datatype?
        Array(self.type).any? {|t| t.to_s.include?('Datatype')}
      end

      ##
      # Is this a Restriction term?
      # @return [Boolean]
      def restriction?
        Array(self.type).any? {|t| t.to_s.include?('Restriction')}
      end

      ##
      # Is this neither a class, property or datatype term?
      # @return [Boolean]
      def other?
        Array(self.type).none? {|t| t.to_s.match?(/(Class|Property|Datatype|Restriction)/)}
      end

      ##
      # Enumerate attributes with values transformed into {RDF::Value} instances
      # Uses an empty hash with a default_proc which looks up values in attributes. The prevents specific attributes from being evaluated until acessed.
      #
      # Properties are indexed by symbol. Symbols directly interpreted by a term are the accessors defined for the {RDF::Vocabulary::Term} class, also in {Term::ATTR_URIs}. Other keys are interpreted as absolute URIs or PNames for properties defined on this term.
      #
      # Symbols which are accessors may also be looked up by their associated URI.
      #
      # @note lookup by PName is DEPRECATED and will be removed in a future version.
      #
      # @example looking up term label
      #   RDF::RDFS.Literal.label #=> RDF::Literal("Literal")
      #   RDF::RDFS.Literal.properties[:label] #=> RDF::Literal("Literal")
      #   RDF::RDFS.Literal.properties[:"rdfs:label"] #=> RDF::Literal("Literal")
      #   RDF::RDFS.Literal.properties[RDF::RDFS.label] #=> RDF::Literal("Literal")
      #   RDF::RDFS.Literal.properties["http://www.w3.org/2000/01/rdf-schema#label"] #=> RDF::Literal("Literal")
      #   RDF::RDFS.Literal.properties[:"http://www.w3.org/2000/01/rdf-schema#label"] #=> RDF::Literal("Literal")
      #
      # @return [Hash{Symbol => Array<RDF::Value>}]
      # @see #attribute_value
      def properties
        Hash.new {|hash, key| attribute_value(key)}
      end

      ##
      # Values of an attributes as {RDF::Value}.
      #
      # Attribute values are returned as either an {RDF::Value} or {Array<RDf::Value} if there is more than one value.
      #
      # Attribute values which are not already a {RDF::Value} (including strings and symbols) are converted by a heuristic loookup as follows:
      #
      # * An {RDF::URI} if it can be turned into a valid IRI using {RDF::Vocabulary.expand_pname}. This includes IRIs already in non-relative form.
      # * A {Hash{Symbol=>String,Array<String>}} is interpreted as a datatype/language map. If the key contains a ':', it is treated as a PName or IRI datatype applied to the values. Otherwise, it is treated as a language-tag applied to the values.
      # * {RDF::Literal::Date} if valid,
      # * {RDF::Literal::DateTime} if valid, 
      # * {RDF::Literal::Integer} if valid, 
      # * {RDF::Literal::Decimal} if valid, 
      # * {RDF::Literal::Double} if valid, 
      # * {RDF::Literal::Boolean} if valid
      # * Otherwise, {RDF::Literal} where type may be inferred by the class of the value.
      #
      # @param [Symbol] prop
      # @return [RDF::Value, Array<RDF::Value>]
      def attribute_value(prop)
        values = attributes[prop]
        return nil if values.nil?
        values = [values].compact unless values.is_a?(Array)
        prop_values = values.map do |value|
          v = value.is_a?(Symbol) ? value.to_s : value
          value = (RDF::Vocabulary.expand_pname(v) rescue nil) if v.is_a?(String) && v.include?(':')
          value = value.to_uri if value.respond_to?(:to_uri)
          value = if value.is_a?(RDF::Value) && value.valid?
            value
          elsif value.is_a?(Hash)
            # type/language map
            value.inject([]) do |memo, (k,v)|
              vv = [v] unless v.is_a?(Array)
              memo << if k.to_s.include?(':')
                dt = RDF::Vocabulary.expand_pname(v) rescue nil
                vv.map {|val| RDF::Literal(val, datatype: dt)}
              else
                vv.map {|val| RDF::Literal(val, language: k)}
              end
            end.flatten.compact.select(&:valid?)
          else
            # Use as most appropriate literal
            [
              RDF::Literal::Date,
              RDF::Literal::DateTime,
              RDF::Literal::Integer,
              RDF::Literal::Decimal,
              RDF::Literal::Double,
              RDF::Literal::Boolean,
              RDF::Literal
            ].inject(nil) do |m, klass|
              m || begin
                l = klass.new(v)
                l if l.valid?
              end
            end
          end
        end.flatten

        prop_values.length <= 1 ? prop_values.first : prop_values
      end

      ##
      # Enumerate each statement constructed from the defined vocabulary terms
      #
      # If a property value is known to be a {URI}, or expands to a {URI}, the `object` is a URI, otherwise, it will be a {Literal}.
      #
      # @yield statement
      # @yieldparam [RDF::Statement]
      def each_statement
        attributes.keys.each do |p|
          prop = ATTR_URIs.fetch(p) { RDF::Vocabulary::expand_pname(p)}
          values = attribute_value(p)
          values = [values].compact unless values.is_a?(Array)
          values.each do |value|
            yield RDF::Statement(self, prop, value) if prop.is_a?(RDF::URI)

            # Enumerate over value statements, if enumerable
            if value.is_a?(RDF::Enumerable) || (value.is_a?(Term) && value.node?)
              value.each_statement {|s| yield s}
            end
          end
        end
      end

      ##
      # Return an enumerator over {RDF::Statement} defined for this vocabulary.
      # @return [RDF::Enumerable::Enumerator]
      # @see    Object#enum_for
      def enum_for(method = :each_statement, *args)
        # Ensure that enumerators are, themselves, queryable
        this = self
        Enumerable::Enumerator.new do |yielder|
          this.send(method, *args) {|*y| yielder << (y.length > 1 ? y : y.first)}
        end
      end
      alias_method :to_enum, :enum_for

      ##
      # Returns a <code>String</code> representation of the URI object's state.
      #
      # @return [String] The URI object's state, as a <code>String</code>.
      def inspect
        sprintf("#<%s:%#0x ID:%s>", Term.to_s, self.object_id, self.to_s)
      end

      # Implement accessor to symbol attributes
      def respond_to?(method, include_all = false)
        case method
        when :comment, :notation, :note, :editorialNote, :definition,
             :label, :altLabel, :prefLabel, :type, :isDefinedBy
          true
        when :subClassOf, :subPropertyOf,
             :domainIncludes, :rangeIncludes,
             :equivalentClass, :intersectionOf, :unionOf
          self.class?
        when :domain, :range, :equivalentProperty, :inverseOf
          self.property?
        when :allValuesFrom, :cardinality,
             :maxCardinality, :minCardinality,
             :onProperty, :someValuesFrom
          self.restriction?
        when :broader, :exactMatch, :hasTopConcept, :inScheme, :member, :narrower, :related
          @attributes.key?(method)
        else
          super
        end
      end

      # Accessor for `schema:domainIncludes`
      # @return [RDF::URI]
      def domain_includes
        domainIncludes
      end

      # Accessor for `schema:rangeIncludes`
      # @return [RDF::URI]
      def range_includes
        rangeIncludes
      end

      ##
      # Serialize back to a Ruby source initializer. This is used primarily by {RDF::Vocabulary::Writer}.
      #
      # @param [String] indent
      # @return [String]
      def to_ruby(indent: "")
        "term(" +
        (self.uri? ? self.to_s.inspect + ",\n" : "\n") +
        "#{indent}  " +
        attributes.keys.sort.map do |k|
          values = attribute_value(k)
          values = [values].compact unless values.is_a?(Array)
          values = values.map do |value|
            if value.is_a?(Literal) && %w(: comment definition notation note editorialNote).include?(k.to_s)
              "%(#{value.to_s.gsub('(', '\(').gsub(')', '\)')})"
            elsif value.node? && value.is_a?(RDF::Vocabulary::Term)
              "#{value.to_ruby(indent: indent + "  ")}"
            elsif value.is_a?(RDF::Term)
              "#{value.to_s.inspect}"
            elsif value.is_a?(RDF::List)
              list_elements = value.map do |u|
                if u.uri?
                  "#{u.to_s.inspect}"
                elsif u.node? && u.respond_to?(:to_ruby)
                  u.to_ruby(indent: indent + "  ")
                else
                  "#{u.to_s.inspect}"
                end
              end
              "list(#{list_elements.join(', ')})"
            else
              "#{value.inspect}"
            end
          end
          "#{k.to_s.include?(':') ? k.to_s.inspect : k}: " +
          (values.length == 1 ? values.first : ('[' + values.join(',') + ']'))
        end.join(",\n#{indent}  ") + "\n#{indent})"

      end
    protected
      # Implement accessor to symbol attributes
      def method_missing(method, *args, &block)
        case method
        when :comment, :notation, :note, :editorialNote, :definition
          attribute_value(method)
        when :label, :altLabel, :prefLabel
          # Defaults to URI fragment or path tail
          begin
            attribute_value(method)
          rescue KeyError
            to_s.split(/[\/\#]/).last
          end
        when :type, :subClassOf, :subPropertyOf, :domain, :range, :isDefinedBy,
             :allValuesFrom, :cardinality, :equivalentClass, :equivalentProperty,
             :imports, :intersectionOf, :inverseOf, :maxCardinality, :minCardinality,
             :onProperty, :someValuesFrom, :unionOf,
             :domainIncludes, :rangeIncludes,
             :broader, :exactMatch, :hasTopConcept, :inScheme, :member, :narrower, :related

          # Return value as an Array, unless it is a list
          case value = attribute_value(method)
          when Array, RDF::List then value
          else [value].compact
          end
        else
          super
        end
      end
    end # Term
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

      ##
      # Returns the URI for the term `property` in this vocabulary.
      #
      # @param  [#to_s] name
      # @return [RDF::URI]
      # @raise [KeyError] if property not defined in vocabulary
      def [](name)
        props.fetch(name.to_sym)
      rescue KeyError
        raise KeyError, "#{name.inspect} not found in vocabulary #{self.__name__}"
      end
    end
  end # StrictVocabulary
end # RDF
