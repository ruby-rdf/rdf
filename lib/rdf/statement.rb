module RDF
  class Statement
    attr_accessor :context
    attr_accessor :subject
    attr_accessor :predicate
    attr_accessor :object

    def initialize(s, p, o, options = {})
      @subject, @predicate, @object = s, p, o
      @context = options[:context] if options[:context]
    end

    def context?
      !!context
    end

    def asserted?
      !quoted?
    end

    def quoted?
      false
    end

    def to_a
      [subject, predicate, object]
    end

    def to_s
      super # TODO
    end

    def inspect
      super # TODO
    end
  end
end
