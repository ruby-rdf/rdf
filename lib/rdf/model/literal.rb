module RDF
  ##
  # An RDF literal.
  #
  # Subclasses of {RDF::Literal} should define DATATYPE and GRAMMAR constants, which are used
  # for identifying the appropriate class to use for a datatype URI and to perform lexical
  # matching on the value.
  #
  # @example Creating a plain literal
  #   value = RDF::Literal.new("Hello, world!")
  #   value.plain?                                   #=> true
  #
  # @example Creating a language-tagged literal (1)
  #   value = RDF::Literal.new("Hello!", :language => :en)
  #   value.has_language?                            #=> true
  #   value.language                                 #=> :en
  #
  # @example Creating a language-tagged literal (2)
  #   RDF::Literal.new("Wazup?", :language => :"en-US")
  #   RDF::Literal.new("Hej!",   :language => :sv)
  #   RDF::Literal.new("¡Hola!", :language => :es)
  #
  # @example Creating an explicitly datatyped literal
  #   value = RDF::Literal.new("2009-12-31", :datatype => RDF::XSD.date)
  #   value.has_datatype?                            #=> true
  #   value.datatype                                 #=> RDF::XSD.date
  #
  # @example Creating an implicitly datatyped literal
  #   value = RDF::Literal.new(Date.today)
  #   value.has_datatype?                            #=> true
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
  # @see http://www.w3.org/TR/rdf-concepts/#section-Literals
  # @see http://www.w3.org/TR/rdf-concepts/#section-Datatypes-intro
  class Literal

  private
    @@subclasses       = [] # @private

    ##
    # @private
    # @return [void]
    def self.inherited(child)
      @@subclasses << child
      super
    end
  
  public

    require 'rdf/model/literal/numeric'
    require 'rdf/model/literal/boolean'
    require 'rdf/model/literal/decimal'
    require 'rdf/model/literal/integer'
    require 'rdf/model/literal/double'
    require 'rdf/model/literal/date'
    require 'rdf/model/literal/dateTime'
    require 'rdf/model/literal/time'
    require 'rdf/model/literal/token'
    require 'rdf/model/literal/xml'

    include RDF::Term

    ##
    # @private
    # Return datatype class for uri, or nil if none is found
    def self.datatyped_class(uri)
      @@subclasses.detect {|klass| klass.const_defined?(:DATATYPE) && klass.const_get(:DATATYPE) == uri}
    end

    ##
    # @private
    def self.new(value, options = {})
      klass = case
        when !self.equal?(RDF::Literal)
          self # subclasses can be directly constructed without type dispatch
        when typed_literal = datatyped_class(RDF::URI(options[:datatype]))
          typed_literal
        else case value
          when ::TrueClass  then RDF::Literal::Boolean
          when ::FalseClass then RDF::Literal::Boolean
          when ::Integer    then RDF::Literal::Integer
          when ::Float      then RDF::Literal::Double
          when ::BigDecimal then RDF::Literal::Decimal
          when ::DateTime   then RDF::Literal::DateTime
          when ::Date       then RDF::Literal::Date
          when ::Time       then RDF::Literal::Time # FIXME: Ruby's Time class can represent datetimes as well
          when ::Symbol     then RDF::Literal::Token
          else self
        end
      end
      literal = klass.allocate
      literal.send(:initialize, value, options)
      literal.validate!     if options[:validate]
      literal.canonicalize! if options[:canonicalize]
      literal
    end

    TRUE  = RDF::Literal.new(true).freeze
    FALSE = RDF::Literal.new(false).freeze
    ZERO  = RDF::Literal.new(0).freeze

    # @return [Symbol] The language tag (optional).
    attr_accessor :language

    # @return [URI] The XML Schema datatype URI (optional).
    attr_accessor :datatype

    ##
    # @param  [Object] value
    # @option options [Symbol] :language (nil)
    # @option options [URI]    :datatype (nil)
    def initialize(value, options = {})
      @object   = value
      @string   = options[:lexical] if options[:lexical]
      @string   = value if !defined?(@string) && value.is_a?(String)
      @language = options[:language].to_s.to_sym if options[:language]
      @datatype = RDF::URI(options[:datatype]) if options[:datatype]
      @datatype ||= self.class.const_get(:DATATYPE) if self.class.const_defined?(:DATATYPE)
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def value
      @string || to_s
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
    # Returns `false`.
    #
    # @return [Boolean] `true` or `false`
    def anonymous?
      false
    end

    ##
    # Returns a hash code for this literal.
    #
    # @return [Fixnum]
    def hash
      to_s.hash
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
         self.value.eql?(other.value) &&
         self.language.to_s.downcase.eql?(other.language.to_s.downcase) &&
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
        when self.has_language? && self.language.to_s.downcase == other.language.to_s.downcase
          # Literals with languages can compare if languages are identical
          self.value == other.value
        when (self.simple? || self.datatype == XSD.string) && (other.simple? || other.datatype == XSD.string)
          self.value == other.value
        when other.comperable_datatype?(self) || self.comperable_datatype?(other)
          # Comoparing plain with undefined datatypes does not generate an error, but returns false
          # From data-r2/expr-equal/eq-2-2.
          false
        else
          type_error("unable to determine whether #{self.inspect} and #{other.inspect} are equivalent")
        end
      when String
        self.plain? && self.value.eql?(other)
      else false
      end
    end
    alias_method :===, :==

    ##
    # Returns `true` if this is a plain literal.
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-plain-literal
    def plain?
      language.nil? && datatype.nil?
    end
    alias_method :simple?, :plain?

    ##
    # Returns `true` if this is a language-tagged literal.
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-plain-literal
    def has_language?
      !language.nil?
    end
    alias_method :language?, :has_language?

    ##
    # Returns `true` if this is a datatyped literal.
    #
    # @return [Boolean] `true` or `false`
    # @see http://www.w3.org/TR/rdf-concepts/#dfn-typed-literal
    def has_datatype?
      !datatype.nil?
    end
    alias_method :datatype?,  :has_datatype?
    alias_method :typed?,     :has_datatype?
    alias_method :datatyped?, :has_datatype?

    ##
    # Returns `true` if the value adheres to the defined grammar of the
    # datatype.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.2.1
    def valid?
      grammar = self.class.const_get(:GRAMMAR) rescue nil
      grammar.nil? || !!(value =~ grammar)
    end

    ##
    # Returns `true` if the value does not adhere to the defined grammar of
    # the datatype.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.2.1
    def invalid?
      !valid?
    end

    ##
    # Returns `true` if the literal has a datatype and the comparison should
    # return false instead of raise a type error.
    #
    # This behavior is intuited from SPARQL data-r2/expr-equal/eq-2-2
    # @return [Boolean]
    def comperable_datatype?(other)
      return false unless self.plain? || self.has_language?

      case other
      when RDF::Literal::Numeric, RDF::Literal::Boolean,
           RDF::Literal::Date, RDF::Literal::Time, RDF::Literal::DateTime
        # Invald types can be compared without raising a TypeError if literal has a language (open-eq-08)
        !other.valid? && self.has_language?
      else
        case other.datatype
        when XSD.string
          true
        when nil
          # A different language will not generate a type error
          other.has_language?
        else
          # An unknown datatype may not be used for comparison, unless it has a language? (open-eq-8)
          self.has_language?
        end
      end
    end

    ##
    # Validates the value using {#valid?}, raising an error if the value is
    # invalid.
    #
    # @return [RDF::Literal] `self`
    # @raise  [ArgumentError] if the value is invalid
    # @since  0.2.1
    def validate!
      raise ArgumentError, "#{to_s.inspect} is not a valid <#{datatype.to_s}> literal" if invalid?
      self
    end
    alias_method :validate, :validate!

    ##
    # Returns a copy of this literal converted into its canonical lexical
    # representation.
    #
    # Subclasses should override `#canonicalize!` as needed and appropriate,
    # not this method.
    #
    # @return [RDF::Literal]
    # @since  0.2.1
    def canonicalize
      self.dup.canonicalize!
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # Subclasses should override this as needed and appropriate.
    #
    # @return [RDF::Literal] `self`
    # @since  0.3.0
    def canonicalize!
      @language = @language.to_s.downcase.to_sym if @language
      self
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @object.to_s
    end

    ##
    # Returns a developer-friendly representation of `self`.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, RDF::NTriples.serialize(self))
    end
  end # Literal
end # RDF
