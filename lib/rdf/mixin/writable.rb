module RDF
  ##
  # Classes that include this module must implement the methods
  # `#insert_statement`.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Writable
    extend RDF::Util::Aliasing::LateBound
    include RDF::Util::Coercions

    ##
    # Returns `true` if `self` is writable.
    #
    # @return [Boolean] `true` or `false`
    # @see    RDF::Readable#readable?
    def writable?
      !frozen?
    end

    ##
    # Inserts RDF data into `self`.
    #
    # @param  [RDF::Enumerable, RDF::Statement, #to_rdf] data
    # @return [self]
    def <<(data)
      case data
        when RDF::Reader
          insert_reader(data)
        when RDF::Graph
          insert_graph(data)
        when RDF::Enumerable
          insert_statements(data)
        when RDF::Statement
          insert_statement(data)
        else case
          when data.respond_to?(:to_rdf) && !data.equal?(rdf = data.to_rdf)
            self << rdf
          else
            insert_statement(Statement.from(data))
        end
      end

      return self
    end

    ##
    # Inserts RDF statements into `self`.
    #
    # @note using splat argument syntax with excessive arguments provided
    # significantly affects performance. Use Enumerator form for large
    # numbers of statements.
    #
    # @overload insert(*statements)
    #   @param  [Array<RDF::Statement>] statements
    #   @return [self]
    #   @raise [ArgumentError] on an attempt to insert an embedded statement when it is not supported
    #
    # @overload insert(statements)
    #   @param  [Enumerable<RDF::Statement>] statements
    #   @return [self]
    #   @raise [ArgumentError] on an attempt to insert an embedded statement when it is not supported
    def insert(*statements)
      coerce_statements(statements) { |value| insert_statements value }

      return self
    end
    alias_method :insert!, :insert

  protected
    ##
    # Inserts statements from the given RDF reader into the underlying
    # storage or output stream.
    #
    # Defaults to passing the reader to the {RDF::Writable#insert_statements} method.
    #
    # Subclasses of {RDF::Repository} may wish to override this method in
    # case their underlying storage can efficiently import RDF data directly
    # in particular serialization formats, thus avoiding the intermediate
    # parsing overhead.
    #
    # @param  [RDF::Reader] reader
    # @return [void]
    # @since  0.2.3
    def insert_reader(reader)
      insert_statements(reader)
    end

    ##
    # Inserts the given RDF graph into the underlying storage or output
    # stream.
    #
    # Defaults to passing the graph to the {RDF::Writable#insert_statements} method.
    #
    # Subclasses of {RDF::Repository} may wish to override this method in
    # case their underlying storage architecture is graph-centric rather
    # than statement-oriented.
    #
    # Subclasses of {RDF::Writer} may wish to override this method if the
    # output format they implement supports named graphs, in which case
    # implementing this method may help in producing prettier and more
    # concise output.
    #
    # @param  [RDF::Graph] graph
    # @return [void]
    def insert_graph(graph)
      insert_statements(graph)
    end

    ##
    # Inserts the given RDF statements into the underlying storage or output
    # stream.
    #
    # Defaults to invoking {RDF::Writable#insert_statement} for each given statement.
    #
    # Subclasses of {RDF::Repository} may wish to override this method if
    # they are capable of more efficiently inserting multiple statements at
    # once.
    #
    # Subclasses of {RDF::Writer} don't generally need to implement this
    # method.
    #
    # @param  [RDF::Enumerable] statements
    # @return [void]
    # @raise [ArgumentError] on an attempt to insert an embedded statement when it is not supported
    # @since  0.1.6
    def insert_statements(statements)
      each = statements.respond_to?(:each_statement) ? :each_statement : :each
      statements.__send__(each) do |statement|
        if statement.embedded? && respond_to?(:supports?) && !supports?(:rdf_full)
          raise ArgumentError, "Writable does not support triple terms"
        end
        if statement.object && statement.object.literal? && statement.object.direction? && respond_to?(:supports?) && !supports?(:base_direction)
          raise ArgumentError, "Writable does not support directional languaged-tagged strings"
        end
        insert_statement(statement)
      end
    end

    ##
    # Inserts an RDF statement into the underlying storage or output stream.
    #
    # Subclasses of {RDF::Repository} must implement this method, except if
    # they are immutable.
    #
    # Subclasses of {RDF::Writer} must implement this method.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @raise [ArgumentError] on an attempt to insert an embedded statement when it is not supported
    # @abstract
    def insert_statement(statement)
      raise NotImplementedError.new("#{self.class}#insert_statement")
    end

    protected :insert_statements
    protected :insert_statement
  end # Writable
end # RDF
