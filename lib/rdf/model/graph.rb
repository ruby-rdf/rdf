module RDF
  ##
  # An RDF graph.
  #
  # @example Creating an empty unnamed graph
  #   graph = Graph.new
  #
  # @example Creating an empty named graph
  #   graph = Graph.new("http://rubygems.org/")
  #
  # @example Loading graph data from a URL (1)
  #   require 'rdf/raptor'  # for RDF/XML support
  #   
  #   graph = RDF::Graph.new("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
  #   graph.load!
  #
  # @example Loading graph data from a URL (2)
  #   require 'rdf/raptor'  # for RDF/XML support
  #   
  #   graph = RDF::Graph.load("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
  #
  class Graph < Resource
    include RDF::Enumerable
    include RDF::Mutable
    include RDF::Queryable

    ##
    # @return [Resource]
    attr_accessor :context

    ##
    # @return [Array<Statement>]
    attr_accessor :data

    ##
    # Creates a new `Graph` instance populated by the RDF data returned by
    # dereferencing the given context URL.
    #
    # @param  [String, #to_s]          url
    # @param  [Hash{Symbol => Object}] options
    # @yield  [graph]
    # @yieldparam [Graph] graph
    # @return [Graph]
    # @since  0.1.17
    def self.load(url, options = {}, &block)
      self.new(url, options) do |graph|
        graph.load! unless graph.unnamed?

        if block_given?
          case block.arity
            when 1 then block.call(graph)
            else graph.instance_eval(&block)
          end
        end
      end
    end

    ##
    # @param  [Resource]               context
    # @param  [Hash{Symbol => Object}] options
    # @yield  [graph]
    # @yieldparam [Graph]
    def initialize(context = nil, options = {}, &block)
      @context = case context
        when nil then nil
        when RDF::Resource then context
        else RDF::URI.new(context)
      end

      @options = options.dup
      @data    = @options.delete(:data) || []

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # @return [void]
    def load!(*args)
      case
        when args.empty?
          load(context.to_s, context ? {:base_uri => context}.merge(@options) : @options)
        else super
      end
    end

    ##
    # Returns `true` to indicate that this is a graph.
    #
    # @return [Boolean]
    def graph?
      true
    end

    ##
    # Returns `true` if this is a named graph.
    #
    # @return [Boolean]
    def named?
      !unnamed?
    end

    ##
    # Returns `true` if this is a unnamed graph.
    #
    # @return [Boolean]
    def unnamed?
      context.nil?
    end

    ##
    # Returns all unique RDF contexts for this graph.
    #
    # @return [Array<Resource>]
    def contexts
      named? ? [context] : []
    end

    ##
    # Returns the URI representation of this graph.
    #
    # @return [URI]
    def to_uri
      context
    end

    ##
    # Returns a string representation of this graph.
    #
    # @return [String]
    def to_s
      named? ? context.to_s : "<>"
    end

    ##
    # Returns `true` if this graph contains no RDF statements.
    #
    # @return [Boolean]
    # @see    RDF::Enumerable#empty?
    def empty?
      @data.empty?
    end

    ##
    # Returns the number of RDF statements in this graph.
    #
    # @return [Integer]
    # @see    RDF::Enumerable#count
    def count
      @data.size
    end

    ##
    # Returns `true` if this graph contains the given RDF statement.
    #
    # @param  [Statement] statement
    # @return [Boolean]
    # @see    RDF::Enumerable#has_statement?
    def has_statement?(statement)
      statement = statement.dup
      statement.context = context
      @data.include?(statement)
    end

    ##
    # Enumerates each RDF statement in this graph.
    #
    # @yield  [statement]
    # @yieldparam [Statement] statement
    # @return [Enumerator]
    # @see    RDF::Enumerable#each_statement
    def each(&block)
      @data.each(&block)
    end

    ##
    # Inserts the given RDF statement into the graph.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#insert
    def insert_statement(statement)
      statement = statement.dup
      statement.context = context
      @data.push(statement.dup) unless @data.include?(statement)
    end

    ##
    # Deletes the given RDF statement from the graph.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @see    RDF::Mutable#delete
    def delete_statement(statement)
      statement = statement.dup
      statement.context = context
      @data.delete(statement)
    end

    ##
    # Deletes all RDF statements from this graph.
    #
    # @return [void]
    # @see    RDF::Mutable#clear
    def clear_statements
      @data.clear
    end

    protected :insert_statement
    protected :delete_statement
    protected :clear_statements
  end
end
