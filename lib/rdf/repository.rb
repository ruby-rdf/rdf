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
  #   repository.each_statement { |statement| statement.inspect! }
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
    include RDF::Durable
    include RDF::Mutable
    include RDF::Queryable

    ##
    # Returns the {URI} of this repository.
    #
    # @return [URI]
    attr_reader :uri

    ##
    # Returns the title of this repository.
    #
    # @return [String]
    attr_reader :title

    ##
    # Loads one or more RDF files into a new transient in-memory repository.
    #
    # @param  [String, Array<String>] filenames
    # @yield  [repository]
    # @yieldparam [Repository]
    # @return [void]
    def self.load(filenames, options = {}, &block)
      self.new(options) do |repository|
        [filenames].flatten.each do |filename|
          repository.load(filename, options)
        end

        if block_given?
          case block.arity
            when 1 then block.call(repository)
            else repository.instance_eval(&block)
          end
        end
      end
    end

    ##
    # Initializes this repository instance.
    #
    # @param  [Hash{Symbol => Object}] options
    # @option options [URI, #to_s]    :uri (nil)
    # @option options [String, #to_s] :title (nil)
    # @yield  [repository]
    # @yieldparam [Repository] repository
    def initialize(options = {}, &block)
      @options = options.dup
      @uri     = @options.delete(:uri)
      @title   = @options.delete(:title)

      # Provide a default in-memory implementation:
      if self.class.equal?(RDF::Repository)
        @data = []
        send(:extend, Implementation)
      end

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns a developer-friendly representation of this object.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, uri.to_s)
    end

    ##
    # Outputs a developer-friendly representation of this object to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      each_statement { |statement| statement.inspect! }
      nil
    end

    ##
    # @see RDF::Repository
    module Implementation
      ##
      # Returns `false` to indicate that this repository is nondurable.
      #
      # @return [Boolean]
      # @see    RDF::Durable#durable?
      def durable?
        false
      end

      ##
      # Returns `true` if this repository contains no RDF statements.
      #
      # @return [Boolean]
      # @see    RDF::Enumerable#empty?
      def empty?
        @data.empty?
      end

      ##
      # Returns the number of RDF statements in this repository.
      #
      # @return [Integer]
      # @see    RDF::Enumerable#count
      def count
        @data.size
      end

      ##
      # Returns `true` if this repository contains the given RDF statement.
      #
      # @param  [Statement] statement
      # @return [Boolean]
      # @see    RDF::Enumerable#has_statement?
      def has_statement?(statement)
        @data.include?(statement)
      end

      ##
      # Enumerates each RDF statement in this repository.
      #
      # @yield  [statement]
      # @yieldparam [Statement] statement
      # @return [Enumerator]
      # @see    RDF::Enumerable#each_statement
      def each(&block)
        @data.each(&block)
      end

      ##
      # Inserts the given RDF statement into the underlying storage.
      #
      # @param  [RDF::Statement] statement
      # @return [void]
      def insert_statement(statement)
        @data.push(statement.dup) unless @data.include?(statement)
      end

      ##
      # Deletes the given RDF statement from the underlying storage.
      #
      # @param  [RDF::Statement] statement
      # @return [void]
      def delete_statement(statement)
        @data.delete(statement)
      end

      ##
      # Deletes all RDF statements from this repository.
      #
      # @return [void]
      # @see    RDF::Mutable#clear
      def clear_statements
        @data.clear
      end

      protected :insert_statement
      protected :delete_statement
      protected :clear_statements
    end # module Implementation
  end # class Repository
end # module RDF
