module RDF
  ##
  # Classes that include this module must implement the methods
  # `#insert_statement`, `#delete_statement` and `#each_statement`.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Mutable
    extend  RDF::Util::Aliasing::LateBound
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
    # @return [void]
    def load(filename, options = {})
      raise TypeError.new("#{self} is immutable") if immutable?

      Reader.open(filename, {:base_uri => filename}.merge(options)) do |reader|
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
          nil
        end
      end
    end

    alias_method :load!, :load

    ##
    # Inserts RDF data into `self`.
    #
    # @param  [RDF::Enumerable, RDF::Statement, #to_rdf] data
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    # @see    RDF::Writable#<<
    def <<(data)
      raise TypeError.new("#{self} is immutable") if immutable?

      super # RDF::Writable#<<
    end

    ##
    # Inserts RDF statements into `self`.
    #
    # @param  [Array<RDF::Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    # @see    RDF::Writable#insert
    def insert(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

      super # RDF::Writable#insert
    end

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
        if (statement = Statement.from(statement))
          delete([statement.subject, statement.predicate, nil])
          insert(statement) if statement.has_object?
        end
      end
    end

    alias_method :update!, :update

    ##
    # Deletes RDF statements from `self`.
    #
    # @param  [Enumerable<RDF::Statement>] statements
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def delete(*statements)
      raise TypeError.new("#{self} is immutable") if immutable?

      statements.map! do |value|
        case
          when value.respond_to?(:each_statement)
            delete_statements(value)
            nil
          when (statement = Statement.from(value)).valid?
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
    # Deletes all RDF statements from `self`.
    #
    # @raise  [TypeError] if `self` is immutable
    # @return [Mutable]
    def clear
      raise TypeError.new("#{self} is immutable") if immutable?

      if respond_to?(:clear_statements)
        clear_statements
      else
        delete_statements(self)
      end

      return self
    end

    alias_method :clear!, :clear

  protected

    ##
    # Deletes the given RDF statements from the underlying storage.
    #
    # Defaults to invoking {#delete_statement} for each given statement.
    #
    # Subclasses of {RDF::Repository} may wish to override this method if
    # they are capable of more efficiently deleting multiple statements at
    # once.
    #
    # @param  [RDF::Enumerable] statements
    # @return [void]
    def delete_statements(statements)
      each = statements.respond_to?(:each_statement) ? :each_statement : :each
      statements.__send__(each) do |statement|
        delete_statement(statement)
      end
    end

    ##
    # Deletes an RDF statement from the underlying storage.
    #
    # Subclasses of {RDF::Repository} must implement this method, except if
    # they are immutable.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    # @abstract
    def delete_statement(statement)
      raise NotImplementedError.new("#{self.class}#delete_statement")
    end

    protected :delete_statements
    protected :delete_statement
  end
end
