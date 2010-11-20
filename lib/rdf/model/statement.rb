module RDF
  ##
  # An RDF statement.
  #
  # @example Creating an RDF statement
  #   s = RDF::URI.new("http://rubygems.org/gems/rdf")
  #   p = RDF::DC.creator
  #   o = RDF::URI.new("http://ar.to/#self")
  #   RDF::Statement.new(s, p, o)
  #
  # @example Creating an RDF statement with a context
  #   RDF::Statement.new(s, p, o, :context => uri)
  #
  # @example Creating an RDF statement from a `Hash`
  #   RDF::Statement.new({
  #     :subject   => RDF::URI.new("http://rubygems.org/gems/rdf"),
  #     :predicate => RDF::DC.creator,
  #     :object    => RDF::URI.new("http://ar.to/#self"),
  #   })
  #
  class Statement
    include RDF::Value

    ##
    # @private
    # @since 0.2.2
    def self.from(statement)
      case statement
        when Statement then statement
        when Hash      then self.new(statement)
        when Array     then self.new(*statement)
        else raise ArgumentError.new("expected RDF::Statement, Hash, or Array, but got #{statement.inspect}")
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
    #   @option options [RDF::Resource]  :subject   (nil)
    #   @option options [RDF::URI]       :predicate (nil)
    #   @option options [RDF::Term]      :object    (nil)
    #   @option options [RDF::Resource]  :context   (nil)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [RDF::Resource]          subject
    #   @param  [RDF::URI]               predicate
    #   @param  [RDF::Term]              object
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Resource]  :context   (nil)
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
      @context = @options.delete(:context) || @options.delete(:graph)
      initialize!
    end

    ##
    # @private
    def initialize!
      @context   = Node.intern(@context)   if @context.is_a?(Symbol)
      @subject   = Node.intern(@subject)   if @subject.is_a?(Symbol)
      @predicate = Node.intern(@predicate) if @predicate.is_a?(Symbol)
      @object    = case @object
        when nil    then nil
        when Symbol then Node.intern(@object)
        when Term   then @object
        else Literal.new(@object)
      end
    end

    ##
    # @return [Boolean]
    def invalid?
      !valid?
    end

    ##
    # @return [Boolean]
    def valid?
      has_subject? && has_predicate? && has_object?
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
    # Returns `true` if the subject or object of this statement is a blank
    # node.
    #
    # @return [Boolean]
    def has_blank_nodes?
      (has_object? && object.node?) || (has_subject? && subject.node?)
    end

    ##
    # @param  [Statement] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(Statement) && self == other && self.context == other.context
    end

    ##
    # @param  [Object] other
    # @return [Boolean]
    def ==(other)
      to_a == other.to_a
    end

    ##
    # @param  [Statement] other
    # @return [Boolean]
    def ===(other)
      return false if has_context?   && context   != other.context
      return false if has_subject?   && subject   != other.subject
      return false if has_predicate? && predicate != other.predicate
      return false if has_object?    && object    != other.object
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
      StringIO.open do |buffer|
        buffer << case subject
          when RDF::Node    then subject.to_s
          when RDF::URI     then "<#{subject}>"
          else subject.inspect
        end
        buffer << " <#{predicate}> "
        buffer << case object
          when RDF::Literal then object.to_s
          when RDF::Node    then object.to_s
          when RDF::URI     then "<#{object}>"
          else object.inspect
        end
        buffer << case context
          when nil then " ."
          else " <#{context}> ."
        end
        buffer.string
      end
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
