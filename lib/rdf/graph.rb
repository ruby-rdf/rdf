module RDF
  ##
  # An RDF graph.
  class Graph < Value
    attr_accessor :uri
    attr_accessor :data

    include Enumerable

    def initialize(uri = nil, options = {}, &block)
      @uri, @options = uri, options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    def named?()   !unnamed? end
    def unnamed?() uri.nil? end

    def size() @data.size end

    def each(&block)
      each_statement(&block)
    end

    def each_statement(&block)
      @data.each(&block)
    end

    def each_triple(&block)
      @data.each do |statement|
        block.call(*statement.to_triple)
      end
    end

    def each_quad(&block)
      @data.each do |statement|
        block.call(*statement.to_quad) # FIXME?
      end
    end

    def each_context(&block)
      block.call(uri) unless unnamed?
    end

    def each_subject(&block)
      @data.each do |statement|
        block.call(statement.subject)
      end
    end

    def each_predicate(&block)
      @data.each do |statement|
        block.call(statement.predicate)
      end
    end

    def each_object(&block)
      @data.each do |statement|
        block.call(statement.object)
      end
    end

    def statements(&block)
      block_given? ? each_statement(&block) : @data
    end

    def triples(&block)
      block_given? ? each_triple(&block) : map { |statement| statement.to_triple }
    end

    def quads(&block)
      block_given? ? each_quad(&block) : map { |statement| statement.to_quad }
    end

    def context() uri end

    def contexts
      block_given? ? each_context(&block) : (named? ? [uri] : [])
    end

    def subjects
      block_given? ? each_subject(&block) : map(&:subject)
    end

    def predicates
      block_given? ? each_predicate(&block) : map(&:predicate)
    end

    def objects
      block_given? ? each_object(&block) : map(&:object)
    end

    def <<(statement)
      @data << case statement
        when Array     then Statement.new(*statement)
        when Statement then statement
        else statement
      end
    end

    def to_uri() uri end

    def to_s
      named? ? uri.to_s : "<>"
    end
  end
end
