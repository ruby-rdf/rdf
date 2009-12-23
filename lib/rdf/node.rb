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
    # @return [Boolean]
    def anonymous?() true end

    ##
    # @return [Boolean]
    def labeled?()   !unlabeled? end

    ##
    # @return [Boolean]
    def unlabeled?() anonymous? end

    ##
    # @return [String]
    def to_s
      "_:%s" % id.to_s
    end
  end
end
