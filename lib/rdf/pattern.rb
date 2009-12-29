module RDF
  ##
  # An RDF query pattern.
  class Pattern < Statement
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # @param  [Variable, Resource]     subject
    # @param  [Variable, URI]          predicate
    # @param  [Variable, Value]        object
    # @param  [Hash{Symbol => Object}] options
    # @option options [Boolean] :optional (`false`)
    def initialize(subject = nil, predicate = nil, object = nil, options = {})
      @options   = options || {}
      @subject   = subject.is_a?(Symbol)   ? Variable.new(subject)   : subject
      @predicate = predicate.is_a?(Symbol) ? Variable.new(predicate) : predicate
      @object    = object.is_a?(Symbol)    ? Variable.new(object)    : object
    end

    ##
    # @param  [Graph, Repository] graph
    # @return [Enumerator]
    def execute(graph, &block)
      graph.query(self) # FIXME
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
      require 'stringio' unless defined?(StringIO)
      StringIO.open do |buffer| # FIXME in RDF::Statement
        buffer << (subject.is_a?(Variable)   ? subject.to_s :   "<#{subject}>") << ' '
        buffer << (predicate.is_a?(Variable) ? predicate.to_s : "<#{predicate}>") << ' '
        buffer << (object.is_a?(Variable)    ? object.to_s :    "<#{object}>") << ' .'
        buffer.string
      end
    end
  end
end
