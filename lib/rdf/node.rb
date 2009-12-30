module RDF
  ##
  # An RDF blank node, also known as an unlabeled node.
  #
  # @example Creating a blank node with an implicit identifier
  #   bnode = RDF::Node.new
  #
  # @example Creating a blank node with an UUID identifier (1)
  #   require 'uuid'
  #   bnode = RDF::Node.new(UUID.generate)
  #
  # @example Creating a blank node with an UUID identifier (2)
  #   require 'uuidtools'
  #   bnode = RDF::Node.new(UUIDTools::UUID.random_create)
  #
  # @see http://github.com/assaf/uuid
  # @see http://uuidtools.rubyforge.org/
  class Node < Resource
    # @return [String]
    attr_accessor :id

    ##
    # @param  [#to_s] id
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
    # Returns `true`.
    #
    # @return [Boolean]
    def anonymous?
      true
    end

    alias_method :unlabeled?, :anonymous?

    ##
    # Returns `false`.
    #
    # @return [Boolean]
    def labeled?
      !unlabeled?
    end

    ##
    # Returns a string representation of this blank node.
    #
    # @return [String]
    def to_s
      "_:%s" % id.to_s
    end
  end
end
