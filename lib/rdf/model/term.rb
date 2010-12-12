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
    # Returns `true` if this term is constant.
    #
    # @return [Boolean] `true` or `false`
    # @see    #variable?
    def constant?
      !(variable?)
    end

    ##
    # Returns `true` if this term is variable.
    #
    # @return [Boolean] `true` or `false`
    # @see    #constant?
    def variable?
      false
    end
  end # Term
end # RDF
