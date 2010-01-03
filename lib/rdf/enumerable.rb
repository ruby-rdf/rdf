module RDF
  ##
  # An RDF statement enumeration interface.
  #
  # Classes that include this module must implement an {#each} method that
  # yields {RDF::Statement statements}.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Enumerable
    extend ::Enumerable

    ##
    # Iterates the given block for each RDF statement.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_statement
    #   @yield  [statement]
    #   @yieldparam [Statement] statement
    #   @return [void]
    #
    # @overload each_statement
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_statement
    def each_statement(&block)
      if block_given?
        # Invoke {#each} in the containing class:
        each(&block)
      else
        enum_statement
      end
    end

    ##
    # Returns an enumerator for {#each_statement}.
    #
    # @return [Enumerator]
    # @see #each_statement
    def enum_statement
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_statement)
    end

    ##
    # Iterates the given block for each RDF triple.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_triple
    #   @yield  [subject, predicate, object]
    #   @yieldparam [Resource] subject
    #   @yieldparam [URI]      predicate
    #   @yieldparam [Value]    object
    #   @return [void]
    #
    # @overload each_triple
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_triple
    def each_triple(&block)
      if block_given?
        each_statement do |statement|
          block.call(*statement.to_triple)
        end
      else
        enum_triple
      end
    end

    ##
    # Returns an enumerator for {#each_triple}.
    #
    # @return [Enumerator]
    # @see #each_triple
    def enum_triple
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_triple)
    end

    ##
    # Iterates the given block for each RDF quad.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_quad
    #   @yield  [subject, predicate, object, context]
    #   @yieldparam [Resource] subject
    #   @yieldparam [URI]      predicate
    #   @yieldparam [Value]    object
    #   @yieldparam [Resource] context
    #   @return [void]
    #
    # @overload each_quad
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_quad
    def each_quad(&block)
      if block_given?
        each_statement do |statement|
          block.call(*statement.to_quad)
        end
      else
        enum_quad
      end
    end

    ##
    # Returns an enumerator for {#each_quad}.
    #
    # @return [Enumerator]
    # @see #each_quad
    def enum_quad
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_quad)
    end

    ##
    # Iterates the given block for each unique RDF subject.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_subject
    #   @yield  [subject]
    #   @yieldparam [Resource] subject
    #   @return [void]
    #
    # @overload each_subject
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_subject
    def each_subject(&block)
      if block_given?
        values = {}
        each_statement do |statement|
          value = statement.subject
          unless value.nil? || values.include?(value)
            block.call(value)
            values[value] = true
          end
        end
      else
        enum_subject
      end
    end

    ##
    # Returns an enumerator for {#each_subject}.
    #
    # @return [Enumerator]
    # @see #each_subject
    def enum_subject
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_subject)
    end

    private

      def require_enumerator! # @private
        require 'enumerator' unless defined?(::Enumerable::Enumerator)
      end

  end
end
