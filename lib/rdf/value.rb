module RDF
  ##
  # An RDF value.
  #
  # @abstract
  # @see Graph
  # @see Literal
  # @see Node
  # @see Resource
  # @see Statement
  # @see URI
  class Value
    # Prevent the instantiation of this class.
    private_class_method :new

    ##
    # Returns `true` if this value is a graph.
    #
    # @return [Boolean]
    def graph?
      false
    end

    ##
    # Returns `true` if this value is a literal.
    #
    # @return [Boolean]
    def literal?
      false
    end

    ##
    # Returns `true` if this value is a blank node.
    #
    # @return [Boolean]
    def node?
      false
    end

    ##
    # Returns `true` if this value is a URI.
    #
    # @return [Boolean]
    def uri?
      false
    end

    alias_method :iri?, :uri?

    ##
    # Compares this value to `other` for sorting purposes.
    #
    # @param  [Object]  other
    # @return [Integer] -1, 0, 1
    def <=>(other)
      self.to_s <=> other.to_s
    end

    ##
    # Returns a developer-readable representation of this value.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    private

      def self.inherited(child) #:nodoc:
        # Enable the instantiation of any subclasses.
        child.send(:public_class_method, :new)
        super
      end

  end
end
