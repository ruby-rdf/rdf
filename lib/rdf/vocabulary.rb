module RDF
  ##
  # A {Vocabulary} represents an RDFS or OWL vocabulary.
  #
  # A {Vocabulary} can also serve as a Domain Specific Language (DSL) for generating an RDF Graph definition for the vocabulary (see {RDF::Vocabulary#to_enum}).
  #
  # ### Defining a vocabulary using the DSL
  # Vocabularies can be defined based on {RDF::Vocabulary} or {RDF::StrictVocabulary} using a simple Domain Specific Language (DSL). Terms of the vocabulary are specified using either `property` or `term` (alias), with the attributes of the term listed in a hash. See {property} for description of the hash.
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
  # Other vocabularies are defined in the [rdf-vocab](http://rubygems.org/gems/rdf-vocab) gem
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
  # @example Method calls are converted to the typical RDF camelcase convention
  #   foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
  #   foaf.family_name    #=> RDF::URI("http://xmlns.com/foaf/0.1/familyName")
  #   owl.same_as         #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
  #   # []-style access is left as is
  #   foaf['family_name'] #=> RDF::URI("http://xmlns.com/foaf/0.1/family_name")
  #   foaf[:family_name]  #=> RDF::URI("http://xmlns.com/foaf/0.1/family_name")
  #
  #
  #
  # @example Generating RDF from a vocabulary definition
  #   graph = RDF::Graph.new << RDF::RDFS.to_enum
  #   graph.dump(:ntriples)
  #
  # @example Defining a simple vocabulary
  #   class EX < RDF::StrictVocabulay("http://example/ns#")
  #     term :Class,
  #       label: "My Class",
  #       comment: "Good to use as an example",
  #       "rdf:type" => "rdfs:Class",
  #       "rdfs:subClassOf" => "http://example/SuperClass"
  #   end
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
          @@subclasses.select(&:name).each(&block)
        else
          __properties__.each(&block)
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
      #   Defines a new property or class in the vocabulary.
      #
      #   @param [String, #to_s] name
      #   @param [Hash{Symbol => Object}] options
      #     Any other values are expected to be String which expands to a {URI} using built-in vocabulary prefixes. The value is a `String` or `Array<String>` which is interpreted according to the `range` of the associated property.
      #   @option options [String, Array<String>] :label
      #     Shortcut for `rdfs:label`, values are String interpreted as a {Literal}.
      #   @option options [String, Array<String>] :comment
      #     Shortcut for `rdfs:comment`, values are String interpreted as a {Literal}.
      #   @option options [String, Array<String>] :subClassOf
      #     Shortcut for `rdfs:subClassOf`, values are String interpreted as a {URI}.
      #   @option options [String, Array<String>] :subPropertyOf
      #     Shortcut for `rdfs:subPropertyOf`, values are String interpreted as a {URI}.
      #   @option options [String, Array<String>] :domain
      #     Shortcut for `rdfs:domain`, values are String interpreted as a {URI}.
      #   @option options [String, Array<String>] :range
      #     Shortcut for `rdfs:range`, values are String interpreted as a {URI}.
      #   @option options [String, Array<String>] :type
      #     Shortcut for `rdf:type`, values are String interpreted as a {URI}.
      #   @return [RDF::Vocabulary::Term]
      def property(*args)
        case args.length
        when 0
          Term.intern("#{self}property", attributes: {label: "property", vocab: self})
        else
          name, options = args
          options = {label: name.to_s, vocab: self}.merge(options || {})
          uri_str = [to_s, name.to_s].join('')
          Term.cache.delete(uri_str.to_sym)  # Clear any previous entry
          prop = Term.intern(uri_str, attributes: options)
          props[name.to_sym] = prop

          # If name is empty, also treat it as the ontology
          @ontology ||= prop if name.to_s.empty?

          # Define an accessor, except for problematic properties
          (class << self; self; end).send(:define_method, name) { prop } unless %w(property hash).include?(name.to_s)
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
      #     Any other values are expected to be String which expands to a {URI} using built-in vocabulary prefixes. The value is a `String` or `Array<String>` which is interpreted according to the `range` of the associated property.
      #   @option options [String, Array<String>] :label
      #     Shortcut for `rdfs:label`, values are String interpreted as a {Literal}.
      #   @option options [String, Array<String>] :comment
      #     Shortcut for `rdfs:comment`, values are String interpreted as a {Literal}.
      #   @option options [String, Array<String>] :type
      #     Shortcut for `rdf:type`, values are String interpreted as a {URI}.
      #   @return [RDF::Vocabulary::Term]
      #
      # @note If the ontology URI has the vocabulary namespace URI as a prefix, it may also be defined using `#property` or `#term`
      def ontology(*args)
        case args.length
        when 0
          @ontology
        else
          uri, options = args
          options = {vocab: self}.merge(options || {})
          Term.cache.delete(uri.to_s.to_sym)  # Clear any previous entry
          @ontology = Term.intern(uri.to_s, attributes: options)

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
      # Attempt to expand a Compact IRI/PName/QName using loaded vocabularies
      #
      # @param [String, #to_s] pname
      # @return [RDF::URI]
      # @raise [KeyError] if pname suffix not found in identified vocabulary
      def expand_pname(pname)
        prefix, suffix = pname.to_s.split(":", 2)
        if prefix == "rdf"
          RDF[suffix]
        elsif vocab = RDF::Vocabulary.each.detect {|v| v.__name__ && v.__prefix__ == prefix.to_sym}
          suffix.to_s.empty? ? vocab.to_uri : vocab[suffix]
        else
          (RDF::Vocabulary.find_term(pname) rescue nil) || RDF::URI(pname)
        end
      end

      ##
      # Return the Vocabulary associated with a URI. Allows the trailing '/' or '#' to be excluded
      #
      # @param [RDF::URI] uri
      # @return [Vocabulary]
      def find(uri)
        RDF::Vocabulary.detect do |v|
          if uri.length >= v.to_uri.length
            RDF::URI(uri).start_with?(v.to_uri)
          else
            v.to_uri.to_s.sub(%r([/#]$), '') == uri.to_s
          end
        end
      end

      ##
      # Return the Vocabulary term associated with a  URI
      #
      # @param [RDF::URI] uri
      # @return [Vocabulary::Term]
      def find_term(uri)
        uri = RDF::URI(uri)
        return uri if uri.is_a?(Vocabulary::Term)
        if vocab = find(uri)
          if vocab.ontology == uri
            vocab.ontology
          else
            vocab[uri.to_s[vocab.to_uri.to_s.length..-1].to_s]
          end
        end
      end

      ##
      # Returns the URI for the term `property` in this vocabulary.
      #
      # @param  [#to_s] property
      # @return [RDF::URI]
      def [](property)
        if props.has_key?(property.to_sym)
          props[property.to_sym]
        else
          Term.intern([to_s, property.to_s].join(''), attributes: {vocab: self})
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
          Array(self.ontology.attributes[:"owl:imports"]).map do |pn|
            find(expand_pname(pn)) rescue nil
          end.compact
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
        RDF::URI.intern(to_s)
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
        @ontology.each_statement(&block) if @ontology && @ontology != self
      end

      ##
      # Returns a string representation of this vocabulary class.
      #
      # @return [String]
      def to_s
        @@uris.has_key?(self) ? @@uris[self].to_s : super
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
        graph.each do |statement|
          next unless statement.subject.uri?
          next unless statement.subject.start_with?(url) || statement.subject == ont_url
          name = statement.subject.to_s[url.to_s.length..-1].to_s
          term = (term_defs[name.to_sym] ||= {})
          term[:uri] = statement.subject if name.empty?

          key = case statement.predicate
          when RDF.type                                     then :type
          when RDF::RDFS.subClassOf                         then :subClassOf
          when RDF::RDFS.subPropertyOf                      then :subPropertyOf
          when RDF::RDFS.range                              then :range
          when RDF::RDFS.domain                             then :domain
          when RDF::RDFS.comment                            then :comment
          when RDF::RDFS.label                              then :label
          when RDF::URI("http://schema.org/inverseOf")      then :inverseOf
          when RDF::URI("http://schema.org/domainIncludes") then :domainIncludes
          when RDF::URI("http://schema.org/rangeIncludes")  then :rangeIncludes
          else                                              statement.predicate.pname.to_sym
          end

          value = if statement.object.uri?
            statement.object.pname
          elsif statement.object.literal? && (statement.object.language || :en).to_s =~ /^en-?/
            statement.object.to_s
          end

          (term[key] ||= []) << value if value
        end

        # Create extra terms
        term_defs = case extra
        when Array
          extra.inject({}) {|memo, s| memo[s.to_sym] = {label: s.to_s}; memo}.merge(term_defs)
        when Hash
          extra.merge(term_defs)
        else
          term_defs
        end

        term_defs.each do |term, attributes|
          if term == :""
            uri = attributes.delete(:uri)
            vocab.__ontology__ uri, attributes
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
      # Returns a suggested CURIE/PName prefix for this vocabulary class.
      #
      # @return [Symbol]
      # @since  0.3.0
      def __prefix__
        __name__.split('::').last.downcase.to_sym
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
        if %w(to_ary).include?(property.to_s)
          super
        elsif args.empty? && !to_s.empty?
          Term.intern([to_s, property.to_s].join(''), attributes: {vocab: self})
        else
          super
        end
      end

    private

      def props; @properties ||= {}; end
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
      Term.intern([to_s, property.to_s].join(''), attributes: {vocab: self.class})
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

    # A Vocabulary Term is a URI that can also act as an {Enumerable} to generate the RDF definition of vocabulary terms as defined within the vocabulary definition.
    class Term < RDF::URI
      # @!method comment
      #   `rdfs:comment` accessor
      #   @return [String]
      # @!method label
      #   `rdfs:label` accessor
      #   @return [String]
      # @!method type
      #   `rdf:type` accessor
      #   @return [RDF::URI]
      # @!method subClassOf
      #   `rdfs:subClassOf` accessor
      #   @return [RDF::URI]
      # @!method subPropertyOf
      #   `rdfs:subPropertyOf` accessor
      #   @return [RDF::URI]
      # @!method domain
      #   `rdfs:domain` accessor
      #   @return [RDF::URI]
      # @!method range
      #   `rdfs:range` accessor
      #   @return [RDF::URI]
      # @!method inverseOf
      #   `owl:inverseOf` accessor
      #   @return [RDF::URI]
      # @!method domainIncludes
      #   `schema:domainIncludes` accessor
      #   @return [RDF::URI]
      # @!method rangeIncludes
      #   `schema:rangeIncludes` accoessor
      #   @return [RDF::URI]
      # @!attribute [rw] attributes
      #   Attributes of this vocabulary term, used for finding `label` and `comment` and to serialize the term back to RDF.
      #   @return [Hash{Symbol,Resource => Term, #to_s}]
      attr_accessor :attributes

      ##
      # @overload URI(uri, **options)
      #   @param  [URI, String, #to_s]    uri
      #   @param [Hash{Symbol,Resource => Term, #to_s}] attributes
      #     Attributes of this vocabulary term, used for finding `label` and `comment` and to serialize the term back to RDF
      #   @param  [Hash{Symbol => Object}] options
      #   @option options [Boolean] :validate (false)
      #   @option options [Boolean] :canonicalize (false)
      #
      # @overload URI(**options)
      #   @param  [Hash{Symbol => Object}] options
      #   @param [Hash{Symbol,Resource => Term, #to_s}] attributes
      #     Attributes of this vocabulary term, used for finding `label` and `comment` and to serialize the term back to RDF
      #   @option options options [Boolean] :validate (false)
      #   @option options options [Boolean] :canonicalize (false)
      #   @option options [Vocabulary] :vocab The {Vocabulary} associated with this term.
      #   @option options [String, #to_s] :scheme The scheme component.
      #   @option options [String, #to_s] :user The user component.
      #   @option options [String, #to_s] :password The password component.
      #   @option options [String, #to_s] :userinfo
      #     The u optionsserinfo component. If this is supplied, the user and password
      #     compo optionsnents must be omitted.
      #   @option options [String, #to_s] :host The host component.
      #   @option options [String, #to_s] :port The port component.
      #   @option options [String, #to_s] :authority
      #     The a optionsuthority component. If this is supplied, the user, password,
      #     useri optionsnfo, host, and port components must be omitted.
      #   @option options [String, #to_s] :path The path component.
      #   @option options [String, #to_s] :query The query component.
      #   @option options [String, #to_s] :fragment The fragment component.
      def initialize(*args, attributes:, **options)
        @attributes = attributes
        if RUBY_ENGINE == "rbx"
          super(*args, **options)
        else
          super
        end
      end

      ##
      # Vocabulary of this term.
      #
      # @return [RDF::Vocabulary]
      def vocab; @attributes.fetch(:vocab); end

      ##
      # Returns a duplicate copy of `self`.
      #
      # @return [RDF::URI]
      def dup
        self.class.new((@value || @object).dup, attributes: @attributes)
      end

      ##
      # Determine if the URI is a valid according to RFC3987
      #
      # @return [Boolean] `true` or `false`
      # @since 0.3.9
      def valid?
        # Validate relative to RFC3987
        to_s.match(RDF::URI::IRI) || false
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def class?
        !!(self.type.to_s =~ /Class/)
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def property?
        !!(self.type.to_s =~ /Property/)
      end

      ##
      # Is this a class term?
      # @return [Boolean]
      def datatype?
        !!(self.type.to_s =~ /Datatype/)
      end

      ##
      # Is this neither a class, property or datatype term?
      # @return [Boolean]
      def other?
        !!(self.type.to_s !~ /(Class|Property|Datatype)/)
      end

      ##
      # Enumerate each statement constructed from the defined vocabulary terms
      #
      # If a property value is known to be a {URI}, or expands to a {URI}, the `object` is a URI, otherwise, it will be a {Literal}.
      #
      # @yield statement
      # @yieldparam [RDF::Statement]
      def each_statement
        attributes.reject {|p| p == :vocab}.each do |prop, values|
          Array(values).each do |value|
            begin
              case prop
              when :type
                prop = RDF.type
                value = RDF::Vocabulary.expand_pname(value)
              when :subClassOf
                prop = RDFS.subClassOf
                value = RDF::Vocabulary.expand_pname(value)
              when :subPropertyOf
                prop = RDFS.subPropertyOf
                value = RDF::Vocabulary.expand_pname(value)
              when :domain
                prop = RDFS.domain
                value = RDF::Vocabulary.expand_pname(value)
              when :range
                prop = RDFS.range
                value = RDF::Vocabulary.expand_pname(value)
              when :inverseOf
                prop = RDF::URI("http://schema.org/inverseOf")
                value = RDF::Vocabulary.expand_pname(value)
              when :domainIncludes
                prop = RDF::URI("http://schema.org/domainIncludes")
                value = RDF::Vocabulary.expand_pname(value)
              when :rangeIncludes
                prop = RDF::URI("http://schema.org/rangeIncludes")
                value = RDF::Vocabulary.expand_pname(value)
              when :label
                prop = RDF::RDFS.label
              when :comment
                prop = RDF::RDFS.comment
              else
                prop = RDF::Vocabulary.expand_pname(prop.to_s)
                next unless prop

                v = value.to_s
                value = RDF::Vocabulary.expand_pname(v)
                unless value && value.valid?
                  # Use as most appropriate literal
                  value = [
                    RDF::Literal::Date,
                    RDF::Literal::DateTime,
                    RDF::Literal::Integer,
                    RDF::Literal::Decimal,
                    RDF::Literal::Double,
                    RDF::Literal::Boolean,
                    RDF::Literal
                  ].inject(nil) do |memo, klass|
                    l = klass.new(v)
                    memo || (l if l.valid?)
                  end
                end
              end
              yield RDF::Statement(self, prop, value)
            rescue KeyError
              # Skip things eroneously defined in the vocabulary
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
        sprintf("#<%s:%#0x URI:%s>", Term.to_s, self.object_id, self.to_s)
      end

      # Implement accessor to symbol attributes
      def respond_to?(method, include_all = false)
        @attributes.has_key?(method) || super
      end

      # Accessor for `schema:domainIncludes`
      # @return [RDF::URI]
      def domain_includes
        Array(@attributes[:domainIncludes]).map  {|v| RDF::Vocabulary.expand_pname(v)}
      end

      # Accessor for `schema:rangeIncludes`
      # @return [RDF::URI]
      def range_includes
        Array(@attributes[:rangeIncludes]).map  {|v| RDF::Vocabulary.expand_pname(v)}
      end

    protected
      # Implement accessor to symbol attributes
      def method_missing(method, *args, &block)
        case method
        when :comment
          @attributes.fetch(method, "")
        when :label
          @attributes.fetch(method, to_s.split(/[\/\#]/).last)
        when :type, :subClassOf, :subPropertyOf, :domain, :range, :inverseOf, :domainIncludes, :rangeIncludes
          Array(@attributes[method]).map {|v| RDF::Vocabulary.expand_pname(v)}
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
        raise KeyError, "#{name} not found in vocabulary #{self.__name__}"
      end
    end
  end # StrictVocabulary
end # RDF
