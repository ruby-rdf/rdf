module RDF
  ##
  # RDF Schema (RDFS) vocabulary.
  #
  # @see http://www.w3.org/TR/rdf-schema/
  class RDFS < Vocabulary("http://www.w3.org/2000/01/rdf-schema#")
    property :comment
    property :domain
    property :isDefinedBy
    property :label
    property :member
    property :range
    property :seeAlso
    property :subClassOf
    property :subPropertyOf
  end
end
