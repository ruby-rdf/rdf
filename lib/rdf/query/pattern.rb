module RDF; class Query
  ##
  # An RDF query pattern.
  class Pattern < RDF::Statement
    ##
    # @private
    # @since 0.2.2
    def self.from(pattern, graph_name: nil, **options)
      case pattern
        when Pattern then pattern
        when Array, Statement
          graph_name ||= pattern[3]
          self.new(pattern[0], pattern[1], pattern[2], graph_name: graph_name, **options)
        when Hash    then self.new(options.merge(pattern))
        else raise ArgumentError, "expected RDF::Query::Pattern, RDF::Statement, Hash, or Array, but got #{pattern.inspect}"
      end
    end

    ##
    # @overload initialize(options = {})
    #   @param  [Hash{Symbol => Object}]     options
    #   @option options [Variable, Resource, Symbol, nil] :subject   (nil)
    #   @option options [Variable, URI, Symbol, nil]      :predicate (nil)
    #   @option options [Variable, Term, Symbol, nil]     :object    (nil)
    #   @option options [Variable, Resource, Symbol, nil, false] :graph_name   (nil)
    #     A graph_name of nil matches any graph, a graph_name of false, matches only the default graph. (See {RDF::Query#initialize})
    #   @option options [Boolean]            :optional  (false)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [Variable, Resource, Symbol, nil]         subject
    #   @param  [Variable, URI, Symbol, nil]              predicate
    #   @param  [Variable, Termm, Symbol, nil]            object
    #   @param  [Hash{Symbol => Object}]          options
    #   @option options [Variable, Resource, Symbol, nil, false] :graph_name   (nil)
    #     A graph_name of nil matches any graph, a graph_name of false, matches only the default graph. (See {RDF::Query#initialize})
    #   @option options [Boolean]                 :optional  (false)
    #
    # @note {Statement} treats symbols as interned {Node} instances, in a {Pattern}, they are treated as {Variable}.
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      super
    end

    ##
    # @private
    def initialize!
      @graph_name = Variable.new(@graph_name) if @graph_name.is_a?(Symbol)
      @subject    = Variable.new(@subject)    if @subject.is_a?(Symbol)
      @predicate  = Variable.new(@predicate)  if @predicate.is_a?(Symbol)
      @object     = Variable.new(@object)     if @object.is_a?(Symbol)

      # Estmate cost positionally, with variables being least expensive as objects, then predicates, then subjects, then graph_names.
      # XXX does not consider bound variables, which would need to be dynamically calculated.
      @cost = (@object.nil?     || @object.is_a?(Variable)      ? 8 : 0) +
              (@predicate.nil?  || @predicate.is_a?(Variable)   ? 4 : 0) +
              (@subject.nil?    || @subject.is_a?(Variable)     ? 2 : 0) +
              (@graph_name.is_a?(Variable)                      ? 1 : 0) +
              (@object.is_a?(Pattern)                           ? (@object.cost * 4) : 0) +
              (@subject.is_a?(Pattern)                          ? (@subject.cost * 2) : 0)
      super
    end

    ##
    # Create a new pattern from the quads, recursivly dupping sub-patterns.
    def dup
      self.class.from(self.to_quad.map {|t| t.is_a?(RDF::Query::Pattern) ? t.dup : t})
    end

    ##
    # Any additional options for this pattern.
    #
    # @return [Hash]
    attr_reader :options

    ##
    # The estimated cost of this pattern (for query optimization).
    #
    # @return [Numeric]
    attr_accessor :cost

    ##
    # Returns `true` if this is a blank pattern, with all terms being `nil`.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def blank?
      subject.nil? && predicate.nil? && object.nil? && graph_name.nil?
    end

    ##
    # Returns `true` if this pattern contains any variables.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def variables?
      subject    && subject.variable? ||
      predicate  && predicate.variable? ||
      object     && object.variable? ||
      graph_name && graph_name.variable?
    end
    alias_method :has_variables?, :variables?

    ##
    # Returns `true` if this is an optional pattern.
    #
    # @example
    #   Pattern.new(:s, :p, :o).optional?                     #=> false
    #   Pattern.new(:s, :p, :o, optional: true).optional?  #=> true
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def optional?
      !!options[:optional]
    end

    ##
    # Is this pattern composed only of valid components?
    #
    # @return [Boolean] `true` or `false`
    def valid?
      (subject?   ? (subject.resource? || subject.variable?) && subject.valid? : true) && 
      (predicate? ? (predicate.uri? || predicate.variable?) && predicate.valid? : true) &&
      (object?    ? (object.term? || object.variable?) && object.valid? : true) &&
      (graph?     ? (graph_name.resource? || graph_name.variable?) && graph_name.valid? : true)
    rescue NoMethodError
      false
    end

    ##
    # Checks pattern equality against a statement, considering nesting.
    #
    # * A pattern which has a pattern as a subject or an object, matches
    #   a statement having a statement as a subject or an object using {#eql?}.
    #
    # @param  [Statement] other
    # @return [Boolean]
    #
    # @see RDF::URI#==
    # @see RDF::Node#==
    # @see RDF::Literal#==
    # @see RDF::Query::Variable#==
    def eql?(other)
      return false unless other.is_a?(Statement) && (self.graph_name || false) == (other.graph_name || false)

      predicate == other.predicate &&
      (subject.is_a?(Pattern) ? subject.eql?(other.subject) : subject == other.subject) &&
      (object.is_a?(Pattern) ? object.eql?(other.object) : object == other.object)
    end

    ##
    # Executes this query pattern on the given `queryable` object.
    #
    # Values are matched using using Queryable#query_pattern.
    #
    # If the optional `bindings` are given, variables will be substituted with their values when executing the query.
    #
    # To match triples only in the default graph, set graph_name to `false`.
    #
    # @example
    #   Pattern.new(:s, :p, :o).execute(RDF::Repository.load('etc/doap.nt'))
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Symbol => RDF::Term}, RDF::Query::Solution] bindings
    #   optional variable bindings to use
    # @yield  [statement]
    #   each matching statement
    # @yieldparam [RDF::Statement] statement
    #   an RDF statement matching this pattern
    # @return [Enumerable<RDF::Query::Pattern>]
    #   an enumerator yielding matching statements
    # @see    RDF::Queryable#query
    # @since  0.3.0
    def execute(queryable, bindings = {}, &block)
      bindings = bindings.to_h if bindings.is_a?(Solution)
      query = {
        subject:    subject.is_a?(Variable)     && bindings[subject.to_sym]     ? bindings[subject.to_sym]    : subject,
        predicate:  predicate.is_a?(Variable)   && bindings[predicate.to_sym]   ? bindings[predicate.to_sym]  : predicate,
        object:     object.is_a?(Variable)      && bindings[object.to_sym]      ? bindings[object.to_sym]     : object,
        graph_name: graph_name.is_a?(Variable)  && bindings[graph_name.to_sym]  ? bindings[graph_name.to_sym] : graph_name,
      }.delete_if{|k,v| v.nil?}

      # Do all the variable terms refer to distinct variables?
      variables = self.variables
      if variable_count == variables.size
        # If so, we can just let the repository implementation handle
        # everything and yield matching statements directly:
        queryable.query(query, &block)

      # No, some terms actually refer to the same variable...
      else
        # Considering embedding, figure out if variables that may appear more than once resolve to the same value.
        vars = variables.keys
        queryable.query(query).select do |statement|
          if vars.all? {|var| self.var_values(var, statement).uniq.size == 1}
            yield statement if block_given?
            true
          end
        end
      end
    end

    ##
    # Returns a query solution constructed by binding any variables in this
    # pattern with the corresponding terms in the given `statement`.
    #
    # @example
    #   pattern = Pattern.new(:s, :p, :o)
    #   solution = pattern.solution(statement)
    #
    #   pattern[:s] #=> statement.subject
    #   pattern[:p] #=> statement.predicate
    #   pattern[:o] #=> statement.object
    #
    # @param  [RDF::Statement] statement
    #   an RDF statement to bind terms from
    # @return [RDF::Query::Solution]
    # @since  0.3.0
    def solution(statement)
      RDF::Query::Solution.new do |solution|
        solution[subject.to_sym]    = statement.subject    if subject.is_a?(Variable)
        solution[predicate.to_sym]  = statement.predicate  if predicate.is_a?(Variable)
        solution[object.to_sym]     = statement.object     if object.is_a?(Variable)
        solution[graph_name.to_sym] = statement.graph_name if graph_name.is_a?(Variable)
        solution.merge!(subject.solution(statement.subject)) if subject.respond_to?(:solution)
        solution.merge!(object.solution(statement.object)) if object.respond_to?(:solution)
      end
    end

    ##
    # Returns the variable terms in this pattern.
    #
    # @example
    #   Pattern.new(RDF::Node.new, :p, 123).variable_terms    #=> [:predicate]
    #
    # @param  [Symbol, #to_sym] name
    #   an optional variable name
    # @return [Array<Symbol>]
    # @deprecated use {#var_values} instead
    # @since  0.3.0
    def variable_terms(name = nil)
      warn "[DEPRECATION] RDF::Query::Pattern#variable_terms is deprecated and will be removed in a future version.\n" +
           "Called from #{Gem.location_of_caller.join(':')}"
      terms = []
      terms << :subject    if subject.is_a?(Variable)    && (!name || name.eql?(subject.name))
      terms << :predicate  if predicate.is_a?(Variable)  && (!name || name.eql?(predicate.name))
      terms << :object     if object.is_a?(Variable)     && (!name || name.eql?(object.name))
      terms << :graph_name if graph_name.is_a?(Variable) && (!name || name.eql?(graph_name.name))
      terms
    end

    ##
    # Returns all values the statement in the same pattern position
    #
    # @param [Symbol] var
    # @param [RDF::Statement] statement
    # @return [Array<RDF::Term>]
    def var_values(var, statement)
      %i(subject predicate object graph_name).map do |position|
        po = self.send(position)
        so = statement.send(position)
        po.var_values(var, so) if po.respond_to?(:var_values)
      end.flatten.compact
    end

    ##
    # Returns the number of variables in this pattern.
    #
    # Note: this does not count distinct variables, and will therefore e.g.
    # return 3 even if two terms are actually the same variable.
    #
    # @return [Integer] (0..3)
    def variable_count
      [subject, predicate, object, graph_name].inject(0) do |memo, term|
        memo += (term.is_a?(Variable) ? 1 :
                 (term.respond_to?(:variable_count) ? term.variable_count : 0))
      end
    end
    alias_method :cardinality, :variable_count
    alias_method :arity,       :variable_count

    ##
    # Returns all variables in this pattern.
    #
    # Note: this returns a hash containing distinct variables only.
    #
    # @return [Hash{Symbol => Variable}]
    def variables
      [subject, predicate, object, graph_name].inject({}) do |memo, term|
        term && term.variable? ? memo.merge(term.variables) : memo
      end
    end

    ##
    # Binds the pattern to a solution, making it no longer variable if all variables are resolved to bound variables
    #
    # @param [RDF::Query::Solution] solution
    # @return [self]
    def bind(solution)
      self.to_quad.each_with_index do |term, index|
        if term.is_a?(Variable) && solution[term]
          self[index] = solution[term] 
        elsif term.is_a?(Pattern)
          term.bind(solution)
        end
      end
      self
    end

    ##
    # Returns `true` if this pattern contains bindings.
    #
    # @return [Boolean] `true` or `false`
    def bindings?
      !bindings.empty?
    end

    ##
    # Returns the number of bindings in this pattern.
    #
    # @return [Integer] (0..3)
    def binding_count
      bindings.size
    end

    ##
    # Returns all bindings in this pattern.
    #
    # @return [Hash{Symbol => RDF::Term}]
    def bindings
      bindings = {}
      bindings.merge!(subject.bindings)    if subject && subject.variable?
      bindings.merge!(predicate.bindings)  if predicate && predicate.variable?
      bindings.merge!(object.bindings)     if object && object.variable?
      bindings.merge!(graph_name.bindings) if graph_name && graph_name.variable?
      bindings
    end

    ##
    # Returns `true` if all variables in this pattern are bound.
    #
    # @return [Boolean] `true` or `false`
    def bound?
      !variables.empty? && variables.values.all?(&:bound?)
    end

    ##
    # Returns all bound variables in this pattern.
    #
    # @return [Hash{Symbol => Variable}]
    def bound_variables
      variables.reject { |name, variable| variable.unbound? }
    end

    ##
    # Returns `true` if all variables in this pattern are unbound.
    #
    # @return [Boolean] `true` or `false`
    def unbound?
      !variables.empty? && variables.values.all?(&:unbound?)
    end

    ##
    # Returns all unbound variables in this pattern.
    #
    # @return [Hash{Symbol => Variable}]
    def unbound_variables
      variables.reject { |name, variable| variable.bound? }
    end

    ##
    # Returns a string representation of this pattern.
    #
    # @return [String]
    def to_s
      (optional? ? 'OPTIONAL ' : '') + super
    end
  end # Pattern
end; end # RDF::Query
