module RDF
  ##
  # An RDF statement.
  class Statement
    attr_accessor :context
    attr_accessor :subject
    attr_accessor :predicate
    attr_accessor :object

    def initialize(s, p, o, options = {})
      @subject, @predicate, @object = s, p, o
      @context = options[:context] if options[:context]
    end

    def subject?()   !!subject end
    def predicate?() !!predicate end
    def object?()    !!object end
    def context?()   !!context end
    def asserted?()  !quoted? end
    def quoted?()    false end

    def ==(other)
      to_a == other.to_a
    end

    def [](index)
      to_a[index]
    end

    def to_a
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

    def inspect
      super # TODO
    end
  end
end
