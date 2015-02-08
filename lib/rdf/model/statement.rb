module RDF
  ##
  # An RDF statement.
  #
  # @example Creating an RDF statement
  #   s = RDF::URI.new("http://rubygems.org/gems/rdf")
  #   p = RDF::DC.creator
  #   o = RDF::URI.new("http://ar.to/#self")
  #   RDF::Statement(s, p, o)
  #
  # @example Creating an RDF statement with a context
  #   uri = RDF::URI("http://example/")
  #   RDF::Statement(s, p, o, :context => uri)
  #
  # @example Creating an RDF statement from a `Hash`
  #   RDF::Statement({
  #     :subject   => RDF::URI.new("http://rubygems.org/gems/rdf"),
  #     :predicate => RDF::DC.creator,
  #     :object    => RDF::URI.new("http://ar.to/#self"),
  #   })
  #
  # @example Creating an RDF statement with interned nodes
  #   RDF::Statement(:s, p, :o)
  #
  # @example Creating an RDF statement with a string
  #   RDF::Statement(s, p, "o")
  #
  class Statement
    include RDF::Value

    ##
    # @private
    # @since 0.2.2
    def self.from(statement, options = {})
      case statement
        when Array, Query::Pattern
          context = statement[3] == false ? nil : statement[3]
          self.new(statement[0], statement[1], statement[2], options.merge(:context => context))
        when Statement then statement
        when Hash      then self.new(options.merge(statement))
        else raise ArgumentError, "expected RDF::Statement, Hash, or Array, but got #{statement.inspect}"
      end
    end

    # @return [Object]
    attr_accessor :id

    # @return [RDF::Resource]
    attr_accessor :context

    # @return [RDF::Resource]
    attr_accessor :subject

    # @return [RDF::URI]
    attr_accessor :predicate

    # @return [RDF::Term]
    attr_accessor :object

    ##
    # @overload initialize(options = {})
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Term]  :subject   (nil)
    #     A symbol is converted to an interned {Node}.
    #   @option options [RDF::URI]       :predicate (nil)
    #   @option options [RDF::Resource]      :object    (nil)
    #     if not a {Resource}, it is coerced to {Literal} or {Node} depending on if it is a symbol or something other than a {Term}.
    #   @option options [RDF::Term]  :context   (nil)
    #     Note, in RDF 1.1, a context MUST be an {Resource}.
    #   @return [RDF::Statement]
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [RDF::Term]          subject
    #     A symbol is converted to an interned {Node}.
    #   @param  [RDF::URI]               predicate
    #   @param  [RDF::Resource]              object
    #     if not a {Resource}, it is coerced to {Literal} or {Node} depending on if it is a symbol or something other than a {Term}.
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Term]  :context   (nil)
    #   @return [RDF::Statement]
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      case subject
        when Hash
          @options   = subject.dup
          @subject   = @options.delete(:subject)
          @predicate = @options.delete(:predicate)
          @object    = @options.delete(:object)
        else
          @options   = !options.empty? ? options.dup : {}
          @subject   = subject
          @predicate = predicate
          @object    = object
      end
      @id      = @options.delete(:id) if @options.has_key?(:id)
      @context = @options.delete(:context)
      initialize!
    end

    ##
    # @private
    def initialize!
      @context   = Node.intern(@context)   if @context.is_a?(Symbol)
      @subject   = case @subject
        when nil      then nil
        when Symbol   then Node.intern(@subject)
        when Term     then @subject
        when Value    then @subject.to_term
        else          raise ArgumentError, "expected subject to be nil or a term, was #{@subject.inspect}"
      end
      @predicate = Node.intern(@predicate) if @predicate.is_a?(Symbol)
      @object    = case @object
        when nil    then nil
        when Symbol then Node.intern(@object)
        when Term   then @object
        when Value  then @object.to_term
        else Literal.new(@object)
      end
    end

    ##
    # Returns `true` to indicate that this value is a statement.
    #
    # @return [Boolean]
    def statement?
      true
    end

    ##
    # Returns `true` if any element of the statement is not a
    # URI, Node or Literal.
    #
    # @return [Boolean]
    def variable?
      !(has_subject?    && subject.resource? && 
        has_predicate?  && predicate.resource? &&
        has_object?     && (object.resource? || object.literal?) &&
        (has_context?    ? context.resource? : true ))
    end

    ##
    # @return [Boolean]
    def invalid?
      !valid?
    end

    ##
    # @return [Boolean]
    def valid?
      has_subject?    && subject.resource? && subject.valid? && 
      has_predicate?  && predicate.uri? && predicate.valid? &&
      has_object?     && object.term? && object.valid? &&
      (has_context? ? context.resource? && context.valid? : true )
    end

    ##
    # @return [Boolean]
    def asserted?
      !quoted?
    end

    ##
    # @return [Boolean]
    def quoted?
      false
    end

    ##
    # @return [Boolean]
    def inferred?
      false
    end

    ##
    # @return [Boolean]
    def has_graph?
      has_context?
    end

    ##
    # @return [Boolean]
    def has_context?
      !!context
    end

    ##
    # @return [Boolean]
    def has_subject?
      !!subject
    end

    ##
    # @return [Boolean]
    def has_predicate?
      !!predicate
    end

    ##
    # @return [Boolean]
    def has_object?
      !!object
    end

    ##
    # Returns `true` if any resource of this statement is a blank node.
    #
    # @return [Boolean]
    def has_blank_nodes?
      to_quad.compact.any?(&:node?)
    end

    ##
    # @param  [Statement] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(Statement) && self == other && (self.context || false) == (other.context || false)
    end

    ##
    # @param  [Object] other
    # @return [Boolean]
    def ==(other)
      to_a == Array(other)
    end

    ##
    # @param  [Statement] other
    # @return [Boolean]
    def ===(other)
      return false if has_context?   && !context.eql?(other.context)
      return false if has_subject?   && !subject.eql?(other.subject)
      return false if has_predicate? && !predicate.eql?(other.predicate)
      return false if has_object?    && !object.eql?(other.object)
      return true
    end

    ##
    # @param  [Integer] index
    # @return [RDF::Term]
    def [](index)
      case index
        when 0 then self.subject
        when 1 then self.predicate
        when 2 then self.object
        when 3 then self.context
        else nil
      end
    end

    ##
    # @param  [Integer]    index
    # @param  [RDF::Term] value
    # @return [RDF::Term]
    def []=(index, value)
      case index
        when 0 then self.subject   = value
        when 1 then self.predicate = value
        when 2 then self.object    = value
        when 3 then self.context   = value
        else nil
      end
    end

    ##
    # @return [Array(RDF::Term)]
    def to_quad
      [subject, predicate, object, context]
    end

    ##
    # @return [Array(RDF::Term)]
    def to_triple
      [subject, predicate, object]
    end

    alias_method :to_a,   :to_triple
    alias_method :to_ary, :to_triple

    ##
    # Canonicalizes each unfrozen term in the statement
    #
    # @return [RDF::Statement] `self`
    # @since  1.0.8
    # @raise [ArgumentError] if any element cannot be canonicalized.
    def canonicalize!
      self.subject.canonicalize!    if has_subject? && !self.subject.frozen?
      self.predicate.canonicalize!  if has_predicate? && !self.predicate.frozen?
      self.object.canonicalize!     if has_object? && !self.object.frozen?
      self.context.canonicalize!    if has_context? && !self.context.frozen?
      self.validate!
      self
    end

    ##
    # Returns a version of the statement with each position in canonical form
    #
    # @return [RDF::Statement] `self` or nil if statement cannot be canonicalized
    # @since  1.0.8
    def canonicalize
      self.dup.canonicalize!
    rescue ArgumentError
      nil
    end

    ##
    # Returns the terms of this statement as a `Hash`.
    #
    # @param  [Symbol] subject_key
    # @param  [Symbol] predicate_key
    # @param  [Symbol] object_key
    # @return [Hash{Symbol => RDF::Term}]
    def to_hash(subject_key = :subject, predicate_key = :predicate, object_key = :object, context_key = :context)
      {subject_key => subject, predicate_key => predicate, object_key => object, context_key => context}
    end

    ##
    # Returns a string representation of this statement.
    #
    # @return [String]
    def to_s
      (context ? to_quad : to_triple).map do |term|
        term.respond_to?(:to_base) ? term.to_base : term.inspect
      end.join(" ") + " ."
    end

    ##
    # Returns a graph containing this statement in reified form.
    #
    # @param  [Hash{Symbol => Object}] options
    # @return [RDF::Graph]
    # @see    http://www.w3.org/TR/rdf-primer/#reification
    def reified(options = {})
      RDF::Graph.new(options[:context]) do |graph|
        subject = options[:subject] || RDF::Node.new(options[:id])
        graph << [subject, RDF.type,      RDF[:Statement]]
        graph << [subject, RDF.subject,   self.subject]
        graph << [subject, RDF.predicate, self.predicate]
        graph << [subject, RDF.object,    self.object]
      end
    end
  end
end
