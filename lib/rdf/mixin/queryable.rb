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
    # @param  [Query, Statement, Hash, Array(Value)] pattern
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Array<Statement>, nil]
    # @example
    #     queryable.query(RDF::Statement.new(:predicate => RDF::DOAP.developer))
    #     queryable.query([nil,RDF::DOAP.developer,nil])
    #     queryable.query( :predicate => RDF::DOAP.developer )
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
          raise ArgumentError.new("expected RDF::Query, RDF::Pattern, Hash, or Array; got #{pattern.inspect}")
      end
    end
  end
end
