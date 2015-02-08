module RDF
  ##
  # An RDF graph.
  #
  # An {RDF::Graph} contains a unique set of {RDF::Statement}. It is
  # based on an underlying data object, which may be specified when the
  # graph is initialized, and will default to a {RDF::Repository} without
  # support for contexts otherwise.
  #
  # Note that in RDF 1.1, graphs are not named, but are associated with
  # a name in the context of a Dataset, as a pair of <name, graph>.
  # This class allows a name to be associated with a graph when it is
  # a projection of an underlying {RDF::Repository} supporting contexts.
  #
  # @example Creating an empty unnamed graph
  #   graph = RDF::Graph.new
  #
  # @example Loading graph data from a URL
  #   graph = RDF::Graph.load("http://ruby-rdf.github.io/rdf/etc/doap.nt")
  #
  # @example Loading graph data from a URL
  #   require 'rdf/rdfxml'  # for RDF/XML support
  #   
  #   graph = RDF::Graph.load("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
  #
  # @example Accessing a specific named graph within a {RDF::Repository}
  #   require 'rdf/trig'  # for TriG support
  #
  #   repository = graph = RDF::Repository.load("https://raw.githubusercontent.com/ruby-rdf/rdf-trig/develop/etc/doap.trig", format: :trig))
  #   graph = RDF::Graph.new(data: repository, context: RDF::URI("http://greggkellogg.net/foaf#me"))
  class Graph
    include RDF::Value
    include RDF::Countable
    include RDF::Durable
    include RDF::Enumerable
    include RDF::Queryable
    include RDF::Mutable

    ##
    # Returns the options passed to this graph when it was constructed.
    #
    # @!attribute [r] options
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Name of this graph, if it is part of an {RDF::Repository}
    # @!attribute [rw] context
    # @return [RDF::Resource]
    # @since 1.1.0
    attr_accessor :context

    alias_method :name, :context
    alias_method :name=, :context=

    ##
    # {RDF::Queryable} backing this graph.
    # @!attribute [rw] data
    # @return [RDF::Queryable]
    attr_accessor :data

    ##
    # Creates a new `Graph` instance populated by the RDF data returned by
    # dereferencing the given context URL.
    #
    # @param  [String, #to_s]          url
    # @param  [Hash{Symbol => Object}] options
    #   Options from {RDF::Graph#initialize} and {RDF::Mutable#load}
    # @yield  [graph]
    # @yieldparam [Graph] graph
    # @return [Graph]
    # @since  0.1.7
    def self.load(url, options = {}, &block)
      self.new(options) do |graph|
        graph.load(url, options)

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
    #     The context from the associated {RDF::Queryable} associated
    #     with this graph as provided with the `:data` option
    #     (only for {RDF::Queryable} instances supporting
    #     named contexts).
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Queryable] :data (RDF::Repository.new)
    #     Storage behind this graph.
    #   @raise [ArgumentError] if a `data` does not support contexts.
    #   @note
    #     Contexts are only useful when used as a projection
    #     on a `:data` which supports contexts. Otherwise, there is no
    #     such thing as a named graph in RDF 1.1, a repository may have
    #     graphs which are named, but the name is not a property of the graph.
    # @overload initialize(options)
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [RDF::Queryable] :data (RDF::Repository.new)
    #     Storage behind this graph.
    # @yield  [graph]
    # @yieldparam [Graph]
    def initialize(*args, &block)
      context = args.shift unless args.first.is_a?(Hash)
      options = args.first || {}
      @context = case context
        when nil then nil
        when RDF::Resource then context
        else RDF::URI.new(context)
      end

      @options = options.dup
      @data    = @options.delete(:data) || RDF::Repository.new(:with_context => false)

      raise ArgumentError, "Can't apply context unless initialized with `data` supporting contexts" if
        @context && !@data.supports?(:context)

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # (re)loads the graph from the specified location, or from the location associated with the graph context, if any
    # @return [void]
    # @see    RDF::Mutable#load
    def load!(*args)
      case
        when args.empty?
          raise ArgumentError, "Can't reload graph with no context" unless context.is_a?(RDF::URI)
          load(context.to_s, {:base_uri => context}.merge(@options))
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
    # A graph is durable if it's underlying data model is durable
    #
    # @return [Boolean]
    # @see    RDF::Durable#durable?
    def durable?
      @data.durable?
    end

    ##
    # Returns all unique RDF contexts for this graph.
    #
    # @return [Enumerator<RDF::Resource>]
    def contexts(options = {})
      (named? ? [context] : []).to_enum.extend(RDF::Countable)
    end

    ##
    # Returns the {RDF::Resource} representation of this graph.
    #
    # @return [RDF::Resource]
    def to_uri
      context
    end

    ##
    # Returns a string representation of this graph.
    #
    # @return [String]
    def to_s
      named? ? context.to_s : "default"
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
      @data.query(:context => context || false).count
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
      if @data.respond_to?(:query)
        @data.query(:context => context || false, &block)
      elsif @data.respond_to?(:each)
        @data.each(&block)
      else
        @data.to_a.each(&block)
      end
    end

    ##
    # Graph equivalence based on the contents of each graph being _exactly_
    # the same. To determine if the have the same _meaning_, consider
    # [rdf-isomorphic](http://rubygems.org/gems/rdf-isomorphic).
    #
    # @param [RDF::Graph] other
    # @return [Boolean]
    # @see http://rubygems.org/gems/rdf-isomorphic
    def ==(other)
      other.is_a?(RDF::Graph) &&
      context == other.context &&
      statements.to_a == other.statements.to_a
    end

    ##
    # @private
    # @see RDF::Queryable#query
    def query_pattern(pattern, &block)
      pattern = pattern.dup
      pattern.context = context || false
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
      @data.delete(:context => context || false)
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
