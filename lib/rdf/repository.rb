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
    include RDF::Mutable
    include RDF::Durable
    include RDF::Queryable

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
    # @param  [String, Array<String>] urls
    # @param  [Hash{Symbol => Object}] options
    #   Options from {RDF::Repository#initialize} and {RDF::Mutable#load}
    # @yield  [repository]
    # @yieldparam [Repository]
    # @return [void]
    def self.load(urls, options = {}, &block)
      self.new(options) do |repository|
        Array(urls).each do |url|
          repository.load(url, options)
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
    # @param [URI, #to_s]    uri (nil)
    # @param [String, #to_s] title (nil)
    # @param [Hash{Symbol => Object}] options
    # @option options [Boolean]       :with_graph_name (true)
    #   Indicates that the repository supports named graphs, otherwise,
    #   only the default graph is supported.
    # @option options [Boolean]       :with_validity (true)
    #   Indicates that the repository supports named validation.
    # @yield  [repository]
    # @yieldparam [Repository] repository
    def initialize(url: nil, title: nil, **options, &block)
      if options[:with_context]
        raise ArgumentError, "The :contexts option to Repository#initialize is deprecated in RDF.rb 2.0, use :graph_name instead. Called from #{Gem.location_of_caller.join(':')}" if RDF::VERSION.to_s >= '2.0'
        warn "[DEPRECATION] the :contexts option to Repository#initialize is deprecated in RDF.rb 2.0, use :graph_name instead. Called from #{Gem.location_of_caller.join(':')}"
        options[:graph_name] ||= options.delete(:with_context)
      end
      @options = {with_graph_name: true, with_validity: true}.merge(options)
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
    # @private
    # @see RDF::Enumerable#project_graph
    def project_graph(graph_name, &block)
      RDF::Graph.new(graph_name: graph_name, data: self).
        project_graph(graph_name, &block)
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
    #     tx.insert [RDF::URI("http://rubygems.org/gems/rdf"), RDF::RDFS.label, "RDF.rb"]
    #   end
    #
    # @param  [RDF::Resource] graph_name
    #   Context on which to run the transaction, use `false` for the default
    #   graph_name and `nil` the entire Repository
    # @yield  [tx]
    # @yieldparam  [RDF::Transaction] tx
    # @yieldreturn [void] ignored
    # @return [self]
    # @see    RDF::Transaction
    # @since  0.3.0
    def transaction(graph_name = nil, &block)
      tx = begin_transaction(graph_name)
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
    # @param  [RDF::Resource] graph_name
    # @return [RDF::Transaction]
    # @since  0.3.0
    def begin_transaction(graph_name)
      RDF::Transaction.new(graph: graph_name)
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
      DEFAULT_GRAPH = false

      ##
      # @private
      def self.extend_object(obj)
        obj.instance_variable_set(:@data, obj.options.delete(:data) || {})
        super
      end

      ##
      # @private
      # @see RDF::Enumerable#supports?
      def supports?(feature)
        case feature.to_sym
          #statement named graphs
          when :context
            raise ArgumentError, "The :contexts feature is deprecated in RDF.rb 2.0, use :graph_name instead. Called from #{Gem.location_of_caller.join(':')}" if RDF::VERSION.to_s >= '2.0'
            warn "[DEPRECATION] the :context feature is deprecated in RDF.rb 2.0; use :graph_name instead. Called from #{Gem.location_of_caller.join(':')}"
            @options[:with_context] || @options[:with_graph_name]
          when :graph_name   then @options[:with_graph_name]
          when :inference then false  # forward-chaining inference
          when :validity  then @options.fetch(:with_validity, true)
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
      # @see RDF::Countable#count
      def count
        count = 0
        @data.each do |g, ss|
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
        s, p, o, g = statement.to_quad
        g ||= DEFAULT_GRAPH
        @data.has_key?(g) &&
          @data[g].has_key?(s) &&
          @data[g][s].has_key?(p) &&
          @data[g][s][p].include?(o)
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
          @data.dup.each do |g, ss|
            ss.dup.each do |s, ps|
              ps.dup.each do |p, os|
                os.dup.each do |o|
                  # FIXME: yield has better performance, but broken in MRI 2.2: See https://bugs.ruby-lang.org/issues/11451.
                  block.call(RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: g.equal?(DEFAULT_GRAPH) ? nil : g))
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
      # @deprecated Use {#has_graph?} instead.
      def has_context?(value)
        raise NoMethodError, "Repository#has_context? is deprecated in RDF.rb 2.0, use Repository#has_graph? instead. Called from #{Gem.location_of_caller.join(':')}" if RDF::VERSION.to_s >= '2.0'
       warn "[DEPRECATION] Repository#has_context? is deprecated in RDF.rb 2.0, use Repository#has_graph? instead. Called from #{Gem.location_of_caller.join(':')}"
       has_graph?(value)
      end

      ##
      # @private
      # @see RDF::Enumerable#has_graph?
      def has_graph?(value)
        @data.keys.include?(value)
      end

      ##
      # @private
      # @see RDF::Enumerable#each_graph
      def graph_names(options = nil, &block)
        @data.keys.reject {|g| g == DEFAULT_GRAPH}
      end

      ##
      # @private
      # @see RDF::Enumerable#each_context
      # @deprecated Use {#each_graph} instead.
      def each_context(&block)
        raise NoMethodError, "Repository#each_context is deprecated in RDF.rb 2.0, use Repository#each_graph instead. Called from #{Gem.location_of_caller.join(':')}" if RDF::VERSION.to_s >= '2.0'
        warn "[DEPRECATION] Repository#each_context is deprecated in RDF.rb 2.0, use Repository#each_graph instead. Called from #{Gem.location_of_caller.join(':')}"
        if block_given?
          contexts = @data.keys
          contexts.delete(DEFAULT_GRAPH)
          contexts.each(&block)
        end
        enum_context
      end

      ##
      # @private
      # @see RDF::Enumerable#each_graph
      def each_graph(&block)
        if block_given?
          @data.each_key do |gn|
            yield RDF::Graph.new(graph_name: (gn == DEFAULT_GRAPH ? nil : gn), data: self)
          end
        end
        enum_graph
      end

    protected

      ##
      # Match elements with eql?, not ==
      # Context of `false` matches default graph. Unbound variable matches non-false graph name
      # @private
      # @see RDF::Queryable#query_pattern
      def query_pattern(pattern, options = {}, &block)
        if block_given?
          graph_name  = pattern.graph_name
          subject     = pattern.subject
          predicate   = pattern.predicate
          object      = pattern.object

          cs = @data.has_key?(graph_name) ? {graph_name => @data[graph_name]} : @data.dup
          cs.each do |c, ss|
            next unless graph_name.nil? || graph_name == false && !c || graph_name.eql?(c)
            ss = if ss.has_key?(subject)
                   { subject => ss[subject] }
                 elsif subject.nil? || subject.is_a?(RDF::Query::Variable)
                   ss.dup
                 else
                   []
                 end
            ss.each do |s, ps|
              next unless subject.nil? || subject.eql?(s)
              ps = if ps.has_key?(predicate)
                     { predicate => ps[predicate] }
                   elsif predicate.nil? || predicate.is_a?(RDF::Query::Variable)
                     ps.dup
                   else
                     []
                   end
              ps.each do |p, os|
                next unless predicate.nil? || predicate.eql?(p)
                os = os.dup # TODO: is this really needed?
                os.each do |o|
                  next unless object.nil? || object.eql?(o)
                  # FIXME: yield has better performance, but broken in MRI 2.2: See https://bugs.ruby-lang.org/issues/11451.
                  block.call(RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: c.equal?(DEFAULT_GRAPH) ? nil : c))
                end
              end
            end
          end
        else
          enum_for(:query_pattern, pattern, options)
        end
      end

      ##
      # @private
      # @see RDF::Mutable#insert
      def insert_statement(statement)
        raise ArgumentError, "Statement #{statement.inspect} is incomplete" if statement.incomplete?
        unless has_statement?(statement)
          s, p, o, c = statement.to_quad
          c = DEFAULT_GRAPH unless supports?(:graph_name)
          c ||= DEFAULT_GRAPH
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
          c = DEFAULT_GRAPH unless supports?(:graph_name)
          c ||= DEFAULT_GRAPH
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
    end # Implementation
  end # Repository

  # RDF::Dataset is a synonym for RDF::Repository
  Dataset = Repository
end # RDF
