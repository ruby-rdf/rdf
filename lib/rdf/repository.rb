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
    include RDF::Countable
    include RDF::Enumerable
    include RDF::Queryable
    include RDF::Mutable
    include RDF::Durable

    ##
    # Returns the options passed to this repository when it was constructed.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Returns the {URI} of this repository.
    #
    # @return [URI]
    attr_reader :uri
    alias_method :url, :uri

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
      send(:extend, Implementation) if self.class.equal?(RDF::Repository)

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `true` if this repository supports the given `feature`.
    #
    # @param  [Symbol, #to_sym] feature
    # @return [Boolean]
    # @since  0.1.10
    def supports?(feature)
      false
    end

    ##
    # Returns a developer-friendly representation of this object.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, uri.to_s)
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
    # Executes the given block in a transaction.
    #
    # @example
    #   repository.transaction do |tx|
    #     tx.insert [RDF::URI("http://rdf.rubyforge.org/"), RDF::DC.title, "RDF.rb"]
    #   end
    #
    # @param  [RDF::Resource] context
    # @yield  [tx]
    # @yieldparam  [RDF::Transaction] tx
    # @yieldreturn [void] ignored
    # @return [void] `self`
    # @see    RDF::Transaction
    # @since  0.3.0
    def transaction(context = nil, &block)
      tx = begin_transaction(context)
      begin
        case block.arity
          when 1 then block.call(tx)
          else tx.instance_eval(&block)
        end
      rescue => error
        rollback_transaction(tx)
        raise error
      end
      commit_transaction(tx)
      self
    end
    alias_method :transact, :transaction

  protected

    ##
    # Begins a new transaction.
    #
    # Subclasses implementing transaction-capable storage adapters may wish
    # to override this method in order to begin a transaction against the
    # underlying storage.
    #
    # @param  [RDF::Resource] context
    # @return [RDF::Transaction]
    # @since  0.3.0
    def begin_transaction(context)
      RDF::Transaction.new(:context => context)
    end

    ##
    # Rolls back the given transaction.
    #
    # Subclasses implementing transaction-capable storage adapters may wish
    # to override this method in order to roll back the given transaction in
    # the underlying storage.
    #
    # @param  [RDF::Transaction] tx
    # @return [void] ignored
    # @since  0.3.0
    def rollback_transaction(tx)
      # nothing to do
    end

    ##
    # Commits the given transaction.
    #
    # Subclasses implementing transaction-capable storage adapters may wish
    # to override this method in order to commit the given transaction to
    # the underlying storage.
    #
    # @param  [RDF::Transaction] tx
    # @return [void] ignored
    # @since  0.3.0
    def commit_transaction(tx)
      tx.execute(self)
    end

    ##
    # @see RDF::Repository
    module Implementation
      DEFAULT_CONTEXT = false

      ##
      # @private
      def self.extend_object(obj)
        obj.instance_variable_set(:@data, obj.options.delete(:data) || {})
        super
      end

      ##
      # @private
      # @see RDF::Repository#supports?
      def supports?(feature)
        case feature.to_sym
          when :context   then true   # statement contexts / named graphs
          when :inference then false  # forward-chaining inference
          else false
        end
      end

      ##
      # @private
      # @see RDF::Durable#durable?
      def durable?
        false
      end

      ##
      # @private
      # @see RDF::Countable#empty?
      def empty?
        @data.empty?
      end

      ##
      # @private
      # @see RDF::Countable#count
      def count
        count = 0
        @data.each do |c, ss|
          ss.each do |s, ps|
            ps.each do |p, os|
              count += os.size
            end
          end
        end
        count
      end

      ##
      # @private
      # @see RDF::Enumerable#has_statement?
      def has_statement?(statement)
        s, p, o, c = statement.to_quad
        c ||= DEFAULT_CONTEXT
        @data.has_key?(c) &&
          @data[c].has_key?(s) &&
          @data[c][s].has_key?(p) &&
          @data[c][s][p].include?(o)
      end

      ##
      # @private
      # @see RDF::Enumerable#each_statement
      def each_statement(&block)
        if block_given?
          # Note that to iterate in a more consistent fashion despite
          # possible concurrent mutations to `@data`, we use `#dup` to make
          # shallow copies of the nested hashes before beginning the
          # iteration over their keys and values.
          @data.dup.each do |c, ss|
            ss.dup.each do |s, ps|
              ps.dup.each do |p, os|
                os.dup.each do |o|
                  block.call(RDF::Statement.new(s, p, o, :context => c.equal?(DEFAULT_CONTEXT) ? nil : c))
                end
              end
            end
          end
        end
        enum_statement
      end
      alias_method :each, :each_statement

      ##
      # @private
      # @see RDF::Enumerable#has_context?
      def has_context?(value)
        @data.keys.include?(value)
      end

      ##
      # @private
      # @see RDF::Enumerable#each_context
      def each_context(&block)
        if block_given?
          contexts = @data.keys
          contexts.delete(DEFAULT_CONTEXT)
          contexts.each(&block)
        end
        enum_context
      end

    protected

      ##
      # @private
      # @see RDF::Queryable#query
      def query_pattern(pattern, &block)
        context   = pattern.context
        subject   = pattern.subject
        predicate = pattern.predicate
        object    = pattern.object

        cs = @data.has_key?(context) ? {context => @data[context]} : @data.dup
        cs.each do |c, ss|
          next unless context.nil? || context == c
          ss = ss.has_key?(subject) ? {subject => ss[subject]} : ss.dup
          ss.each do |s, ps|
            next unless subject.nil? || subject == s
            ps = ps.has_key?(predicate) ? {predicate => ps[predicate]} : ps.dup
            ps.each do |p, os|
              next unless predicate.nil? || predicate == p
              os = os.dup # TODO: is this really needed?
              os.each do |o|
                next unless object.nil? || object == o
                block.call(RDF::Statement.new(s, p, o, :context => c.equal?(DEFAULT_CONTEXT) ? nil : c))
              end
            end
          end
        end
      end

      ##
      # @private
      # @see RDF::Mutable#insert
      def insert_statement(statement)
        unless has_statement?(statement)
          s, p, o, c = statement.to_quad
          c ||= DEFAULT_CONTEXT
          @data[c] ||= {}
          @data[c][s] ||= {}
          @data[c][s][p] ||= []
          @data[c][s][p] << o
        end
      end

      ##
      # @private
      # @see RDF::Mutable#delete
      def delete_statement(statement)
        if has_statement?(statement)
          s, p, o, c = statement.to_quad
          c ||= DEFAULT_CONTEXT
          @data[c][s][p].delete(o)
          @data[c][s].delete(p) if @data[c][s][p].empty?
          @data[c].delete(s) if @data[c][s].empty?
          @data.delete(c) if @data[c].empty?
        end
      end

      ##
      # @private
      # @see RDF::Mutable#clear
      def clear_statements
        @data.clear
      end

      protected :query_pattern
      protected :insert_statement
      protected :delete_statement
      protected :clear_statements
    end # module Implementation
  end # class Repository
end # module RDF
