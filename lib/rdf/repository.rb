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
  #   repository.statement?(statement)
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
  # Repositories support transactions with a variety of ACID semantics:
  # 
  # Atomicity is indicated by `#supports?(:atomic_write)`. When atomicity is
  # supported, writes through {#transaction}, {#apply_changeset} and 
  # {#delete_insert} are applied atomically.
  #
  # Consistency should be guaranteed, in general. Repositories that don't 
  # support consistency, or that have specialized definitions of consistency 
  # above those declared by the RDF data model, should advertise this fact in
  # their documentation.
  #
  # Isolation may be supported at various levels, indicated by 
  # {#isolation_level}:
  #   - `:read_uncommitted`: Inserts & deletes in an uncommitted transaction 
  #      scope may be visible to other transactions (or via `#each`, etc...)
  #   - `:read_committed`: Inserts & deletes may be visible to other 
  #      transactions once committed
  #   - `:repeatable_read`: Phantom reads may be possible
  #   - `:snapshot`: A transaction reads a consistent snapshot of the data. 
  #      Write skew anomalies may occur (for various definitions of consistency)
  #   - `:serializable`: A transaction reads a consistent snapshot of the data.
  #      When two or more transactions attempt conflicting writes, only one of
  #      them may succeed.
  #
  # Durability is noted via {RDF::Durable} support and {#durable?}
  # /{#nondurable?}.
  #
  # @example Transational read from a repository
  #   repository.transaction do |tx|
  #     tx.statement?(statement)
  #     tx.query([:s, :p, :o])
  #   end
  #
  # @example Transational read/write of a repository
  #   repository.transaction(mutable: true) do |tx|
  #     tx.insert(*statements)
  #     tx.insert(statement)
  #     tx.insert([subject, predicate, object])
  #     tx.delete(*statements)
  #     tx.delete(statement)
  #     tx.delete([subject, predicate, object])
  #   end
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
    def self.load(urls, **options, &block)
      self.new(**options) do |repository|
        Array(urls).each do |url|
          repository.load(url, **options)
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
      when :graph_name       then @options[:with_graph_name]
      when :inference        then false  # forward-chaining inference
      when :validity         then @options.fetch(:with_validity, true)
      when :literal_equality then true
      when :atomic_write     then false
      when :rdf_full         then false
      when :base_direction   then false
      when :snapshots        then false
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
      return super unless supports?(:atomic_write)

      transaction(mutable: true) do
        deletes.respond_to?(:each_statement) ? delete(deletes) : delete(*deletes)
        inserts.respond_to?(:each_statement) ? insert(inserts) : insert(*inserts)
      end
    end

    ##
    # @private
    # @see RDF::Enumerable#project_graph
    def project_graph(graph_name, &block)
      graph = RDF::Graph.new(graph_name: graph_name, data: self)
      graph.each(&block) if block_given?
      graph
    end

    ##
    # @see RDF::Dataset#isolation_level
    def isolation_level
      supports?(:snapshots) ? :repeatable_read : super
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
    # A default Repository implementation supporting atomic writes and 
    # serializable transactions.
    #
    # @see RDF::Repository
    module Implementation
      DEFAULT_GRAPH = false
      
      ##
      # @deprecated moved to {RDF::Transaction::SerializedTransaction}
      SerializedTransaction = RDF::Transaction::SerializedTransaction

      ##
      # @private
      def self.extend_object(obj)
        obj.instance_variable_set(:@data, obj.options.delete(:data) || 
                                          Hash.new)
        obj.instance_variable_set(:@tx_class, 
                                  obj.options.delete(:transaction_class) || 
                                  RDF::Transaction::SerializedTransaction)
        super
      end

      ##
      # @private
      # @see RDF::Enumerable#supports?
      def supports?(feature)
        case feature.to_sym
        when :graph_name       then @options[:with_graph_name]
        when :validity         then @options.fetch(:with_validity, true)
        when :literal_equality then true
        when :atomic_write     then true
        when :rdf_full         then true
        when :base_direction   then true
        when :snapshots        then true
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
      # @overload graph?
      #   Returns `false` to indicate that this is not a graph.
      #
      #   @return [Boolean]
      # @overload graph?(name)
      #   Returns `true` if `self` contains the given RDF graph_name.
      #
      #   @param  [RDF::Resource, false] graph_name
      #     Use value `false` to query for the default graph_name
      #   @return [Boolean]
      def graph?(*args)
        case args.length
        when 0 then false
        when 1 then @data.key?(args.first)
        else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
        end
      end
      alias_method :has_graph?, :graph?

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
      # @overload statement?
      #   Returns `false` indicating this is not an RDF::Statemenet.
      #   @return [Boolean]
      #   @see RDF::Value#statement?
      # @overload statement?(statement)
      #   @private
      #   @see    RDF::Enumerable#statement?
      def statement?(*args)
        case args.length
        when 0 then false
        when 1 then args.first && statement_in?(@data, args.first)
        else raise ArgumentError("wrong number of arguments (given #{args.length}, expected 0 or 1)")
        end
      end
      alias_method :has_statement?, :statement?

      ##
      # @private
      # @see RDF::Enumerable#each_statement
      def each_statement(&block)
        if block_given?
          @data.each do |g, ss|
            ss.each do |s, ps|
              ps.each do |p, os|
                os.each do |o, object_options|
                  yield RDF::Statement.new(s, p, o, object_options.merge(graph_name: g.equal?(DEFAULT_GRAPH) ? nil : g))
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
        changeset.deletes.each do |del|
          if del.constant?
            data = delete_from(data, del)
          else
            # we need this condition to handle wildcard statements
            query_pattern(del) { |stmt| data = delete_from(data, stmt) }
          end
        end
        changeset.inserts.each { |ins| data = insert_to(data, ins) }
        @data = data
      end

      ##
      # @see RDF::Dataset#isolation_level
      def isolation_level
        :snapshot
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
      def query_pattern(pattern, **options, &block)
        snapshot = @data
        if block_given?
          graph_name  = pattern.graph_name
          subject     = pattern.subject
          predicate   = pattern.predicate
          object      = pattern.object

          cs = snapshot.key?(graph_name) ? { graph_name => snapshot[graph_name] } : snapshot

          cs.each do |c, ss|
            next unless graph_name.nil? ||
                        graph_name == DEFAULT_GRAPH && !c ||
                        graph_name.eql?(c)

            ss = if subject.nil? || subject.is_a?(RDF::Query::Variable)
              ss
            elsif subject.is_a?(RDF::Query::Pattern)
              # Match subjects which are statements matching this pattern
              ss.keys.select {|s| s.statement? && subject.eql?(s)}.inject({}) do |memo, st|
                memo.merge(st => ss[st])
              end
            elsif ss.key?(subject)
              { subject => ss[subject] }
            else
              []
            end
            ss.each do |s, ps|
              ps = if predicate.nil? || predicate.is_a?(RDF::Query::Variable)
                ps
              elsif ps.key?(predicate)
                { predicate => ps[predicate] }
              else
                []
              end
              ps.each do |p, os|
                os.each do |o, object_options|
                  next unless object.nil? || object.eql?(o)
                  yield RDF::Statement.new(s, p, o, object_options.merge(graph_name: c.equal?(DEFAULT_GRAPH) ? nil : c))
                end
              end
            end
          end
        else
          enum_for(:query_pattern, pattern, **options)
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
        @data = @data.class.new
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
      # @see #statement?
      def statement_in?(data, statement)
        s, p, o, g = statement.to_quad
        g ||= DEFAULT_GRAPH

        data.key?(g) &&
          data[g].key?(s) &&
          data[g][s].key?(p) &&
          data[g][s][p].key?(o)
      end
      alias_method :has_statement_in?, :statement_in?

      ##
      # @private
      # @return [Hamster::Hash] a new, updated hamster hash 
      def insert_to(data, statement)
        raise ArgumentError, "Statement #{statement.inspect} is incomplete" if statement.incomplete?

        unless statement_in?(data, statement)
          s, p, o, c = statement.to_quad
          c ||= DEFAULT_GRAPH

          data          = data.has_key?(c)       ? data.dup       : data.merge(c => {})
          data[c]       = data[c].has_key?(s)    ? data[c].dup    : data[c].merge(s => {})
          data[c][s]    = data[c][s].has_key?(p) ? data[c][s].dup : data[c][s].merge(p => {})
          data[c][s][p] = data[c][s][p].merge(o => statement.options)
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

          os   = data[g][s][p].dup.delete_if {|k,v| k == o}
          ps   = os.empty? ? data[g][s].dup.delete_if {|k,v| k == p} : data[g][s].merge(p => os)
          ss   = ps.empty? ? data[g].dup.delete_if    {|k,v| k == s} : data[g].merge(s => ps)
          return ss.empty? ? data.dup.delete_if       {|k,v| k == g} : data.merge(g => ss)
        end
        data
      end
    end # Implementation
  end # Repository
end # RDF
