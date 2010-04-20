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
    # Queries `self` for RDF statements matching the given `pattern`.
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
      raise TypeError.new("#{self} is not readable") if respond_to?(:readable?) && !readable?

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

    ##
    # Queries `self` for an RDF statement matching the given `pattern` and
    # returns that statement if found.
    #
    # Returns `nil` if no statements match `pattern`.
    #
    # @overload first
    #   @return [RDF::Statement]
    #
    # @overload first(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [RDF::Statement]
    #
    # @return [RDF::Statement]
    # @since  0.1.19
    def first(pattern = nil)
      if pattern
        query(pattern) do |statement|
          return statement
        end
        return nil
      else
        super()
      end
    end

    ##
    # Queries `self` for an RDF statement matching the given `pattern` and
    # returns the statement's subject term.
    #
    # Returns `nil` if no statements match `pattern`.
    #
    # @overload first_subject
    #   @return [RDF::Resource]
    #
    # @overload first_subject(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [RDF::Resource]
    #
    # @return [RDF::Resource]
    # @since  0.1.19
    def first_subject(pattern = nil)
      __send__(*(pattern ? [:query, pattern] : [:each])) do |statement|
        return statement.subject
      end
      return nil
    end

    ##
    # Queries `self` for an RDF statement matching the given `pattern` and
    # returns the statement's predicate term.
    #
    # Returns `nil` if no statements match `pattern`.
    #
    # @overload first_predicate
    #   @return [RDF::URI]
    #
    # @overload first_predicate(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [RDF::URI]
    #
    # @return [RDF::URI]
    # @since  0.1.19
    def first_predicate(pattern = nil)
      __send__(*(pattern ? [:query, pattern] : [:each])) do |statement|
        return statement.predicate
      end
      return nil
    end

    ##
    # Queries `self` for an RDF statement matching the given `pattern` and
    # returns the statement's object term.
    #
    # Returns `nil` if no statements match `pattern`.
    #
    # @overload first_object
    #   @return [RDF::Value]
    #
    # @overload first_object(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [RDF::Value]
    #
    # @return [RDF::Value]
    # @since  0.1.19
    def first_object(pattern = nil)
      __send__(*(pattern ? [:query, pattern] : [:each])) do |statement|
        return statement.object
      end
      return nil
    end

    ##
    # Queries `self` for RDF statements matching the given `pattern` and
    # returns the first found object literal.
    #
    # Returns `nil` if no statements match `pattern` or if none of the found
    # statements have a literal as their object term.
    #
    # @overload first_literal
    #   @return [RDF::Literal]
    #
    # @overload first_literal(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [RDF::Literal]
    #
    # @return [RDF::Literal]
    # @since  0.1.19
    def first_literal(pattern = nil)
      __send__(*(pattern ? [:query, pattern] : [:each])) do |statement|
        return statement.object if statement.object.is_a?(RDF::Literal)
      end
      return nil
    end

    ##
    # Queries `self` for RDF statements matching the given `pattern` and
    # returns the value of the first found object literal.
    #
    # Returns `nil` if no statements match `pattern` or if none of the found
    # statements have a literal as their object term.
    #
    # @overload first_value
    #   @return [Object]
    #
    # @overload first_value(pattern)
    #   @param  [Query, Statement, Array(Value), Hash] pattern
    #   @return [Object]
    #
    # @return [Object]
    # @since  0.1.19
    def first_value(pattern = nil)
      (literal = first_literal(pattern)) ? literal.value : nil
    end
  end
end
