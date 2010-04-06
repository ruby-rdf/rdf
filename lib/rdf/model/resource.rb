module RDF
  ##
  # An RDF resource.
  #
  # @abstract
  class Resource < Value
    ##
    # Instantiates an {RDF::Node} or an {RDF::URI}, depending on the given
    # argument.
    #
    # @return [RDF::Resource]
    def self.new(*args, &block)
      if self == Resource
        case arg = args.shift
          when /^_:(.*)$/ then Node.new($1, *args, &block)
          else URI.new(arg, *args, &block)
        end
      else
        super
      end
    end

    ##
    # Returns `true` to indicate that this value is a resource.
    #
    # @return [Boolean]
    def resource?
      true
    end
  end
end
