module RDF
  ##
  # An RDF graph.
  class Graph < Resource
    include RDF::Enumerable
    include RDF::Queryable

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
      @data = []

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    def graph?
      true
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
      @data.each(&block)
    end

    ##
    # @return [Resource]
    def context
      uri
    end

    ##
    # @return [Array<Resource>]
    def contexts
      named? ? [uri] : []
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
