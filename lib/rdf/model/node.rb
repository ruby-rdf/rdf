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
  class Node
    include RDF::Resource

    ##
    # Defines the maximum number of interned Node references that can be held
    # cached in memory at any one time.
    #
    # Note that caching interned nodes means that two different invocations using the same symbol will result in the same node, which may not be appropriate depending on the context from which it is used. RDF requires that bnodes with the same label are, in fact, different bnodes, unless they are used within the same document.
    CACHE_SIZE = -1 # unlimited by default

    ##
    # @return [RDF::Util::Cache]
    # @private
    def self.cache
      require 'rdf/util/cache' unless defined?(::RDF::Util::Cache)
      @cache ||= RDF::Util::Cache.new(CACHE_SIZE)
    end

    ##
    # Returns a blank node with a random UUID-based identifier.
    #
    # @param  [Hash{Symbol => Object}] options
    # @option options [Regexp] :grammar (nil)
    #   a grammar specification that the generated UUID must match
    # @return [RDF::Node]
    def self.uuid(options = {})
      case
        when options[:grammar]
          # The UUID is generated such that its initial part is guaranteed
          # to match the given `grammar`, e.g. `/^[A-Za-z][A-Za-z0-9]*/`.
          # Some RDF storage systems (e.g. AllegroGraph) require this.
          # @see http://github.com/bendiken/rdf/pull/43
          uuid = RDF::Util::UUID.generate(options) until uuid =~ options[:grammar]
        else
          uuid = RDF::Util::UUID.generate(options)
      end
      self.new(uuid)
    end

    ##
    # Alias for `RDF::Node.new`, at the moment.
    #
    # @private
    # @param  [#to_s] id
    # @return [RDF::Node]
    # @since  0.2.0
    def self.intern(id)
      (cache[id = id.to_s] ||= self.new(id)).freeze
    end

    ##
    # Override #dup to remember original object.
    # This allows .eql? to determine that two nodes
    # are the same thing, and not different nodes
    # instantiated with the same identifier.
    # @return [RDF::Node]
    def dup
      node = super
      node.original = self.original || self
      node
    end

    ##
    # Originally instantiated node, if any
    # @return [RDF::Node]
    attr_accessor :original

    # @return [String]
    attr_accessor :id

    ##
    # @param  [#to_s] id
    def initialize(id = nil)
      id = nil if id.to_s.empty?
      @id = (id || "g#{__id__.to_i.abs}").to_s
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
    # Returns a hash code for this blank node.
    #
    # @return [Fixnum]
    def hash
      @id.hash
    end

    ##
    # Determins if `self` is the same term as `other`.
    #
    # In this case, nodes must be the same object
    #
    # @param  [Node] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(RDF::Node) && (self.original || self).equal?(other.original || other)
    end

    ##
    # Checks whether this blank node is equal to `other` (type checking).
    #
    # In this case, different nodes having the same id are considered the same.
    #
    # Per SPARQL data-r2/expr-equal/eq-2-2, numeric can't be compared with other types
    #
    # @param  [Object] other
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-sparql-query/#func-RDFterm-equal
    def ==(other)
      case other
      when Literal
        # If other is a Literal, reverse test to consolodate complex type checking logic
        other == self
      else
        other.respond_to?(:node?) && other.node? &&
          self.hash == other.to_term.hash &&
          other.respond_to?(:id) && @id == other.id
      end
    end
    alias_method :===, :==

    ##
    # Returns the base representation of this node.
    #
    # @return [Sring]
    def to_base
      to_s
    end

    ##
    # Returns a representation of this node independent of any identifier used to initialize it
    #
    # @return [String]
    def to_unique_base
      "_:g#{__id__.to_i.abs}"
    end

    ##
    # Returns a string representation of this blank node.
    #
    # @return [String]
    def to_s
      "_:%s" % @id.to_s
    end

    ##
    # Returns a symbol representation of this blank node.
    #
    # @return [Symbol]
    # @since  0.2.0
    def to_sym
      @id.to_s.to_sym
    end
  end
end
