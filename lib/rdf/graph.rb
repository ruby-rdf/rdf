module RDF
  ##
  # An RDF graph.
  class Graph < Resource
    include Enumerable

    # @return [URI]
    attr_accessor :uri

    # @return [Array<Statement>]
    attr_accessor :data

    ##
    # @param  [URI] uri
    # @yield  [graph]
    # @yieldparam [Graph]
    def initialize(uri = nil, options = {}, &block)
      @uri, @options = uri, options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # @return [Boolean]
    def named?()   !unnamed? end

    ##
    # @return [Boolean]
    def unnamed?() uri.nil? end

    ##
    # @return [Integer]
    def size() @data.size end

    ##
    # @yield [statement]
    # @yieldparam [Array<Statement>]
    # @return [Graph]
    def each(&block)
      each_statement(&block)
    end

    ##
    # @yield  [statement]
    # @yieldparam [Array<Statement>]
    # @return [Graph]
    def each_statement(&block)
      @data.each(&block)
      self
    end

    ##
    # @yield  [triple]
    # @yieldparam [Array(Value)]
    # @return [Graph]
    def each_triple(&block)
      @data.each do |statement|
        block.call(*statement.to_triple)
      end
      self
    end

    ##
    # @yield  [quad]
    # @yieldparam [Array(Value)]
    # @return [Graph]
    def each_quad(&block)
      @data.each do |statement|
        block.call(*statement.to_quad) # FIXME?
      end
      self
    end

    ##
    # @yield  [context]
    # @yieldparam [Resource]
    # @return [Graph]
    def each_context(&block)
      block.call(uri) unless unnamed?
      self
    end

    ##
    # @yield  [subject]
    # @yieldparam [Resource]
    # @return [Graph]
    def each_subject(&block)
      @data.each do |statement|
        block.call(statement.subject)
      end
      self
    end

    ##
    # @yield  [predicate]
    # @yieldparam [URI]
    # @return [Graph]
    def each_predicate(&block)
      @data.each do |statement|
        block.call(statement.predicate)
      end
      self
    end

    ##
    # @yield  [object]
    # @yieldparam [Value]
    # @return [Graph]
    def each_object(&block)
      @data.each do |statement|
        block.call(statement.object)
      end
      self
    end

    ##
    # @return [Array<Statement>]
    def statements(&block)
      block_given? ? each_statement(&block) : @data
    end

    ##
    # @return [Array<Array(Value)>]
    def triples(&block)
      block_given? ? each_triple(&block) : map { |statement| statement.to_triple }
    end

    ##
    # @return [Array<Array(Value)>]
    def quads(&block)
      block_given? ? each_quad(&block) : map { |statement| statement.to_quad }
    end

    ##
    # @return [Resource]
    def context() uri end

    ##
    # @return [Array<Resource>]
    def contexts
      block_given? ? each_context(&block) : (named? ? [uri] : [])
    end

    ##
    # @return [Array<Resource>]
    def subjects
      block_given? ? each_subject(&block) : map(&:subject)
    end

    ##
    # @return [Array<URI>]
    def predicates
      block_given? ? each_predicate(&block) : map(&:predicate)
    end

    ##
    # @return [Array<Value>]
    def objects
      block_given? ? each_object(&block) : map(&:object)
    end

    ##
    # @param  [Statement, Array(Value)]
    # @return [Graph]
    def <<(statement)
      @data << case statement
        when Array     then Statement.new(*statement)
        when Statement then statement
        else statement
      end
      self
    end

    ##
    # @return [URI]
    def to_uri() uri end

    ##
    # @return [String]
    def to_s
      named? ? uri.to_s : "<>"
    end
  end
end
