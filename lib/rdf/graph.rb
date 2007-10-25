module RDF
  class Graph < Node
    include Enumerable

    attr :statements
    alias :to_a :statements

    def <<(statement)
      @statements << statement
    end

    def each(&block)
      @statements.each { |stmt| yield stmt }
    end

    def subjects
      @statements.each { |stmt| yield stmt[0] }
    end

    def predicates
      # TODO
    end

    def objects
      # TODO
    end

    def load(file)
      # TODO
    end

    def dump(file)
      # TODO
    end

  end
end
