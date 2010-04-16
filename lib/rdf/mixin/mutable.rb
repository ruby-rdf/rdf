module RDF
  ##
  # Classes that include this module must implement the methods
  # `#insert_statement`, `#delete_statement` and `#each_statement`.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Mutable
    include RDF::Readable
    include RDF::Writable

    ##
    # Returns `true` if `self` is mutable.
    #
    # @return [Boolean]
    # @see    #immutable?
    def mutable?
      writable?
    end

    ##
    # Returns `true` if `self` is immutable.
    #
    # @return [Boolean]
    # @see    #mutable?
    def immutable?
      !mutable?
    end

    ##
    # Loads RDF statements from the given file or URL into `self`.
    #
    # @param  [String, #to_s]          filename
    # @param  [Hash{Symbol => Object}] options
    # @return [Integer] the number of inserted RDF statements
    def load(filename, options = {})
      raise TypeError.new("#{self} is immutable") if immutable?

      Reader.open(filename, options) do |reader|
        if options[:context]
          statements = []
          reader.each_statement do |statement|
            statement.context = options[:context]
            statements << statement
          end
          insert_statements(statements)
          statements.size
        else
          insert_statements(reader)
          nil # FIXME
        end
      end
    end

    alias_method :load!, :load

    ##
    # Inserts an RDF statement into `self`.
    #
    # @param  [RDF::Statement, Array<RDF::Value>, #to_a] statement
    # @return [Mutable]
    def <<(statement)
      raise TypeError.new("#{self} is immutable") if immutable?

      insert_statement(create_statement(statement))

      return self
    end

    ##
    # Inserts RDF statements into `self`.
    #
    # @param  [Enumerable<RDF::Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def insert(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

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

    ##
    # Deletes RDF statements from `self`.
    #
    # @param  [Enumerable<Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def delete(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

      statements.map! do |value|
        case
          when value.respond_to?(:each_statement)
            delete_statements(value)
            nil
          when (statement = create_statement(value)).valid?
            statement
          else
            delete_statements(query(value))
            nil
        end
      end
      statements.compact!
      delete_statements(statements) unless statements.empty?

      return self
    end

    alias_method :delete!, :delete

    ##
    # Updates RDF statements in `self`.
    #
    # `#update([subject, predicate, object])` is equivalent to
    # `#delete([subject, predicate, nil])` followed by
    # `#insert([subject, predicate, object])` unless `object` is `nil`.
    #
    # @param  [Enumerable<RDF::Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def update(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

      statements.each do |statement|
        if (statement = create_statement(statement))
          delete([statement.subject, statement.predicate, nil])
          insert(statement) if statement.has_object?
        end
      end
    end

    alias_method :update!, :update

    ##
    # Deletes all RDF statements from `self`.
    #
    # @return [Mutable]
    def clear
      raise TypeError.new("#{self} is immutable") if immutable?

      if respond_to?(:clear_statements)
        clear_statements
      else
        each_statement do |statement|
          delete_statement(statement)
        end
      end
      self
    end

    alias_method :clear!, :clear

    ##
    # Transforms various input into an `RDF::Statement` instance.
    #
    # @param  [RDF::Statement, Hash, Array, #to_a] statement
    # @return [RDF::Statement]
    def create_statement(statement)
      case statement
        when Statement then statement
        when Hash      then Statement.new(statement)
        when Array     then Statement.new(*statement)
        else raise ArgumentError.new # FIXME
      end
    end

    ##
    # Inserts an RDF statement into the underlying storage.
    #
    # Subclasses of {RDF::Repository} must implement this method (except in
    # case they are immutable).
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @abstract
    def insert_statement(statement)
      raise NotImplementedError
    end

    ##
    # Inserts a list of RDF statement into the underlying storage.
    #
    # Subclasses of {RDF::Repository} may implement this method if they can
    # efficiently insert multiple statements at once. This will otherwise
    # default to invoking {#insert_statement} for each given statement.
    #
    # @param  [RDF::Enumerable, #each] statements
    # @return [void]
    def insert_statements(statements)
      each = statements.respond_to?(:each_statement) ? :each_statement : :each
      statements.__send__(each) do |statement|
        insert_statement(statement)
      end
    end

    ##
    # Deletes an RDF statement from the underlying storage.
    #
    # Subclasses of {RDF::Repository} must implement this method (except in
    # case they are immutable).
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @abstract
    def delete_statement(statement)
      raise NotImplementedError
    end

    ##
    # Deletes a list of RDF statement from the underlying storage.
    #
    # Subclasses of {RDF::Repository} may implement this method if they can
    # efficiently delete multiple statements at once. This will otherwise
    # default to invoking {#delete_statement} for each given statement.
    #
    # @param  [RDF::Enumerable, #each] statements
    # @return [void]
    def delete_statements(statements)
      each = statements.respond_to?(:each_statement) ? :each_statement : :each
      statements.__send__(each) do |statement|
        delete_statement(statement)
      end
    end

    protected :create_statement
    protected :insert_statement
    protected :insert_statements
    protected :delete_statement
    protected :delete_statements
  end
end
