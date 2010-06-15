module RDF
  ##
  module Countable
    extend RDF::Util::Aliasing::LateBound

    ##
    # Returns `true` if `self` contains no RDF statements.
    #
    # @return [Boolean]
    def empty?
      empty = true
      each { empty = false; break }
      empty
    end

    ##
    # Returns the number of RDF statements in `self`.
    #
    # @return [Integer]
    def count
      count = 0
      each { count += 1 }
      count
    end

    alias_method :size,   :count
    alias_method :length, :count # @deprecated
  end
end
