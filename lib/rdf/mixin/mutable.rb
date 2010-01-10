module RDF
  ##
  # Classes that include this module must implement the methods
  # {#insert_statement}, {#delete_statement} and {#each_statement}.
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
    # Loads RDF statements from the given file into `self`.
    #
    # @param  [String, #to_s]          filename
    # @param  [Hash{Symbol => Object}] options
    # @return [Integer] the number of inserted RDF statements
    def load(filename, options = {})
      raise TypeError.new("#{self} is immutable") if immutable?

      count = 0
      Reader.open(filename, options) do |reader|
        reader.each_statement do |statement|
          insert_statement(statement)
          count += 1
        end
      end
      count
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
      self
    end

    ##
    # Inserts RDF statements into `self`.
    #
    # @param  [Enumerable<RDF::Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def insert(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

      statements.each do |statement|
        if (statement = create_statement(statement)).valid?
          insert_statement(statement)
        else
          raise ArgumentError.new # FIXME
        end
      end
      self
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

      statements.each do |statement|
        if (statement = create_statement(statement)).valid?
          delete_statement(statement)
        else
          query(statement) do |statement|
            delete_statement(statement)
          end
        end
      end
      self
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
      each_statement do |statement|
        delete_statement(statement)
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

    protected :create_statement

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

    protected :insert_statement, :delete_statement
  end
end
