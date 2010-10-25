module RDF; class Query
  ##
  # An RDF query pattern.
  class Pattern < RDF::Statement
    ##
    # @private
    # @since 0.2.2
    def self.from(pattern)
      case pattern
        when Pattern   then pattern
        when Statement then self.new(pattern.to_hash)
        when Hash      then self.new(pattern)
        when Array     then self.new(*pattern)
        else raise ArgumentError.new("expected RDF::Query::Pattern, RDF::Statement, Hash, or Array, but got #{pattern.inspect}")
      end
    end

    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # @overload initialize(options = {})
    #   @param  [Hash{Symbol => Object}]     options
    #   @option options [Variable, Resource] :subject   (nil)
    #   @option options [Variable, URI]      :predicate (nil)
    #   @option options [Variable, Value]    :object    (nil)
    #   @option options [Variable, Resource] :context   (nil)
    #   @option options [Boolean]            :optional  (false)
    #
    # @overload initialize(subject, predicate, object, options = {})
    #   @param  [Variable, Resource]         subject
    #   @param  [Variable, URI]              predicate
    #   @param  [Variable, Value]            object
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
    # Returns `true` if this is an optional pattern.
    #
    # @example
    #   Pattern.new(:s, :p, :o).optional?                     #=> false
    #   Pattern.new(:s, :p, :o, :optional => true).optional?  #=> true
    #
    # @return [Boolean]
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
    # @param  [Hash{Symbol => RDF::Value}] bindings
    #   optional variable bindings to use
    # @yield  [statement]
    #   each matching statement
    # @yieldparam [RDF::Statement] statement
    #   an RDF statement matching this pattern
    # @return [Enumerator]
    #   an enumerator yielding matching statements
    # @see    RDF::Queryable#query
    def execute(queryable, bindings = {}, &block)
      if variables?
        queryable.query({
          # TODO: context handling?
          :subject   => subject   && subject.variable?   ? bindings[subject.to_sym]   : subject,
          :predicate => predicate && predicate.variable? ? bindings[predicate.to_sym] : predicate,
          :object    => object    && object.variable?    ? bindings[object.to_sym]    : object,
        }, &block)
      else
        queryable.query(self, &block)
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
    def solution(statement)
      RDF::Query::Solution.new do |solution|
        solution[subject.to_sym]   = statement.subject   if subject.variable?
        solution[predicate.to_sym] = statement.predicate if predicate.variable?
        solution[object.to_sym]    = statement.object    if object.variable?
      end
    end

    ##
    # Returns `true` if this pattern contains variables.
    #
    # @return [Boolean]
    def variables?
      subject.is_a?(Variable) ||
        predicate.is_a?(Variable) ||
        object.is_a?(Variable)
    end

    ##
    # Returns the number of variables in this pattern.
    #
    # @return [Integer] (0..3)
    def variable_count
      variables.size
    end

    alias_method :cardinality, :variable_count
    alias_method :arity,       :variable_count

    ##
    # Returns all variables in this pattern.
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
    # @return [Boolean]
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
    # @return [Hash{Symbol => Value}]
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
    # @return [Boolean]
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
    # @return [Boolean]
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
    # Returns the string representation of this pattern.
    #
    # @return [String]
    def to_s
      StringIO.open do |buffer| # FIXME in RDF::Statement
        buffer << (subject.is_a?(Variable)   ? subject.to_s :   "<#{subject}>") << ' '
        buffer << (predicate.is_a?(Variable) ? predicate.to_s : "<#{predicate}>") << ' '
        buffer << (object.is_a?(Variable)    ? object.to_s :    "<#{object}>") << ' .'
        buffer.string
      end
    end
  end # class Pattern
end; end # module RDF class Query
