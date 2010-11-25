module RDF; class Query
  ##
  # An RDF query pattern.
  class Pattern < RDF::Statement
    ##
    # @private
    # @since 0.2.2
    def self.from(pattern, options = {})
      case pattern
        when Pattern   then pattern
        when Statement then self.new(options.merge(pattern.to_hash))
        when Hash      then self.new(options.merge(pattern))
        when Array     then self.new(pattern[0], pattern[1], pattern[2], options.merge(:context => pattern[3]))
        else raise ArgumentError.new("expected RDF::Query::Pattern, RDF::Statement, Hash, or Array, but got #{pattern.inspect}")
      end
    end

    ##
    # @overload initialize(options = {})
    #   @param  [Hash{Symbol => Object}]     options
    #   @option options [Variable, Resource] :subject   (nil)
    #   @option options [Variable, URI]      :predicate (nil)
    #   @option options [Variable, Term]     :object    (nil)
    #   @option options [Variable, Resource] :context   (nil)
    #   @option options [Boolean]            :optional  (false)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [Variable, Resource]         subject
    #   @param  [Variable, URI]              predicate
    #   @param  [Variable, Term]             object
    #   @param  [Hash{Symbol => Object}]     options
    #   @option options [Variable, Resource] :context   (nil)
    #   @option options [Boolean]            :optional  (false)
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
    # Returns `true` if this is a blank pattern, with all terms being `nil`.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def blank?
      subject.nil? && predicate.nil? && object.nil? && context.nil?
    end

    ##
    # Returns `true` if this is a constant pattern, with all terms being
    # either URIs, blank nodes, or literals.
    #
    # A constant pattern is structurally and functionally equivalent to an
    # RDF statement.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def constant?
      !(variable?)
    end

    ##
    # Returns `true` if this is a variable pattern, with any term being
    # `nil` or a variable.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def variable?
      subject.nil? || predicate.nil? || object.nil? || context.nil? || has_variables?
    end

    ##
    # Returns `true` if this pattern contains any variables.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def has_variables?
      subject.is_a?(Variable) ||
        predicate.is_a?(Variable) ||
        object.is_a?(Variable)
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
    # Executes this query pattern on the given `queryable` object.
    #
    # By default any variable terms in this pattern will be treated as `nil`
    # wildcards when executing the query. If the optional `bindings` are
    # given, variables will be substituted with their values when executing
    # the query.
    #
    # @example
    #   Pattern.new(:s, :p, :o).execute(RDF::Repository.load('data.nt'))
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
      # Does this pattern contain any variables?
      if !(has_variables?)
        # With no variables to worry about, we will let the repository
        # implementation yield matching statements directly:
        queryable.query(self, &block)

      # Yes, this pattern uses at least one variable...
      else
        query = {
          :subject   => subject   && subject.variable?   ? bindings[subject.to_sym]   : subject,
          :predicate => predicate && predicate.variable? ? bindings[predicate.to_sym] : predicate,
          :object    => object    && object.variable?    ? bindings[object.to_sym]    : object,
          # TODO: context handling?
        }

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
    end

    ##
    # Returns a query solution constructed by binding any variables in this
    # pattern with the corresponding terms in the given `statement`.
    #
    # @example
    #   pattern.solution(statement)
    #
    # @param  [RDF::Statement] statement
    #   an RDF statement to bind terms from
    # @return [RDF::Query::Solution]
    # @since  0.3.0
    def solution(statement)
      RDF::Query::Solution.new do |solution|
        solution[subject.to_sym]   = statement.subject   if subject.variable?
        solution[predicate.to_sym] = statement.predicate if predicate.variable?
        solution[object.to_sym]    = statement.object    if object.variable?
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
      variables
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
        buffer << (subject.is_a?(Variable)   ? subject.to_s :   "<#{subject}>") << ' '
        buffer << (predicate.is_a?(Variable) ? predicate.to_s : "<#{predicate}>") << ' '
        buffer << (object.is_a?(Variable)    ? object.to_s :    "<#{object}>") << ' .'
        buffer.string
      end
    end
  end # Pattern
end; end # RDF::Query
