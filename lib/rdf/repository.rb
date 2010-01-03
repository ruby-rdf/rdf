module RDF
  ##
  # An RDF repository.
  #
  # @example Creating a transient in-memory repository
  #   repository = RDF::Repository.new
  #
  # @example Checking whether a repository is readable/writable
  #   repository.readable?
  #   repository.writable?
  #
  # @example Checking whether a repository is persistent or transient
  #   repository.persistent?
  #   repository.transient?
  #
  # @example Checking whether a repository is empty
  #   repository.empty?
  #
  # @example Checking how many statements a repository contains
  #   repository.count
  #
  # @example Checking whether a repository contains a specific statement
  #   repository.has_statement?(statement)
  #
  # @example Enumerating statements in a repository
  #   repository.each_statement { |statement| puts statement.inspect }
  #
  # @example Inserting statements into a repository
  #   repository.insert(*statements)
  #   repository.insert(statement)
  #   repository.insert([subject, predicate, object])
  #   repository << statement
  #   repository << [subject, predicate, object]
  #
  # @example Deleting statements from a repository
  #   repository.delete(*statements)
  #   repository.delete(statement)
  #   repository.delete([subject, predicate, object])
  #
  # @example Deleting all statements from a repository
  #   repository.clear!
  #
  class Repository
    include RDF::Enumerable

    # @return [URI]
    attr_reader :uri

    # @return [String]
    attr_reader :title

    ##
    # Loads an N-Triples file as a transient in-memory repository.
    #
    # @param  [String] filename
    # @yield  [repository]
    # @yieldparam [Repository]
    # @return [void]
    def self.load(filename, options = {}, &block)
      self.new(options) do |repository|
        repository.load(filename, options)

        if block_given?
          case block.arity
            when 1 then block.call(repository)
            else repository.instance_eval(&block)
          end
        end
      end
    end

    ##
    # @yield  [repository]
    # @yieldparam [Repository]
    def initialize(options = {}, &block)
      @uri   = options.delete(:uri)
      @title = options.delete(:title)
      @data, @options = [], options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `true` if the repository is transient.
    #
    # @return [Boolean]
    # @see    #persistent?
    def transient?
      !persistent?
    end

    ##
    # Returns `true` if the repository is persistent.
    #
    # @return [Boolean]
    # @see    #transient?
    # @abstract
    def persistent?
      false # NOTE: override this in any persistent subclasses
    end

    ##
    # Returns `true` if the repository is readable.
    #
    # @return [Boolean]
    def readable?
      true
    end

    ##
    # Returns `true` if the repository is mutable.
    #
    # @return [Boolean]
    # @see    #immutable?
    # @see    #immutable!
    def mutable?
      !immutable?
    end

    alias_method :writable?, :mutable?

    ##
    # Returns `true` if the repository is immutable.
    #
    # @return [Boolean]
    # @see    #mutable?
    # @see    #immutable!
    def immutable?
      @options[:mutable] == false
    end

    ##
    # Makes the repository contents immutable.
    #
    # @return [void]
    # @see    #mutable?
    # @see    #immutable?
    def immutable!
      @options[:mutable] = true
    end

    ##
    # Returns `true` if the repository contains no RDF statements.
    #
    # @return [Boolean]
    def empty?
      @data.empty?
    end

    ##
    # Returns the number of RDF statements in the repository.
    #
    # @return [Integer]
    def size
      @data.size
    end

    alias_method :count, :size

    ##
    # Returns `true` if this repository contains the given RDF `statement`.
    #
    # @param  [Statement] statement
    # @return [Boolean]
    def has_statement?(statement)
      @data.include?(statement)
    end

    alias_method :include?, :has_statement?

    ##
    # Enumerates each RDF statement in the repository.
    #
    # @yield [statement]
    # @yieldparam [Statement]
    # @return [Repository]
    def each_statement(&block)
      @data.each(&block)
      self
    end

    alias_method :each, :each_statement

    ##
    # Queries the repository for RDF statements matching the given pattern.
    #
    # @param  [Query, Statement, Array(Value)] pattern
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Array<Statement>, nil]
    def query(pattern, &block)
      raise TypeError.new("repository is not readable") unless readable?
      case pattern
        when Query
          pattern.execute(self, &block)
        when Array
          query(Statement.new(*pattern), &block)
        when Statement
          if block_given?
            # TODO: yield any found statements
            nil
          else
            find_all { |statement| pattern === statement }
          end
      end
    end

    ##
    # Loads RDF statements from the given N-Triples file into the repository.
    #
    # @param  [String]  filename
    # @return [Integer] the number of inserted RDF statements
    def load(filename, options = {})
      raise TypeError.new("repository is immutable") if immutable?
      count = 0
      Reader.open(filename, options) do |reader|
        reader.each_statement do |statement|
          insert_statement(statement)
          count += 1
        end
      end
      count
    end

    ##
    # Inserts an RDF statement into the repository.
    #
    # @param  [Statement, Array(Value), #to_a] statement
    # @return [Repository]
    def <<(statement)
      raise TypeError.new("repository is immutable") if immutable?
      case statement
        when Statement then insert_statement(statement)
        else insert_statement(Statement.new(*statement.to_a))
      end
      self
    end

    ##
    # Inserts RDF statements into the repository.
    #
    # @param  [Array<Statement>] statements
    # @raise  [TypeError] if the repository is immutable
    # @return [Repository]
    def insert(*statements)
      raise TypeError.new("repository is immutable") if immutable?
      statements.each do |statement|
        insert_statement(statement)
      end
      self
    end

    ##
    # Deletes RDF statements from the repository.
    #
    # @param  [Array<Statement>] statements
    # @raise  [TypeError] if the repository is immutable
    # @return [Repository]
    def delete(*statements)
      raise TypeError.new("repository is immutable") if immutable?
      statements.each do |statement|
        delete_statement(statement)
      end
      self
    end

    ##
    # Deletes all RDF statements from this repository.
    #
    # @return [Repository]
    def clear
      @data.clear
      self
    end

    alias_method :clear!, :clear

    protected

      def insert_statement(statement)
        @data.push(statement) unless @data.include?(statement)
      end

      def delete_statement(statement)
        @data.delete(statement)
      end

  end
end
