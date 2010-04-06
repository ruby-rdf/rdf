module RDF
  ##
  # An RDF blank node, also known as an anonymous or unlabeled node.
  #
  # @example Creating a blank node with an implicit identifier
  #   bnode = RDF::Node.new
  #
  # @example Creating a blank node with an UUID identifier
  #   bnode = RDF::Node.uuid
  #   bnode.to_s #=> "_:504c0a30-0d11-012d-3f50-001b63cac539"
  #
  # @see http://rubygems.org/gems/uuid
  # @see http://rubygems.org/gems/uuidtools
  class Node < Resource
    ##
    # Returns a blank node with a random UUID-based identifier.
    #
    # @return [RDF::Node]
    def self.uuid
      begin
        require 'uuid'
        self.new(UUID.generate)
      rescue LoadError => e
        begin
          require 'uuidtools'
          self.new(UUIDTools::UUID.random_create)
        rescue LoadError => e
          raise LoadError.new("no such file to load -- uuid or uuidtools")
        end
      end
    end

    # @return [String]
    attr_accessor :id

    ##
    # @param  [#to_s] id
    def initialize(id = nil)
      @id = (id || "g#{object_id}").to_s
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
