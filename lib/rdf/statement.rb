module RDF
  ##
  # An RDF statement.
  class Statement < Value
    attr_accessor :id
    attr_accessor :context
    attr_accessor :subject
    attr_accessor :predicate
    attr_accessor :object

    def initialize(s = nil, p = nil, o = nil, options = {})
      @context = options[:context] || options[:graph]
      @subject, @predicate, @object = s, p, o
    end

    def asserted?()  !quoted? end
    def quoted?()    false end

    def has_graph?()     has_context? end
    def has_context?()   !!context end
    def has_subject?()   !!subject end
    def has_predicate?() !!predicate end
    def has_object?()    !!object end

    def ==(other)
      to_a == other.to_a
    end

    def ===(other)
      return false if has_subject?   && subject   != other.subject
      return false if has_predicate? && predicate != other.predicate
      return false if has_object?    && object    != other.object
      return true
    end

    def [](index)
      to_a[index]
    end

    def []=(index, value)
      case index
        when 0 then subject   = value
        when 1 then predicate = value
        when 2 then object    = value
        when 3 then context   = value
      end
    end

    def to_a() to_ary end

    def to_ary
      [subject, predicate, object]
    end

    def to_hash
      { subject => { predicate => object } }
    end

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
