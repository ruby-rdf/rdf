module RDF
  ##
  # An RDF value.
  #
  # This is the base class for the RDF.rb class hierarchy. The class of
  # every object that can be a term of {RDF::Statement statements} is a
  # subclass of this class.
  #
  # @example Checking if a value is a resource (blank node or URI reference)
  #   value.resource?
  #
  # @example Checking if a value is a blank node
  #   value.node?
  #
  # @example Checking if a value is a URI reference
  #   value.uri?
  #   value.iri?
  #
  # @example Checking if a value is a literal
  #   value.literal?
  #
  # @abstract
  # @see RDF::Graph
  # @see RDF::Literal
  # @see RDF::Node
  # @see RDF::Resource
  # @see RDF::Statement
  # @see RDF::URI
  class Value
    include Comparable

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
    # Returns `true` if this value is a resource.
    #
    # @return [Boolean]
    def resource?
      false
    end

    ##
    # Returns `true` if this value is a statement.
    #
    # @return [Boolean]
    def statement?
      false
    end

    ##
    # Returns `true` if this value is a URI reference.
    #
    # @return [Boolean]
    def uri?
      false
    end

    alias_method :iri?, :uri?

    ##
    # Returns `true` if this value is a query variable.
    #
    # @return [Boolean]
    # @since  0.1.17
    def variable?
      false
    end

    ##
    # Compares this value to `other` for sorting purposes.
    #
    # Subclasses should override this to provide a more meaningful
    # implementation than the default which simply performs a string
    # comparison based on `#to_s`.
    #
    # @abstract
    # @param  [Object]  other
    # @return [Integer] -1, 0, 1
    def <=>(other)
      self.to_s <=> other.to_s
    end

    ##
    # Returns an RDF::Value representation of this object.
    #
    # @return [Value]
    def to_rdf
      self
    end

    ##
    # Returns a developer-friendly representation of this value.
    #
    # The result will be of the format `#<RDF::Value::0x12345678(...)>`,
    # where `...` is the string returned by `#to_s`.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    ##
    # Outputs a developer-friendly representation of this value to `stderr`.
    #
    # @return [void]
    def inspect!
      warn(inspect)
    end

    private

      # Prevent the instantiation of this class:
      private_class_method :new

      def self.inherited(child) # @private
        # Enable the instantiation of any subclasses:
        child.send(:public_class_method, :new)
        super
      end

  end
end
