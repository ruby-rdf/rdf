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
  class Statement < Value
    # @return [Object]
    attr_accessor :id

    # @return [Resource]
    attr_accessor :context

    # @return [Resource]
    attr_accessor :subject

    # @return [URI]
    attr_accessor :predicate

    # @return [Value]
    attr_accessor :object

    ##
    # @overload initialize(options = {})
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [Resource]       :subject   (nil)
    #   @option options [URI]            :predicate (nil)
    #   @option options [Value]          :object    (nil)
    #   @option options [Resource]       :context   (nil)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [Resource]               subject
    #   @param  [URI]                    predicate
    #   @param  [Value]                  object
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [Resource]       :context   (nil)
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      options = options.dup unless options.empty?
      case subject
        when Hash
          options    = subject.dup
          subject    = options.delete(:subject)
          predicate  = options.delete(:predicate)
          object     = options.delete(:object)
          initialize(subject, predicate, object, options)
        else
          @id        = options.delete(:id) if options.has_key?(:id)
          @context   = options.delete(:context) || options.delete(:graph)
          @options   = options
          @subject   = subject
          @predicate = predicate
          @object    = case object
            when nil        then nil
            when RDF::Value then object
            else RDF::Literal.new(object)
          end
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
    # @return [Value]
    def [](index)
      to_a[index]
    end

    ##
    # @param  [Integer] index
    # @param  [Value]   value
    # @return [Value]
    def []=(index, value)
      case index
        when 0 then subject   = value
        when 1 then predicate = value
        when 2 then object    = value
        when 3 then context   = value
      end
    end

    ##
    # @return [Array(Value)]
    def to_quad
      [subject, predicate, object, context]
    end

    ##
    # @return [Array(Value)]
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
    # @return [Hash{Symbol => Value}]
    def to_hash(subject_key = :subject, predicate_key = :predicate, object_key = :object)
      {subject_key => subject, predicate_key => predicate, object_key => object}
    end

    ##
    # Returns a string representation of this statement.
    #
    # @return [String]
    def to_s
      require 'stringio' unless defined?(StringIO)
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
