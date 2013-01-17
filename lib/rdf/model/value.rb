module RDF
  ##
  # An RDF value.
  #
  # This is the basis for the RDF.rb class hierarchy. Anything that can be a
  # term of {RDF::Statement RDF statements} should directly or indirectly
  # include this module.
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
  # @see RDF::Graph
  # @see RDF::Literal
  # @see RDF::Node
  # @see RDF::Resource
  # @see RDF::Statement
  # @see RDF::URI
  module Value
    ##
    # Returns `true` if `self` is a graph.
    #
    # @return [Boolean]
    def graph?
      false
    end

    ##
    # Returns `true` if `self` is a literal.
    #
    # @return [Boolean]
    def literal?
      false
    end

    ##
    # Returns `true` if `self` is a blank node.
    #
    # @return [Boolean]
    def node?
      false
    end

    ##
    # Returns `true` if `self` is a resource.
    #
    # @return [Boolean]
    def resource?
      false
    end

    ##
    # Returns `true` if `self` is a statement.
    #
    # @return [Boolean]
    def statement?
      false
    end

    ##
    # Returns `true` if `self` is an IRI reference.
    #
    # By default this is simply an alias for {RDF::Value#uri?}.
    #
    # @return [Boolean]
    def iri?
      uri?
    end

    ##
    # Returns `true` if `self` is a URI reference.
    #
    # @return [Boolean]
    def uri?
      false
    end

    ##
    # Returns `true` if `self` is a query variable.
    #
    # @return [Boolean]
    # @since  0.1.7
    def variable?
      false
    end

    ##
    # Returns `true` if the value has a valid representation
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.9
    def valid?
      true
    end

    ##
    # Returns `true` if value is not valid
    #
    # @return [Boolean] `true` or `false`
    # @since  0.2.1
    def invalid?
      !valid?
    end

    ##
    # Default validate! implementation, overridden in concrete classes
    # @return [RDF::Literal] `self`
    # @raise  [ArgumentError] if the value is invalid
    # @since  0.3.9
    def validate!
      raise ArgumentError if invalid?
    end
    alias_method :validate, :validate!

    ##
    # Returns an `RDF::Value` representation of `self`.
    #
    # @return [RDF::Value]
    def to_rdf
      self
    end

    ##
    # Returns a developer-friendly representation of `self`.
    #
    # The result will be of the format `#<RDF::Value::0x12345678(...)>`,
    # where `...` is the string returned by `#to_s`.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, __id__, to_s)
    end

    ##
    # Outputs a developer-friendly representation of `self` to `stderr`.
    #
    # @return [void]
    def inspect!
      warn(inspect)
    end
    
    ##
    # Default implementation of raise_error, which returns false.
    # Classes including RDF::TypeCheck will raise TypeError
    # instead.
    #
    # @return [false]
    def type_error(message)
      false
    end
  end # Value
end # RDF
