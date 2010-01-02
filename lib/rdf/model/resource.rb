module RDF
  ##
  # An RDF resource.
  #
  # @abstract
  class Resource < Value
    # Prevent instantiation of this class.
    private_class_method :new
  end
end
