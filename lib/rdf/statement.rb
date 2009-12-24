module RDF
  ##
  # An RDF statement.
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
    # @param  [Resource] s
    # @param  [URI]      p
    # @param  [Value]    o
    # @option options [Resource] :context (nil)
    def initialize(s = nil, p = nil, o = nil, options = {})
      @context = options[:context] || options[:graph]
      @subject, @predicate, @object = s, p, o
    end

    ##
    # @return [Boolean]
    def asserted?()  !quoted? end

    ##
    # @return [Boolean]
    def quoted?()    false end

    ##
    # @return [Boolean]
    def has_graph?()     has_context? end

    ##
    # @return [Boolean]
    def has_context?()   !!context end

    ##
    # @return [Boolean]
    def has_subject?()   !!subject end

    ##
    # @return [Boolean]
    def has_predicate?() !!predicate end

    ##
    # @return [Boolean]
    def has_object?()    !!object end

    ##
    # @param  [Statement] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(Statement) && self == other
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
    def to_triple
      [subject, predicate, object]
    end

    ##
    # @return [Array(Value)]
    def to_quad
      [subject, predicate, object, context]
    end

    ##
    # @return [Array(Value)]
    def to_a()   to_triple end

    ##
    # @return [Array(Value)]
    def to_ary() to_triple end

    ##
    # @return [Hash]
    def to_hash
      { subject => { predicate => object } }
    end

    ##
    # @return [String]
    def to_s
      require 'stringio' unless defined?(StringIO)
      StringIO.open do |buffer|
        buffer << "<#{subject}> "
        buffer << "<#{predicate}> "
        buffer << "<#{object}> ."
        buffer.string
      end
    end
  end
end
