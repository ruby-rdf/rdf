module RDF
  ##
  # An RDF statement.
  #
  # @example Creating an RDF statement
  #   s = RDF::URI.new("https://rubygems.org/gems/rdf")
  #   p = RDF::Vocab::DC.creator
  #   o = RDF::URI.new("http://ar.to/#self")
  #   RDF::Statement(s, p, o)
  #
  # @example Creating an RDF statement with a graph_name
  #   uri = RDF::URI("http://example/")
  #   RDF::Statement(s, p, o, graph_name: uri)
  #
  # @example Creating an RDF statement from a `Hash`
  #   RDF::Statement({
  #     subject:   RDF::URI.new("https://rubygems.org/gems/rdf"),
  #     predicate: RDF::Vocab::DC.creator,
  #     object:    RDF::URI.new("http://ar.to/#self"),
  #   })
  #
  # @example Creating an RDF statement with interned nodes
  #   RDF::Statement(:s, p, :o)
  #
  # @example Creating an RDF statement with a string
  #   RDF::Statement(s, p, "o")
  #
  class Statement
    include RDF::Resource

    ##
    # @private
    # @since 0.2.2
    def self.from(statement, graph_name: nil, **options)
      case statement
        when Array, Query::Pattern
          graph_name ||= statement[3] == false ? nil : statement[3]
          self.new(statement[0], statement[1], statement[2], graph_name: graph_name, **options)
        when Statement then statement
        when Hash      then self.new(options.merge(statement))
        else raise ArgumentError, "expected RDF::Statement, Hash, or Array, but got #{statement.inspect}"
      end
    end

    # @return [Object]
    attr_accessor :id

    # @return [RDF::Resource]
    attr_accessor :graph_name

    # @return [RDF::Resource]
    attr_accessor :subject

    # @return [RDF::URI]
    attr_accessor :predicate

    # @return [RDF::Term]
    attr_accessor :object

    # @return [Hash{Symbol => Object}]
    attr_accessor :options

    ##
    # @overload initialize(**options)
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Term]  :subject   (nil)
    #     A symbol is converted to an interned {Node}.
    #   @option options [RDF::URI]       :predicate (nil)
    #   @option options [RDF::Resource]      :object    (nil)
    #     if not a {Resource}, it is coerced to {Literal} or {Node} depending on if it is a symbol or something other than a {Term}.
    #   @option options [RDF::Term]  :graph_name   (nil)
    #     Note, in RDF 1.1, a graph name MUST be an {Resource}.
    #   @option options [Boolean] :inferred used as a marker to record that this statement was inferred based on semantic relationships (T-Box).
    #   @option options [Boolean] :tripleTerm used as a marker to record that this statement appears as the object of another RDF::Statement.
    #   @return [RDF::Statement]
    #
    # @overload initialize(subject, predicate, object, **options)
    #   @param  [RDF::Term]          subject
    #     A symbol is converted to an interned {Node}.
    #   @param  [RDF::URI]           predicate
    #   @param  [RDF::Resource]      object
    #     if not a {Resource}, it is coerced to {Literal} or {Node} depending on if it is a symbol or something other than a {Term}.
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Term]  :graph_name   (nil)
    #     Note, in RDF 1.1, a graph name MUST be an {Resource}.
    #   @option options [Boolean] :inferred used as a marker to record that this statement was inferred based on semantic relationships (T-Box).
    #   @option options [Boolean] :tripleTerm used as a marker to record that this statement appears as the object of another RDF::Statement.
    #   @return [RDF::Statement]
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      if subject.is_a?(Hash)
        @options   = Hash[subject] # faster subject.dup
        @subject   = @options.delete(:subject)
        @predicate = @options.delete(:predicate)
        @object    = @options.delete(:object)
      else
        @options   = !options.empty? ? Hash[options] : {}
        @subject   = subject
        @predicate = predicate
        @object    = object
      end
      @id          = @options.delete(:id) if @options.key?(:id)
      @graph_name  = @options.delete(:graph_name)
      initialize!
    end

    ##
    # @private
    def initialize!
      @graph_name   = Node.intern(@graph_name)   if @graph_name.is_a?(Symbol)
      @subject   = if @subject.is_a?(Value)
        @subject.to_term
      elsif @subject.is_a?(Symbol)
        Node.intern(@subject)
      elsif @subject.nil?
        nil
      else
        raise ArgumentError, "expected subject to be nil or a resource, was #{@subject.inspect}"
      end
      @predicate = Node.intern(@predicate) if @predicate.is_a?(Symbol)
      @object    = if @object.is_a?(Value)
        @object.to_term
      elsif @object.is_a?(Symbol)
        Node.intern(@object)
      elsif @object.nil?
        nil
      else
        Literal.new(@object)
      end
      @graph_name = if @graph_name.is_a?(Value)
        @graph_name.to_term
      elsif @graph_name.is_a?(Symbol)
        Node.intern(@graph_name)
      elsif !@graph_name
        @graph_name
      else
        raise ArgumentError, "expected graph_name to be nil or a resource, was #{@graph_name.inspect}"
      end
    end

    ##
    # @overload statement?
    #   Returns `true` if `self` is a {RDF::Statement}.
    #
    #   @return [Boolean]
    # @overload statement?(statement)
    #   Returns `true` if `self` contains the given {RDF::Statement}.
    #
    #   @param  [RDF::Statement] statement
    #   @return [Boolean]
    def statement?(*args)
      case args.length
      when 0 then true
      when 1 then self == args.first || subject.statement?(*args) || object.statement?(*args)
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end

    ##
    # @overload variable?
    #   Returns `true` if any element of the statement is not a
    # URI, Node or Literal.
    #
    #   @return [Boolean]
    # @overload variable?(variables)
    #   Returns `true` if this statement contains any of the variables.
    #
    #   @param  [Array<Symbol, #to_sym>] variables
    #   @return [Boolean]
    def variable?(*args)
      case args.length
      when 0
        !(subject?    && subject.constant? &&
          predicate?  && predicate.constant? &&
          object?     && object.constant? &&
          (graph?     ? graph_name.constant? : true))
      when 1
        to_quad.any? {|t| t.respond_to?(:variable?) && t.variable?(*args)}
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end

    ##
    # Returns `true` if any element of the statement is, itself, a statement.
    #
    # Note: Nomenclature is evolving, alternatives could include `#complex?` and `#nested?`
    # @return [Boolean]
    def embedded?
      object && object.statement?
    end

    ##
    # @return [Boolean]
    def invalid?
      !valid?
    end

    ##
    # @return [Boolean]
    def valid?
      subject?    && subject.resource? && subject.valid? &&
      predicate?  && predicate.uri? && predicate.valid? &&
      object?     && object.term? && object.valid? &&
      (graph?      ? (graph_name.resource? && graph_name.valid?) : true)
    end

    ##
    # @return [Boolean]
    def asserted?
      !embedded?
    end

    ##
    # @return [Boolean]
    def tripleTerm?
      !!@options[:tripleTerm]
    end

    ##
    # @return [Boolean]
    def inferred?
      !!@options[:inferred]
    end

    ##
    # Determines if the statement is incomplete, vs. invalid. An incomplete statement is one in which any of `subject`, `predicate`, or `object`, are nil.
    #
    # @return [Boolean]
    # @since 3.0
    def incomplete?
      to_triple.any?(&:nil?)
    end

    ##
    # Determines if the statement is complete, vs. invalid. A complete statement is one in which none of `subject`, `predicate`, or `object`, are nil.
    #
    # @return [Boolean]
    # @since 3.0
    def complete?
      !incomplete?
    end

    ##
    # @overload graph?
    #   Returns `true` if the statement has a graph name.
    #
    #   @return [Boolean]
    # @overload graph?(name)
    #   Returns `true` if `self` contains the given RDF graph_name.
    #
    #   @param  [RDF::Resource, false] graph_name
    #     Use value `false` to query for the default graph_name
    #   @return [Boolean]
    def graph?(*args)
      case args.length
      when 0 then !!graph_name
      when 1 then graph_name == args.first
      else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
      end
    end
    alias_method :name?, :graph?
    alias_method :has_graph?, :graph?
    alias_method :has_name?, :graph?

    ##
    # @return [Boolean]
    def subject?
      !!subject
    end
    alias_method :has_subject?, :subject?

    ##
    # @return [Boolean]
    def predicate?
      !!predicate
    end
    alias_method :has_predicate?, :predicate?

    ##
    # @return [Boolean]
    def object?
      !!object
    end
    alias_method :has_object?, :object?

    ##
    # Returns `true` if any resource of this statement is a blank node
    # or has an embedded statement including a blank node.
    #
    # @return [Boolean]
    # @since 2.0
    def node?
      to_quad.compact.any?(&:node?)
    end
    alias_method :has_blank_nodes?, :node?

    ##
    # Checks statement equality as a quad.
    #
    # @param  [Statement] other
    # @return [Boolean]
    #
    # @see RDF::URI#==
    # @see RDF::Node#==
    # @see RDF::Literal#==
    # @see RDF::Query::Variable#==
    def eql?(other)
      other.is_a?(Statement) && self.to_a.eql?(other.to_a) && (self.graph_name || false) == (other.graph_name || false)
    end

    ##
    # Generates a Integer hash value as a quad.
    def hash
      @hash ||= to_quad.hash
    end

    ##
    # Checks statement equality as a triple.
    #
    # @param  [Object] other
    # @return [Boolean]
    #
    # @see RDF::URI#==
    # @see RDF::Node#==
    # @see RDF::Literal#==
    # @see RDF::Query::Variable#==
    def ==(other)
      to_a == Array(other) &&
        !(other.is_a?(RDF::Value) && other.list?)
    end

    ##
    # Checks statement equality with patterns.
    #
    # Uses `#eql?` to compare each of `#subject`, `#predicate`, `#object`, and
    # `#graph_name` to those of `other`. Any statement part which is not
    # present in `self` is ignored.
    #
    # @example
    #   statement = RDF::Statement.new(RDF::URI('s'), RDF::URI('p'), RDF::URI('o'))
    #   pattern   = RDF::Statement.new(RDF::URI('s'), RDF::URI('p'), RDF::Query::Variable.new)
    #
    #   # true
    #   statement === statement
    #   pattern   === statement
    #   RDF::Statement.new(nil, nil, nil) === statement
    #
    #   # false
    #   statement === pattern
    #   statement === RDF::Statement.new(nil, nil, nil)
    #
    # @param  [Statement] other
    # @return [Boolean]
    #
    # @see RDF::URI#eql?
    # @see RDF::Node#eql?
    # @see RDF::Literal#eql?
    # @see RDF::Query::Variable#eql?
    def ===(other)
      return false if object?    && !object.eql?(other.object)
      return false if predicate? && !predicate.eql?(other.predicate)
      return false if subject?   && !subject.eql?(other.subject)
      return false if graph?     && !graph_name.eql?(other.graph_name)
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
        when 3 then self.graph_name
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
        when 3 then self.graph_name   = value
        else nil
      end
    end

    ##
    # @return [Array(RDF::Term)]
    def to_quad
      [subject, predicate, object, graph_name]
    end

    ##
    # @return [Array(RDF::Term)]
    def to_triple
      [subject, predicate, object]
    end
    alias_method :to_a, :to_triple

    ##
    # Returns an array of all the non-nil non-statement terms.
    # @return [Array(RDF::Term)]
    def terms
      to_quad.map {|t| t.respond_to?(:terms) ? t.terms : t}.flatten.compact
    end

    ##
    # Canonicalizes each unfrozen term in the statement.
    #
    # @return [RDF::Statement] `self`
    # @since  1.0.8
    # @raise [ArgumentError] if any element cannot be canonicalized.
    def canonicalize!
      self.subject.canonicalize!    if subject? && !self.subject.frozen?
      self.predicate.canonicalize!  if predicate? && !self.predicate.frozen?
      self.object.canonicalize!     if object? && !self.object.frozen?
      self.graph_name.canonicalize! if graph? && !self.graph_name.frozen?
      self.validate!
      @hash = nil
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

    # New statement with duplicated components (other than blank nodes)
    #
    # @return [RDF::Statement]
    def dup
      options = Hash[@options]
      options[:subject] = subject.is_a?(RDF::Node) ? subject : subject.dup
      options[:predicate] = predicate.dup
      options[:object] = object.is_a?(RDF::Node) ? object : object.dup
      options[:graph_name] = graph_name.is_a?(RDF::Node) ? graph_name : graph_name.dup if graph_name
      RDF::Statement.new(options)
    end

    ##
    # Returns the terms of this statement as a `Hash`.
    #
    # @param  [Symbol] subject_key
    # @param  [Symbol] predicate_key
    # @param  [Symbol] object_key
    # @return [Hash{Symbol => RDF::Term}]
    def to_h(subject_key = :subject, predicate_key = :predicate, object_key = :object, graph_key = :graph_name)
      {subject_key => subject, predicate_key => predicate, object_key => object, graph_key => graph_name}
    end

    ##
    # Returns a string representation of this statement.
    #
    # @return [String]
    def to_s
      (graph_name ? to_quad : to_triple).map do |term|
        if term.is_a?(Statement)
          "<<(#{term.to_s[0..-3]})>>"
        elsif term.respond_to?(:to_base)
          term.to_base
        else
          term.inspect
        end
      end.join(" ") + " ."
    end

    ##
    # Returns a graph containing this statement in reified form.
    #
    # @param [RDF::Term]  subject   (nil)
    #   Subject of reification.
    # @param [RDF::Term]  id   (nil)
    #   Node identifier, when subject is anonymous
    # @param [RDF::Term]  graph_name   (nil)
    #   Note, in RDF 1.1, a graph name MUST be an {Resource}.
    # @return [RDF::Graph]
    # @see    http://www.w3.org/TR/rdf-primer/#reification
    def reified(subject: nil, id: nil, graph_name: nil)
      RDF::Graph.new(graph_name: graph_name) do |graph|
        subject = subject || RDF::Node.new(id)
        graph << [subject, RDF.type,      RDF[:Statement]]
        graph << [subject, RDF.subject,   self.subject]
        graph << [subject, RDF.predicate, self.predicate]
        graph << [subject, RDF.object,    self.object]
      end
    end
  end
end
