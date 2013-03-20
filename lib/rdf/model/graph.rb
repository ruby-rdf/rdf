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
  class Graph
    include RDF::Resource

    include RDF::Countable
    include RDF::Durable
    include RDF::Enumerable
    include RDF::Queryable
    include RDF::Mutable

    ##
    # Returns the options passed to this graph when it was constructed.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # @return [RDF::Resource]
    # @note In the next release, only projections from an
    # {RDF::Enumerable} supporting contexts will have a context.
    attr_accessor :context

    ##
    # @return [RDF::Queryable]
    attr_accessor :data

    ##
    # Creates a new `Graph` instance populated by the RDF data returned by
    # dereferencing the given context URL.
    #
    # @param  [String, #to_s]          url
    # @param  [Hash{Symbol => Object}] options
    #   Options from {RDF::Reader#initialize}, {RDF::Format.for} and {RDF::Graph#initialize}
    # @yield  [graph]
    # @yieldparam [Graph] graph
    # @return [Graph]
    # @since  0.1.7
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
    # @overload initialize(context, options)
    #   @param  [RDF::Resource]          context
    #     The context only provides a context for loading relative documents
    #   @param  [Hash{Symbol => Object}] options
    #   @note contexts are only useful when used as a projection
    #   on a `:data` which supports contexts. Otherwise, there is no
    #   such thing as a named graph in RDF 1.1, a repository may have
    #   graphs which are named, but the name is not a property of the graph.
    # @overload initialize(options)
    #   @param  [Hash{Symbol => Object}] options
    # @yield  [graph]
    # @yieldparam [Graph]
    # @note Currently, context makes this a named garph;
    # in the next release it will not
    def initialize(*args, &block)
      context = args.shift unless args.first.is_a?(Hash)
      options = args.first || {}
      @context = case context
        when nil then nil
        when RDF::Resource then context
        else RDF::URI.new(context)
      end

      @options = options.dup
      @data    = @options.delete(:data) || RDF::Repository.new

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # @return [void]
    # @note The next release, graphs will not be named
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
    # @note The next release, graphs will not be named, this will return false
    def named?
      !unnamed?
    end

    ##
    # Returns `true` if this is a unnamed graph.
    #
    # @return [Boolean]
    # @note The next release, graphs will not be named, this will return true
    def unnamed?
      context.nil?
    end

    ##
    # Returns `false` to indicate that this graph is not durable
    #
    # @return [Boolean]
    # @see    RDF::Durable#durable?
    def durable?
      false
    end

    ##
    # Returns all unique RDF contexts for this graph.
    #
    # @return [Enumerator<RDF::Resource>]
    def contexts(options = {})
      (named? ? [context] : []).to_enum.extend(RDF::Countable)
    end

    ##
    # Returns the URI representation of this graph.
    #
    # @return [RDF::URI]
    # @note The next release, graphs will not be named, this will return nil
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
    # Returns `true` if this graph has an anonymous context, `false` otherwise.
    #
    # @return [Boolean]
    # @note The next release, graphs will not be named, this will return true
    def anonymous?
      context.nil? ? false : context.anonymous?
    end

    ##
    # Returns the number of RDF statements in this graph.
    #
    # @return [Integer]
    # @see    RDF::Enumerable#count
    def count
      @data.query(:context => context).count
    end

    ##
    # Returns `true` if this graph contains the given RDF statement.
    #
    # @param  [Statement] statement
    # @return [Boolean]
    # @see    RDF::Enumerable#has_statement?
    def has_statement?(statement)
      statement = statement.dup
      statement.context = context # TODO: going away
      @data.has_statement?(statement)
    end

    ##
    # Enumerates each RDF statement in this graph.
    #
    # @yield  [statement]
    # @yieldparam [Statement] statement
    # @return [Enumerator]
    # @see    RDF::Enumerable#each_statement
    def each(&block)
      @data.query(:context => context).each(&block)
    end

    ##
    # @private
    # @see RDF::Queryable#query
    def query_pattern(pattern, &block)
      pattern = pattern.dup
      pattern.context = context
      @data.query(pattern, &block)
    end

    ##
    # @private
    # @see RDF::Mutable#insert
    def insert_statement(statement)
      statement = statement.dup
      statement.context = context
      @data.insert(statement)
    end

    ##
    # @private
    # @see RDF::Mutable#delete
    def delete_statement(statement)
      statement = statement.dup
      statement.context = context
      @data.delete(statement)
    end

    ##
    # @private
    # @see RDF::Mutable#clear
    def clear_statements
      @data.delete(:context => context)
    end

    protected :query_pattern
    protected :insert_statement
    protected :delete_statement
    protected :clear_statements

    ##
    # @private
    # @see    RDF::Enumerable#graphs
    # @since  0.2.0
    def graphs
      enum_graph
    end

    ##
    # @private
    # @see    RDF::Enumerable#each_graph
    # @since  0.2.0
    def each_graph(&block)
      block_given? ? block.call(self) : enum_graph
    end
  end
end
