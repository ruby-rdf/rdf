module RDF
  ##
  # An RDF query mixin.
  #
  # Classes that include this module must implement an `#each` method that
  # yields {RDF::Statement RDF statements}.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Queryable
    include ::Enumerable

    ##
    # Queries `self` for RDF statements matching the given pattern.
    #
    # @example
    #     queryable.query([nil, RDF::DOAP.developer, nil])
    #     queryable.query(:predicate => RDF::DOAP.developer)
    #
    # @param  [Query, Statement, Array(Value), Hash] pattern
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Array<Statement>]
    def query(pattern, &block)
      raise TypeError.new("#{self} is not readable") if respond_to?(:readable) && !readable?

      case pattern
        when Query
          pattern.execute(self, &block)
        when Array
          query(Statement.new(*pattern), &block)
        when Hash
          query(Statement.new(pattern), &block)
        when Statement
          if block_given?
            find_all { |statement| pattern === statement }.each(&block)
          else
            find_all { |statement| pattern === statement }.extend(RDF::Enumerable, RDF::Queryable)
          end
        else
          raise ArgumentError.new("expected RDF::Query, RDF::Pattern, Array or Hash, but got #{pattern.inspect}")
      end
    end
  end
end
