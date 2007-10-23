module RDF
  module Collections
    BAG = Namespaces::RDF.Bag
    SEQ = Namespaces::RDF.Seq
    ALT = Namespaces::RDF.Alt
  end

  class Collection < Resource
    def initialize(*values, &block)
      super uri, :rdf, :type => RDF::Collections::SEQ
      values.each { |value| self << RDF::Literal.wrap(value) }
    end

    def <<(value)
      self[:li] ||= []
      self[:li] << value
    end
  end

  class Bag < Collection; end

  class Seq < Collection; end

  class Alt < Collection; end
end
