module RDF
  class Statement
    attr_accessor :subject
    attr_accessor :predicate
    attr_accessor :object

    def initialize(s, p, o, options = {})
      @subject, @predicate, @object = s, p, o
    end

    def to_s
      # TODO
      super
    end

    def inspect
      # TODO
      super
    end
  end
end
