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
    # @param  [Query, Statement, Array(Value)] pattern
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Array<Statement>, nil]
    def query(pattern, &block)
      raise TypeError.new("#{self} is not readable") if respond_to?(:readable) && !readable?

      case pattern
        when Query
          pattern.execute(self, &block)
        when Array
          query(Statement.new(*pattern), &block)
        when Statement, Pattern
          if block_given?
            find_all { |statement| pattern === statement }.each(&block)
          else
            find_all { |statement| pattern === statement }
          end
        else
          raise ArgumentError.new("expected RDF::Query or RDF::Pattern, got #{pattern.inspect}")
      end
    end
  end
end
