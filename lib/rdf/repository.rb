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
  class Repository < Dataset
    include RDF::Mutable

    include RDF::Transactable

    DEFAULT_TX_CLASS = RDF::Transaction

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
    # @option options [Boolean]   :with_graph_name (true)
    #   Indicates that the repository supports named graphs, otherwise,
    #   only the default graph is supported.
    # @option options [Boolean]   :with_validity (true)
    #   Indicates that the repository supports named validation.
    # @option options [Boolean]   :transaction_class (DEFAULT_TX_CLASS)
    #   Specifies the RDF::Transaction implementation to use in this Repository.
    # @yield  [repository]
    # @yieldparam [Repository] repository
    def initialize(uri: nil, title: nil, **options, &block)
      @options = {with_graph_name: true, with_validity: true}.merge(options)
      @uri     = uri
      @title   = title

      # Provide a default in-memory implementation:
      send(:extend, Implementation) if self.class.equal?(RDF::Repository)

      @tx_class ||= @options.delete(:transaction_class) { DEFAULT_TX_CLASS }

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `true` if this respository supports the given `feature`.
    #
    # Supported features include those from {RDF::Enumerable#supports?} along 
    #  with the following:
    #   * `:atomic_write` supports atomic write in transaction scopes
    #   * `:snapshots` supports creation of immutable snapshots of current 
    #        contents via #snapshot.
    # @see RDF::Enumerable#supports?
    def supports?(feature)
      case feature.to_sym
      when :graph_name   then @options[:with_graph_name]
      when :inference    then false  # forward-chaining inference
      when :validity     then @options.fetch(:with_validity, true)
      when :atomic_write then false
      when :snapshots    then false
      else false
      end
    end

    ##
    # Performs a set of deletes and inserts as a combined operation within a 
    # transaction. The Repository's transaction semantics apply to updates made
    # through this method.
    #
    # @see RDF::Mutable#delete_insert
    def delete_insert(deletes, inserts)
      transaction(mutable: true) do
        deletes.respond_to?(:each_statement) ? delete(deletes) : delete(*deletes)
        inserts.respond_to?(:each_statement) ? insert(inserts) : insert(*inserts)
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
    # @see RDF::Dataset#isolation_level
    def isolation_level
      supports?(:snapshot) ? :repeatable_read : super
    end

    ##
    # A queryable snapshot of the repository for isolated reads.
    # 
    # @return [Dataset] an immutable Dataset containing a current snapshot of
    #   the Repository contents.
    def snapshot
      raise NotImplementedError.new("#{self.class}#snapshot")
    end
    
    protected

      ##
      # @private
      # @see RDF::Transactable#begin_transaction
      # @since  0.3.0
      def begin_transaction(mutable: false, graph_name: nil)
        @tx_class.new(self, mutable: mutable, graph_name: graph_name)
      end

    ##
    # @see RDF::Repository
    module Implementation
      require 'hamster'
      DEFAULT_GRAPH = false

      ##
      # @private
      def self.extend_object(obj)
        obj.instance_variable_set(:@data, obj.options.delete(:data) || 
                                          Hamster::Hash.new)
        obj.instance_variable_set(:@tx_class, 
                                  obj.options.delete(:transaction_class) || 
                                  SerializedTransaction)
        super
      end

      ##
      # @private
      # @see RDF::Enumerable#supports?
      def supports?(feature)
        case feature.to_sym
        when :graph_name   then @options[:with_graph_name]
        when :inference    then false  # forward-chaining inference
        when :validity     then @options.fetch(:with_validity, true)
        when :atomic_write then true
        when :snapshots    then true
        else false
        end
      end

      ##
      # @private
      # @see RDF::Countable#count
      def count
        count = 0
        @data.each do |_, ss|
          ss.each do |_, ps|
            ps.each { |_, os| count += os.size }
          end
        end
        count
      end
      
      ##
      # @private
      # @see RDF::Durable#durable?
      def durable?
        false
      end
      
      ##
      # @private
      # @see RDF::Enumerable#has_graph?      
      def has_graph?(graph)
        @data.has_key?(graph)
      end

      ##
      # @private
      # @see RDF::Enumerable#each_graph
      def graph_names(options = nil, &block)        
        @data.keys.reject { |g| g == DEFAULT_GRAPH }.to_a
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

      ##
      # @private
      # @see RDF::Enumerable#has_statement?
      def has_statement?(statement)
        has_statement_in?(@data, statement)
      end

      ##
      # @private
      # @see RDF::Enumerable#each_statement
      def each_statement(&block)
        if block_given?
          @data.each do |g, ss|
            ss.each do |s, ps|
              ps.each do |p, os|
                os.each do |o|
                  yield RDF::Statement.new(s, p, o, graph_name: g.equal?(DEFAULT_GRAPH) ? nil : g)
                end
              end
            end
          end
        end
        enum_statement
      end
      alias_method :each, :each_statement
      
      ##
      # @see Mutable#apply_changeset
      def apply_changeset(changeset)
        data = @data
        changeset.deletes.each { |del| data = delete_from(data, del) }
        changeset.inserts.each { |ins| data = insert_to(data, ins) }
        @data = data
      end

      ##
      # @see RDF::Dataset#isolation_level
      def isolation_level
        :serializable
      end

      ##
      # A readable & queryable snapshot of the repository for isolated reads. 
      # 
      # @return [Dataset] an immutable Dataset containing a current snapshot of
      #   the Repository contents.
      #
      # @see Mutable#snapshot
      def snapshot
        self.class.new(data: @data).freeze
      end

      protected

      ##
      # Match elements with `eql?`, not `==`
      #
      # `graph_name` of `false` matches default graph. Unbound variable matches
      # non-false graph name
      #
      # @private
      # @see RDF::Queryable#query_pattern
      def query_pattern(pattern, options = {}, &block)
        snapshot = @data
        if block_given?
          graph_name  = pattern.graph_name
          subject     = pattern.subject
          predicate   = pattern.predicate
          object      = pattern.object

          cs = snapshot.has_key?(graph_name) ? { graph_name => snapshot[graph_name] } : snapshot

          cs.each do |c, ss|
            next unless graph_name.nil? ||
                        graph_name == false && !c ||
                        graph_name.eql?(c)

            ss = if subject.nil? || subject.is_a?(RDF::Query::Variable)
                   ss
                 elsif ss.has_key?(subject)
                   { subject => ss[subject] }
                 else
                   []
                 end
            ss.each do |s, ps|
              ps = if predicate.nil? || predicate.is_a?(RDF::Query::Variable)
                     ps
                   elsif ps.has_key?(predicate)
                     { predicate => ps[predicate] }
                   else
                     []
                   end
              ps.each do |p, os|
                os.each do |o|
                  next unless object.nil? || object.eql?(o)
                  yield RDF::Statement.new(s, p, o, graph_name: c.equal?(DEFAULT_GRAPH) ? nil : c)
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
        @data = insert_to(@data, statement)
      end

      ##
      # @private
      # @see RDF::Mutable#delete
      def delete_statement(statement)
        @data = delete_from(@data, statement)
      end

      ##
      # @private
      # @see RDF::Mutable#clear
      def clear_statements
        @data = @data.clear
      end

      ##
      # @private
      # @return [Hamster::Hash]
      def data
        @data
      end

      ##
      # @private
      # @return [Hamster::Hash]
      def data=(hash)
        @data = hash
      end

      private

      ##
      # @private
      # @see #has_statement
      def has_statement_in?(data, statement)
        s, p, o, g = statement.to_quad
        g ||= DEFAULT_GRAPH

        data.has_key?(g) &&
          data[g].has_key?(s) &&
          data[g][s].has_key?(p) &&
          data[g][s][p].include?(o)
      end

      ##
      # @private
      # @return [Hamster::Hash] a new, updated hamster hash 
      def insert_to(data, statement)
        raise ArgumentError, "Statement #{statement.inspect} is incomplete" if statement.incomplete?

        unless has_statement_in?(data, statement)
          s, p, o, c = statement.to_quad
          c ||= DEFAULT_GRAPH
          
          return data.put(c) do |subs|
            subs = (subs || Hamster::Hash.new).put(s) do |preds|
              preds = (preds || Hamster::Hash.new).put(p) do |objs|
                (objs || Hamster::Set.new).add(o)
              end
            end
          end
        end
        data
      end
      
      ##
      # @private
      # @return [Hamster::Hash] a new, updated hamster hash 
      def delete_from(data, statement)
        if has_statement_in?(data, statement)
          s, p, o, g = statement.to_quad
          g = DEFAULT_GRAPH unless supports?(:graph_name)
          g ||= DEFAULT_GRAPH

          os   = data[g][s][p].delete(o)
          ps   = os.empty? ? data[g][s].delete(p) : data[g][s].put(p, os)
          ss   = ps.empty? ? data[g].delete(s)    : data[g].put(s, ps)
          return ss.empty? ? data.delete(g) : data.put(g, ss)
        end
        data
      end

      ##
      # A transaction for the Hamster-based `RDF::Repository::Implementation` 
      # with full serializability.
      #
      # @todo refactor me!
      # @see RDF::Transaction
      class SerializedTransaction < Transaction
        def initialize(*)
          super
          @base_snapshot = @snapshot
        end
        
        def insert_statement(statement)
          @snapshot = @snapshot.class
            .new(data: @snapshot.send(:insert_to, 
                                      @snapshot.send(:data), 
                                      process_statement(statement)))
        end

        def delete_statement(statement)
          @snapshot = @snapshot.class
            .new(data: @snapshot.send(:delete_from, 
                                      @snapshot.send(:data), 
                                      process_statement(statement)))
        end

        ##
        # @see RDF::Dataset#isolation_level
        def isolation_level
          :serializable
        end

        def execute
          raise TransactionError, 'Cannot execute a rolled back transaction. ' \
                                  'Open a new one instead.' if @rolledback

          # `Hamster::Hash#==` will use a cheap `#equal?` check first, but fall 
          # back on a full Ruby Hash comparison if required.
          raise TransactionError, 'Error merging transaction. Repository' \
                                  'has changed during transaction time.' unless 
            repository.send(:data) == @base_snapshot.send(:data)

          repository.send(:data=, @snapshot.send(:data))
        end
      end
    end # Implementation
  end # Repository
end # RDF
