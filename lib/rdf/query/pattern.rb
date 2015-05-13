module RDF; class Query
  ##
  # An RDF query pattern.
  class Pattern < RDF::Statement
    ##
    # @private
    # @since 0.2.2
    def self.from(pattern, options = {})
      case pattern
        when Pattern then pattern
        when Array, Statement
          self.new(pattern[0], pattern[1], pattern[2], options.merge(:context => pattern[3]))
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
    #   @option options [Variable, Resource, Symbol, nil, false] :context   (nil)
    #     A context of nil matches any context, a context of false, matches only the default context.
    #   @option options [Boolean]            :optional  (false)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [Variable, Resource, Symbol, nil]         subject
    #   @param  [Variable, URI, Symbol, nil]              predicate
    #   @param  [Variable, Termm, Symbol, nil]            object
    #   @param  [Hash{Symbol => Object}]          options
    #   @option options [Variable, Resource, Symbol, nil, false] :context   (nil)
    #     A context of nil matches any context, a context of false, matches only the default context.
    #   @option options [Boolean]                 :optional  (false)
    #
    # @note {Statement} treats symbols as interned {Node} instances, in a {Pattern}, they are treated as {Variable}.
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      super
    end

    ##
    # @private
    def initialize!
      @context   = Variable.new(@context)   if @context.is_a?(Symbol)
      @subject   = Variable.new(@subject)   if @subject.is_a?(Symbol)
      @predicate = Variable.new(@predicate) if @predicate.is_a?(Symbol)
      @object    = Variable.new(@object)    if @object.is_a?(Symbol)
      super
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
      subject.nil? && predicate.nil? && object.nil? && context.nil?
    end

    ##
    # Returns `true` if this pattern contains any variables.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def has_variables?
      subject.is_a?(Variable) ||
        predicate.is_a?(Variable) ||
        object.is_a?(Variable) ||
        context.is_a?(Variable)
    end
    alias_method :variables?, :has_variables?

    ##
    # Returns `true` if this is an optional pattern.
    #
    # @example
    #   Pattern.new(:s, :p, :o).optional?                     #=> false
    #   Pattern.new(:s, :p, :o, :optional => true).optional?  #=> true
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
      (has_subject?   ? (subject.resource? || subject.variable?) && subject.valid? : true) && 
      (has_predicate? ? (predicate.uri? || predicate.variable?) && predicate.valid? : true) &&
      (has_object?    ? (object.term? || object.variable?) && object.valid? : true) &&
      (has_context?   ? (context.resource? || context.variable?) && context.valid? : true )
    rescue NoMethodError
      false
    end

    ##
    # Executes this query pattern on the given `queryable` object.
    #
    # Values are matched using using Queryable#query_pattern.
    #
    # If the optional `bindings` are given, variables will be substituted with their values
    # when executing the query.
    #
    # To match triples only in the default context, set context to `false`.
    #
    # @example
    #   Pattern.new(:s, :p, :o).execute(RDF::Repository.load('etc/doap.nt'))
    #
    # @param  [RDF::Queryable] queryable
    #   the graph or repository to query
    # @param  [Hash{Symbol => RDF::Term}] bindings
    #   optional variable bindings to use
    # @yield  [statement]
    #   each matching statement
    # @yieldparam [RDF::Statement] statement
    #   an RDF statement matching this pattern
    # @return [Enumerator]
    #   an enumerator yielding matching statements
    # @see    RDF::Queryable#query
    # @since  0.3.0
    def execute(queryable, bindings = {}, &block)
      query = {
        :subject   => subject.is_a?(Variable)   && bindings[subject.to_sym]   ? bindings[subject.to_sym]   : subject,
        :predicate => predicate.is_a?(Variable) && bindings[predicate.to_sym] ? bindings[predicate.to_sym] : predicate,
        :object    => object.is_a?(Variable)    && bindings[object.to_sym]    ? bindings[object.to_sym]    : object,
        :context   => context.is_a?(Variable)   && bindings[context.to_sym]   ? bindings[context.to_sym]   : context,
      }.delete_if{|k,v| v.nil?}

      # Do all the variable terms refer to distinct variables?
      variables = self.variables
      if variable_count == variables.size
        # If so, we can just let the repository implementation handle
        # everything and yield matching statements directly:
        queryable.query(query, &block)

      # No, some terms actually refer to the same variable...
      else
        # Figure out which terms refer to the same variable:
        terms = variables.each_key.find do |name|
          terms = variable_terms(name)
          break terms if terms.size > 1
        end
        queryable.query(query) do |statement|
          # Only yield those matching statements where the variable
          # constraint is also satisfied:
          # FIXME: `Array#uniq` uses `#eql?` and `#hash`, not `#==`
          if matches = terms.map { |term| statement.send(term) }.uniq.size.equal?(1)
            block.call(statement)
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
        solution[subject.to_sym]   = statement.subject   if subject.is_a?(Variable)
        solution[predicate.to_sym] = statement.predicate if predicate.is_a?(Variable)
        solution[object.to_sym]    = statement.object    if object.is_a?(Variable)
        solution[context.to_sym]   = statement.context   if context.is_a?(Variable)
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
    # @since  0.3.0
    def variable_terms(name = nil)
      terms = []
      terms << :subject   if subject.is_a?(Variable)   && (!name || name.eql?(subject.name))
      terms << :predicate if predicate.is_a?(Variable) && (!name || name.eql?(predicate.name))
      terms << :object    if object.is_a?(Variable)    && (!name || name.eql?(object.name))
      terms << :context   if context.is_a?(Variable)   && (!name || name.eql?(context.name))
      terms
    end

    ##
    # Returns the number of variables in this pattern.
    #
    # Note: this does not count distinct variables, and will therefore e.g.
    # return 3 even if two terms are actually the same variable.
    #
    # @return [Integer] (0..3)
    def variable_count
      count = 0
      count += 1 if subject.is_a?(Variable)
      count += 1 if predicate.is_a?(Variable)
      count += 1 if object.is_a?(Variable)
      count += 1 if context.is_a?(Variable)
      count
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
      variables = {}
      variables.merge!(subject.variables)   if subject.is_a?(Variable)
      variables.merge!(predicate.variables) if predicate.is_a?(Variable)
      variables.merge!(object.variables)    if object.is_a?(Variable)
      variables.merge!(context.variables)   if context.is_a?(Variable)
      variables
    end

    ##
    # Binds the pattern to a solution, making it no longer variable if all variables are resolved to bound variables
    #
    # @param [RDF::Query::Solution] solution
    # @return [self]
    def bind(solution)
      self.to_quad.each_with_index do |term, index|
        if term && term.variable? && solution[term]
          self[index] = solution[term] 
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
      bindings.merge!(subject.bindings)   if subject.is_a?(Variable)
      bindings.merge!(predicate.bindings) if predicate.is_a?(Variable)
      bindings.merge!(object.bindings)    if object.is_a?(Variable)
      bindings.merge!(context.bindings)   if context.is_a?(Variable)
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
      StringIO.open do |buffer| # FIXME in RDF::Statement
        buffer << 'OPTIONAL ' if optional?
        buffer << [subject, predicate, object].map do |r|
          r.is_a?(RDF::Query::Variable) ? r.to_s : RDF::NTriples.serialize(r)
        end.join(" ")
        buffer << case context
          when nil, false then " ."
          when Variable then " #{context.to_s} ."
          else " #{RDF::NTriples.serialize(context)} ."
        end
        buffer.string
      end
    end
  end # Pattern
end; end # RDF::Query
