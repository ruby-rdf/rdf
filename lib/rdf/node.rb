module RDF
  ##
  # An RDF blank node, also known as an unlabeled node.
  class Node < Resource
    # @return [String]
    attr_accessor :id

    ##
    # @param  [#to_s]
    def initialize(id = nil)
      @id = (id || object_id).to_s
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    def node?
      true
    end

    ##
    # @return [Boolean]
    def anonymous?
      true
    end

    alias_method :unlabeled?, :anonymous?

    ##
    # @return [Boolean]
    def labeled?
      !unlabeled?
    end

    ##
    # @return [String]
    def to_s
      "_:%s" % id.to_s
    end
  end
end
