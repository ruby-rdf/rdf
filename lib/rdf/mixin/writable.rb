module RDF
  ##
  module Writable
    extend RDF::Util::Aliasing::LateBound

    ##
    # Returns `true` if `self` is writable.
    #
    # @return [Boolean]
    # @see    RDF::Readable#readable?
    def writable?
      true
    end

    ##
    # Inserts RDF data into `self`.
    #
    # @param  [RDF::Enumerable, RDF::Statement] statement
    # @return [Writable]
    def <<(statement)
      insert_statement(create_statement(statement)) # FIXME

      return self
    end

    ##
    # Inserts RDF statements into `self`.
    #
    # @param  [Array<RDF::Statement>] statements
    # @return [Writable]
    def insert(*statements)
      statements.map! do |value|
        case
          when value.respond_to?(:each_statement)
            insert_statements(value)
            nil
          when (statement = create_statement(value)).valid?
            statement
          else
            raise ArgumentError.new("not a valid statement: #{value.inspect}")
        end
      end
      statements.compact!
      insert_statements(statements) unless statements.empty?

      return self
    end

    alias_method :insert!, :insert

  protected

    ##
    # Inserts the given RDF statements into the underlying storage or output
    # stream.
    #
    # Defaults to invoking {#insert_statement} for each given statement.
    #
    # Subclasses of {RDF::Repository} may override this method if they are
    # capable of more efficiently inserting multiple statements at once.
    #
    # Subclasses of {RDF::Writer} don't generally need to implement this
    # method.
    #
    # @param  [RDF::Enumerable] statements
    # @return [void]
    def insert_statements(statements)
      each = statements.respond_to?(:each_statement) ? :each_statement : :each
      statements.__send__(each) do |statement|
        insert_statement(statement)
      end
    end

    ##
    # Inserts an RDF statement into the underlying storage or output stream.
    #
    # Subclasses of {RDF::Repository} must implement this method (except in
    # case they are immutable).
    #
    # Subclasses of {RDF::Writer} must implement this method.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @abstract
    def insert_statement(statement)
      raise NotImplementedError.new("#{self.class}#insert_statement")
    end

    ##
    # Transforms various input into an `RDF::Statement` instance.
    #
    # @param  [RDF::Statement, Hash, Array, #to_a] statement
    # @return [RDF::Statement]
    def create_statement(statement)
      # TODO: move this to RDF::Statement.construct or the like.
      case statement
        when Statement then statement
        when Hash      then Statement.new(statement)
        when Array     then Statement.new(*statement)
        else raise ArgumentError.new # FIXME
      end
    end

    protected :insert_statements
    protected :insert_statement
    protected :create_statement
  end
end
