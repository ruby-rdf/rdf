module RDF
  ##
  # An RDF term.
  #
  # Terms can be used as subjects, predicates, objects, and contexts of
  # statements.
  #
  # @since 0.3.0
  module Term
    include RDF::Value
    include Comparable

    ##
    # Compares `self` to `other` for sorting purposes.
    #
    # Subclasses should override this to provide a more meaningful
    # implementation than the default which simply performs a string
    # comparison based on `#to_s`.
    #
    # @abstract
    # @param  [Object]  other
    # @return [Integer] `-1`, `0`, or `1`
    def <=>(other)
      self.to_s <=> other.to_s
    end

    ##
    # Compares `self` to `other` to implement RDFterm-equal.
    #
    # Subclasses should override this to provide a more meaningful
    # implementation than the default which simply performs a string
    # comparison based on `#to_s`.
    #
    # @abstract
    # @param  [Object]  other
    # @return [Integer] `-1`, `0`, or `1`
    #
    # @see http://www.w3.org/TR/rdf-sparql-query/#func-RDFterm-equal
    def ==(other)
      super
    end

    ##
    # Determins if `self` is the same term as `other`.
    #
    # Subclasses should override this to provide a more meaningful
    # implementation than the default which simply performs a string
    # comparison based on `#to_s`.
    #
    # @abstract
    # @param  [Object]  other
    # @return [Integer] `-1`, `0`, or `1`
    #
    # @see http://www.w3.org/TR/rdf-sparql-query/#func-sameTerm
    def eql?(other)
      super
    end

    ##
    # Returns a base representation of `self`.
    #
    # @return [RDF::Value]
    def to_base
      self
    end

    ##
    # Returns `true` if `self` is a {RDF::Term}.
    #
    # @return [Boolean]
    def term?
      true
    end

    ##
    # Returns itself.
    #
    # @return [RDF::Value]
    def to_term
      self
    end

    protected
    ##
    # Escape a term using standard character escapes
    #
    # @param  [String] string
    # @return [String]
    def escape(string)
      string.gsub('\\', '\\\\').
             gsub("\b", '\\b').
             gsub("\f", '\\f').
             gsub("\t", '\\t').
             gsub("\n", '\\n').
             gsub("\r", '\\r').
             gsub('"', '\\"')
    end

  end # Term
end # RDF
