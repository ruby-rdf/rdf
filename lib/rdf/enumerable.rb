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
            values[value] = true
            block.call(value)
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

    ##
    # Iterates the given block for each unique RDF predicate.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_predicate
    #   @yield  [predicate]
    #   @yieldparam [URI] predicate
    #   @return [void]
    #
    # @overload each_predicate
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_predicate
    def each_predicate(&block)
      if block_given?
        values = {}
        each_statement do |statement|
          value = statement.predicate
          unless value.nil? || values.include?(value)
            values[value] = true
            block.call(value)
          end
        end
      else
        enum_predicate
      end
    end

    ##
    # Returns an enumerator for {#each_predicate}.
    #
    # @return [Enumerator]
    # @see #each_predicate
    def enum_predicate
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_predicate)
    end

    ##
    # Iterates the given block for each unique RDF object.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_object
    #   @yield  [object]
    #   @yieldparam [Value] object
    #   @return [void]
    #
    # @overload each_object
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_object
    def each_object(&block)
      if block_given?
        values = {}
        each_statement do |statement|
          value = statement.object
          unless value.nil? || values.include?(value)
            values[value] = true
            block.call(value)
          end
        end
      else
        enum_object
      end
    end

    ##
    # Returns an enumerator for {#each_object}.
    #
    # @return [Enumerator]
    # @see #each_object
    def enum_object
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_object)
    end

    ##
    # Iterates the given block for each unique RDF context.
    #
    # If no block was given, returns an enumerator.
    #
    # @overload each_context
    #   @yield  [context]
    #   @yieldparam [Resource] context
    #   @return [void]
    #
    # @overload each_context
    #   @return [Enumerator]
    #
    # @return [void]
    # @see #enum_context
    def each_context(&block)
      if block_given?
        values = {}
        each_statement do |statement|
          value = statement.context
          unless value.nil? || values.include?(value)
            values[value] = true
            block.call(value)
          end
        end
      else
        enum_context
      end
    end

    ##
    # Returns an enumerator for {#each_context}.
    #
    # @return [Enumerator]
    # @see #each_context
    def enum_context
      require_enumerator!
      ::Enumerable::Enumerator.new(self, :each_context)
    end

    private

      def require_enumerator! # @private
        require 'enumerator' unless defined?(::Enumerable::Enumerator)
      end

  end
end
