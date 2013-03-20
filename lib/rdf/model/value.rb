module RDF
  ##
  # An RDF value.
  #
  # This is the basis for the RDF.rb class hierarchy. Anything that can be a
  # term of {RDF::Statement RDF statements} should directly or indirectly
  # include this module, but it does not define classes that can be included
  # within a {RDF::Statement}, for this see {RDF::Term}.
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
  # @see RDF::Literal
  # @see RDF::Node
  # @see RDF::Resource
  # @see RDF::URI
  # @see RDF::Graph
  # @see RDF::List
  # @see RDF::Statement
  module Value
    ##
    # Returns `true` if `self` is a {RDF::Graph}.
    #
    # @return [Boolean]
    def graph?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Statement}.
    #
    # @return [Boolean]
    def statement?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::List}.
    #
    # @return [Boolean]
    def list?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Term}.
    #
    # @return [Boolean]
    def term?
      false
    end

    ##
    # Returns `true` if this term is variable.
    #
    # @return [Boolean] `true` or `false`
    # @see    #constant?
    def variable?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Literal}.
    #
    # @return [Boolean]
    def literal?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Resource}.
    #
    # @return [Boolean]
    def resource?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Node}.
    #
    # @return [Boolean]
    def node?
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
    # Returns `true` if `self` is a {RDF::URI}.
    #
    # @return [Boolean]
    def uri?
      false
    end

    ##
    # Returns `true` if `self` is a {RDF::Query::Variable}.
    #
    # @return [Boolean]
    # @since  0.1.7
    def variable?
      false
    end

    ##
    # Is this an anonymous value?
    #
    # @return [Boolean] `true` or `false`
    def anonymous?
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
