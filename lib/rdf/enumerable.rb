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

    private

      def require_enumerator! # @private
        require 'enumerator' unless defined?(::Enumerable::Enumerator)
      end

  end
end
