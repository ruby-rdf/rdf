# -*- encoding: utf-8 -*-

require 'bcp47_spec'

module RDF
  ##
  # An RDF literal.
  #
  # Subclasses of {RDF::Literal} should define DATATYPE and GRAMMAR constants, which are used for identifying the appropriate class to use for a datatype URI and to perform lexical matching on the value.
  #
  # Literal comparison with other {RDF::Value} instances call {RDF::Value#type_error}, which, returns false. Implementations wishing to have {RDF::TypeError} raised should mix-in {RDF::TypeCheck}. This is required for strict SPARQL conformance.
  #
  # Specific typed literals may have behavior different from the default implementation. See the following defined sub-classes for specific documentation. Additional sub-classes may be defined, and will interoperate by defining `DATATYPE` and `GRAMMAR` constants, in addition other required overrides of RDF::Literal behavior.
  #
  # In RDF 1.1, all literals are typed, including plain literals and language-tagged strings. Internally, plain literals are given the `xsd:string` datatype and language-tagged strings are given the `rdf:langString` datatype. Creating a plain literal, without a datatype or language, will automatically provide the `xsd:string` datatype; similar for language-tagged strings. Note that most serialization formats will remove this datatype. Code which depends on a literal having the `xsd:string` datatype being different from a plain literal (formally, without a datatype) may break. However note that the `#has\_datatype?` will continue to return `false` for plain or language-tagged strings.
  #
  # RDF 1.2 adds **directional language-tagged strings** which are effectively a subclass of **language-tagged strings** contining an additional **direction** component with value either **ltr** or **rtl** for Left-to-Right or Right-to-Left. This determines the general direction of a string when presented in n a user agent, where it might be in conflict with the inherent direction of the leading Unicode code points. Directional language-tagged strings are given the `rdf:langString` datatype.
  #
  # * {RDF::Literal::Boolean}
  # * {RDF::Literal::Date}
  # * {RDF::Literal::DateTime}
  # * {RDF::Literal::Decimal}
  # * {RDF::Literal::Double}
  # * {RDF::Literal::Integer}
  # * {RDF::Literal::Time}
  #
  # @example Creating a plain literal
  #   value = RDF::Literal.new("Hello, world!")
  #   value.plain?                                   #=> true`
  #
  # @example Creating a language-tagged string (1)
  #   value = RDF::Literal.new("Hello!", language: :en)
  #   value.language?                                #=> true
  #   value.language                                 #=> :en
  #
  # @example Creating a language-tagged string (2)
  #   RDF::Literal.new("Wazup?", language: :"en-US")
  #   RDF::Literal.new("Hej!",   language: :sv)
  #   RDF::Literal.new("¡Hola!", language: :es)
  #
  # @example Creating a directional language-tagged string
  #   value = RDF::Literal.new("Hello!", language: :en, direction: :ltr)
  #   value.language?                                #=> true
  #   value.language                                 #=> :en
  #   value.direction?                               #=> true
  #   value.direction                                #=> :ltr
  #
  # @example Creating an explicitly datatyped literal
  #   value = RDF::Literal.new("2009-12-31", datatype: RDF::XSD.date)
  #   value.datatype?                                #=> true
  #   value.datatype                                 #=> RDF::XSD.date
  #
  # @example Creating an implicitly datatyped literal
  #   value = RDF::Literal.new(Date.today)
  #   value.datatype?                                #=> true
  #   value.datatype                                 #=> RDF::XSD.date
  #
  # @example Creating implicitly datatyped literals
  #   RDF::Literal.new(false).datatype               #=> XSD.boolean
  #   RDF::Literal.new(true).datatype                #=> XSD.boolean
  #   RDF::Literal.new(123).datatype                 #=> XSD.integer
  #   RDF::Literal.new(9223372036854775807).datatype #=> XSD.integer
  #   RDF::Literal.new(3.1415).datatype              #=> XSD.double
  #   RDF::Literal.new(Time.now).datatype            #=> XSD.dateTime
  #   RDF::Literal.new(Date.new(2010)).datatype      #=> XSD.date
  #   RDF::Literal.new(DateTime.new(2010)).datatype  #=> XSD.dateTime
  #
  # @see http://www.w3.org/TR/rdf11-concepts/#section-Graph-Literal
  # @see http://www.w3.org/TR/rdf11-concepts/#section-Datatypes
  class Literal

  private
    @@subclasses       = [] # @private
    @@datatype_map     = nil # @private

    ##
    # @private
    # @return [void]
    def self.inherited(child)
      @@subclasses << child
      @@datatype_map = nil
      super
    end
  
  public

    require 'rdf/model/literal/numeric'
    require 'rdf/model/literal/boolean'
    require 'rdf/model/literal/decimal'
    require 'rdf/model/literal/integer'
    require 'rdf/model/literal/double'
    require 'rdf/model/literal/temporal'
    require 'rdf/model/literal/date'
    require 'rdf/model/literal/datetime'
    require 'rdf/model/literal/time'
    require 'rdf/model/literal/token'

    include RDF::Term

    ##
    # @private
    # Return Hash mapping from datatype URI to class
    def self.datatype_map
      @@datatype_map ||= Hash[
        @@subclasses
          .select {|klass| klass.const_defined?(:DATATYPE)}
          .map {|klass| [klass.const_get(:DATATYPE).to_s, klass]}
      ]
    end

    ##
    # @private
    # Return datatype class for uri, or nil if none is found
    def self.datatyped_class(uri)
      datatype_map[uri]
    end

    ##
    # @private
    def self.new(value, language: nil, datatype: nil, direction: nil, lexical: nil, validate: false, canonicalize: false, **options)
      if language && direction
        raise ArgumentError, "datatype with language and direction must be rdf:dirLangString" if (datatype || RDF.dirLangString).to_s != RDF.dirLangString.to_s
      elsif language
        raise ArgumentError, "datatype with language must be rdf:langString" if (datatype || RDF.langString).to_s != RDF.langString.to_s
      else
        raise ArgumentError, "datatype not compatible with language or direction" if language || direction
      end

      klass = case
        when !self.equal?(RDF::Literal)
          self # subclasses can be directly constructed without type dispatch
        when typed_literal = datatyped_class(datatype.to_s)
          typed_literal
        else case value
          when ::TrueClass  then RDF::Literal::Boolean
          when ::FalseClass then RDF::Literal::Boolean
          when ::Integer    then RDF::Literal::Integer
          when ::Float      then RDF::Literal::Double
          when ::BigDecimal then RDF::Literal::Decimal
          when ::Rational   then RDF::Literal::Double
          when ::DateTime   then RDF::Literal::DateTime
          when ::Time       then RDF::Literal::DateTime
          when ::Date       then RDF::Literal::Date
          when ::Symbol     then RDF::Literal::Token
          else self
        end
      end
      literal = klass.allocate
      literal.send(:initialize, value, language: language, datatype: datatype, direction: direction, **options)
      literal.validate!     if validate
      literal.canonicalize! if canonicalize
      literal
    end

    TRUE  = RDF::Literal.new(true)
    FALSE = RDF::Literal.new(false)
    ZERO  = RDF::Literal.new(0)
    XSD_STRING = RDF::URI("http://www.w3.org/2001/XMLSchema#string")

    # @return [Symbol] The language-tag (optional). Implies `datatype` is `rdf:langString`.
    attr_accessor :language

    # @return [Symbol] The base direction (optional). Implies `datatype` is `rdf:dirLangString`.
    attr_accessor :direction

    # @return [URI] The XML Schema datatype URI (optional).
    attr_accessor :datatype

    ##
    # Literals without a datatype are given either `xsd:string`, `rdf:langString`, or `rdf:dirLangString`,
    # depending on if there is `language` and/or `direction`.
    #
    # @param  [Object] value
    # @param  [Symbol]  direction (nil)
    #   Initial text direction.
    # @param  [Symbol]  language (nil)
    #   Language is downcased to ensure proper matching
    # @param [String]  lexical (nil)
    #   Supplied lexical representation of this literal,
    #   otherwise it comes from transforming `value` to a string form..
    # @param [URI]     datatype (nil)
    # @param [Boolean] validate (false)
    # @param [Boolean] canonicalize (false)
    # @raise [ArgumentError]
    #   if there is a language and datatype is no rdf:langString
    #   or datatype is rdf:langString and there is no language
    # @see http://www.w3.org/TR/rdf11-concepts/#section-Graph-Literal
    # @see http://www.w3.org/TR/rdf11-concepts/#section-Datatypes
    # @see #to_s
    def initialize(value, language: nil, datatype: nil, direction: nil, lexical: nil, validate: false, canonicalize: false, **options)
      @object   = value.freeze
      @string   = lexical if lexical
      @string   = value if !defined?(@string) && value.is_a?(String)
      @string   = @string.encode(Encoding::UTF_8).freeze if instance_variable_defined?(:@string)
      @object   = @string if instance_variable_defined?(:@string) && @object.is_a?(String)
      @language = language.to_s.downcase.to_sym if language
      @direction = direction.to_s.to_sym if direction
      @datatype = RDF::URI(datatype).freeze if datatype
      @datatype ||= self.class.const_get(:DATATYPE) if self.class.const_defined?(:DATATYPE)
      @datatype ||= if instance_variable_defined?(:@language) && @language &&
                       instance_variable_defined?(:@direction) && @direction
        RDF.dirLangString
      elsif instance_variable_defined?(:@language) && @language
        RDF.langString
      else
        XSD_STRING
      end
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def value
      instance_variable_defined?(:@string) && @string || to_s
    end

    ##
    # @return [Object]
    def object
      defined?(@object) ? @object : value
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean] `true` or `false`
    def literal?
      true
    end

    ##
    # Term compatibility according to SPARQL
    #
    # Compatibility of two arguments is defined as:
    # * The arguments are simple literals or literals typed as xsd:string
    # * The arguments are plain literals with identical language-tags and directions
    # * The first argument is a plain literal with language-tag and the second argument is a simple literal or literal typed as xsd:string
    #
    # @example
    #     compatible?("abc"	"b")                         #=> true
    #     compatible?("abc"	"b"^^xsd:string)             #=> true
    #     compatible?("abc"^^xsd:string	"b")             #=> true
    #     compatible?("abc"^^xsd:string	"b"^^xsd:string) #=> true
    #     compatible?("abc"@en	"b")                     #=> true
    #     compatible?("abc"@en	"b"^^xsd:string)         #=> true
    #     compatible?("abc"@en	"b"@en)                  #=> true
    #     compatible?("abc"@fr	"b"@ja)                  #=> false
    #     compatible?("abc"	"b"@ja)                      #=> false
    #     compatible?("abc"	"b"@en)                      #=> false
    #     compatible?("abc"^^xsd:string	"b"@en)          #=> false
    #
    # @see http://www.w3.org/TR/sparql11-query/#func-arg-compatibility
    # @since 2.0
    def compatible?(other)
      return false unless other.literal? && plain? && other.plain?

      # * The arguments are simple literals or literals typed as xsd:string
      # * The arguments are plain literals with identical language-tags
      # * The first argument is a plain literal with language-tag and the second argument is a simple literal or literal typed as xsd:string
      language? || direction? ?
        (language == other.language && direction == other.direction || other.datatype == XSD_STRING) :
        other.datatype == XSD_STRING
    end

    ##
    # Returns a hash code for this literal.
    #
    # @return [Integer]
    def hash
      @hash ||= [to_s, datatype, language, direction].compact.hash
    end


    ##
    # Returns a hash code for the value.
    #
    # @return [Integer]
    def value_hash
      @value_hash ||= value.hash
    end

    ##
    # @private
    def freeze
      hash.freeze
      value_hash.freeze
      super
    end

    ##
    # Determins if `self` is the same term as `other`.
    #
    # @example
    #   RDF::Literal(1).eql?(RDF::Literal(1.0))  #=> false
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    def eql?(other)
      self.equal?(other) ||
        (self.class.eql?(other.class) &&
         self.value_hash == other.value_hash &&
         self.value.eql?(other.value) &&
         self.language.to_s.eql?(other.language.to_s) &&
         self.direction.to_s.eql?(other.direction.to_s) &&
         self.datatype.eql?(other.datatype))
    end

    ##
    # Returns `true` if this literal is equivalent to `other` (with type check).
    #
    # @example
    #   RDF::Literal(1) == RDF::Literal(1.0)     #=> true
    #
    # @param  [Object] other
    # @return [Boolean] `true` or `false`
    #
    # @see http://www.w3.org/TR/rdf-sparql-query/#func-RDFterm-equal
    # @see http://www.w3.org/TR/rdf-concepts/#section-Literal-Equality
    def ==(other)
      case other
      when Literal
        case
        when self.eql?(other)
          true
        when self.direction? && self.direction == other.direction
          # Literals with directions can compare if languages and directions are identical
          self.value_hash == other.value_hash && self.value == other.value
        when self.language? && self.language == other.language
          # Literals with languages can compare if languages are identical
          self.value_hash == other.value_hash && self.value == other.value
        when self.simple? && other.simple?
          self.value_hash == other.value_hash && self.value == other.value
        when other.comperable_datatype?(self) || self.comperable_datatype?(other)
          # Comparing plain with undefined datatypes does not generate an error, but returns false
          # From data-r2/expr-equal/eq-2-2.
          false
        else
          type_error("unable to determine whether #{self.inspect} and #{other.inspect} are equivalent")
        end
      when String
        self.simple? && self.value.eql?(other)
      else false
      end
    end
    alias_method :===, :==

    ##
    # Compares `self` to `other` for sorting purposes (with type check).
    #
    # @param  [Object]  other
    # @return [Integer] `-1`, `0`, or `1`
    def <=>(other)
      case other
      when Literal
        case
        when self.eql?(other)
          0
        when self.language? && other.language?
          # Literals with languages can compare if languages are identical
          self.to_s <=> other.to_s
        when self.simple? && other.simple?
          self.to_s <=> other.to_s
        when !self.valid?
          type_error("#{self.inspect} is invalid") || 0
        when !other.valid?
          type_error("#{other.inspect} is invalid") || 0
        when self.comperable_datatype2?(other)
          self.object <=> other.object
        else
          type_error("#{self.inspect} and #{other.inspect} are not comperable") || 0
        end
      when String
        self.simple? && self.value <=> other
      else 1
      end
    end

    ##
    # Returns `true` if this is a plain literal. A plain literal
    # may have a language and direction, but may not have a datatype. For
    # all practical purposes, this includes xsd:string literals
    # too.
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-plain-literal
    def plain?
      [
        RDF.langString,
        RDF.dirLangString,
        XSD_STRING
      ].include?(datatype)
    end

    ##
    # Returns `true` if this is a simple literal.
    # A simple literal has no datatype or language.
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/sparql11-query/#simple_literal
    def simple?
      datatype == XSD_STRING
    end

    ##
    # Returns `true` if this is a language-tagged string.
    #
    # @return [Boolean] `true` or `false`
    # @see https://www.w3.org/TR/rdf-concepts/#dfn-language-tagged-string
    def language?
      [RDF.langString, RDF.dirLangString].include?(datatype)
    end
    alias_method :has_language?, :language?

    ##
    # Returns `true` if this is a directional language-tagged string.
    #
    # @return [Boolean] `true` or `false`
    # @see https://www.w3.org/TR/rdf-concepts/#dfn-dir-lang-string
    def direction?
      datatype == RDF.dirLangString
    end

    ##
    # Returns `true` if this is a datatyped literal.
    #
    # For historical reasons, this excludes xsd:string and rdf:langString
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-typed-literal
    def datatype?
      !plain? && !language? && !direction?
    end
    alias_method :has_datatype?,  :datatype?
    alias_method :typed?,         :datatype?
    alias_method :datatyped?,     :datatype?

    ##
    # Returns `true` if the value adheres to the defined grammar of the
    # datatype.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.2.1
    def valid?
      BCP47.parse(language.to_s) if language?
      return false if direction? && !%i{ltr rtl}.include?(direction)
      return false if datatype? && datatype.invalid?
      grammar = self.class.const_get(:GRAMMAR) rescue nil
      grammar.nil? || value.match?(grammar)
    rescue BCP47::InvalidLanguageTag
      false
    end

    ##
    # Returns `true` if this is a language-tagged literal in the English
    # language.
    #
    # @return [Boolean] `true` or `false`
    # @since  3.3.2
    def english?
      /\Aen(?:-[A-Za-z]{2})?\z/ === language.to_s
    end

    ##
    # Validates the value using {RDF::Value#valid?}, raising an error if the value is
    # invalid.
    #
    # @return [RDF::Literal] `self`
    # @raise  [ArgumentError] if the value is invalid
    # @since  0.2.1
    def validate!
      raise ArgumentError, "#{to_s.inspect} is not a valid <#{datatype.to_s}> literal" if invalid?
      self
    end

    ##
    # Returns `true` if the literal has a datatype and the comparison should
    # return false instead of raise a type error.
    #
    # This behavior is intuited from SPARQL data-r2/expr-equal/eq-2-2
    # @return [Boolean]
    def comperable_datatype?(other)
      return false unless self.plain? || self.language?

      case other
      when RDF::Literal::Numeric, RDF::Literal::Boolean,
           RDF::Literal::Date, RDF::Literal::Time, RDF::Literal::DateTime
        # Invald types can be compared without raising a TypeError if literal has a language (open-eq-08)
        !other.valid? && self.language?
      else
        # An unknown datatype may not be used for comparison, unless it has a language? (open-eq-8)
        self.language?
      end
    end

    ##
    # Returns `true` if the literals are comperable.
    #
    # Used for <=> operator.
    #
    # @return [Boolean]
    def comperable_datatype2?(other)
      case self
      when RDF::Literal::Numeric, RDF::Literal::Boolean
        case other
        when RDF::Literal::Numeric, RDF::Literal::Boolean
          true
        else
          false
        end
      else
        self.datatype == other.datatype
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # Subclasses should override this as needed and appropriate.
    #
    # @return [RDF::Literal] `self`
    # @since  0.3.0
    def canonicalize!
      self
    end

    ##
    # Returns the literal, first removing all whitespace on both ends of the value, and then changing remaining consecutive whitespace groups into one space each.
    #
    # Note that it handles both ASCII and Unicode whitespace.
    #
    # @see [String#squish](http://apidock.com/rails/String/squish)
    # @return [RDF::Literal] a new literal based on `self`.
    def squish(*other_string)
      self.dup.squish!
    end

    ##
    # Performs a destructive {#squish}.
    #
    # @see [String#squish!](http://apidock.com/rails/String/squish%21)
    # @return self
    def squish!
      @string = value.
        gsub(/\A[[:space:]]+/, '').
        gsub(/[[:space:]]+\z/, '').
        gsub(/[[:space:]]+/, ' ')
      self
    end

    ##
    # Escape a literal using ECHAR escapes.
    #
    #    ECHAR ::= '\' [tbnrf"'\]
    #
    # @note N-Triples only requires '\"\n\r' to be escaped.
    #
    # @param  [String] string
    # @return [String]
    # @see RDF::Term#escape
    def escape(string)
      string.gsub('\\', '\\\\').
             gsub("\t", '\\t').
             gsub("\b", '\\b').
             gsub("\n", '\\n').
             gsub("\r", '\\r').
             gsub("\f", '\\f').
             gsub('"', '\\"').
             freeze
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @object.to_s.freeze
    end

    ##
    # Returns a human-readable value for the literal
    #
    # @return [String]
    # @since 1.1.6
    def humanize(lang = :en)
      to_s.freeze
    end

    ##
    # Returns a developer-friendly representation of `self`.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, RDF::NTriples.serialize(self))
    end

    protected

    ##
    # @overload #to_str
    #   This method is implemented when the datatype is `xsd:string`, `rdf:langString`, or `rdf:dirLangString`
    #   @return [String]
    def method_missing(name, *args)
      case name
      when :to_str
        return to_s if [RDF.langString, RDF.dirLangString, XSD_STRING].include?(@datatype)
      end
      super
    end

    def respond_to_missing?(name, include_private = false)
      case name
      when :to_str
        return true if [RDF.langString, RDF.dirLangString, XSD_STRING].include?(@datatype)
      end
      super
    end
  end # Literal
end # RDF
