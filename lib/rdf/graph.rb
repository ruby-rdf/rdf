module RDF
  ##
  # An RDF graph.
  class Graph < Value
    attr_accessor :uri

    def initialize(uri = nil)
      @uri = uri
    end

    def named?()   !unnamed? end
    def unnamed?() uri.nil? end

    def to_s
      named? ? uri.to_s : ""
    end
  end
end
