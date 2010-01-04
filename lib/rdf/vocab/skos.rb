module RDF
  ##
  # Simple Knowledge Organization System (SKOS) vocabulary.
  #
  # @see http://www.w3.org/TR/skos-reference/skos.html
  class SKOS < Vocabulary("http://www.w3.org/2004/02/skos/core#")
    property :altLabel
    property :broadMatch
    property :broader
    property :broaderTransitive
    property :changeNote
    property :closeMatch
    property :definition
    property :editorialNote
    property :exactMatch
    property :example
    property :hasTopConcept
    property :hiddenLabel
    property :historyNote
    property :inScheme
    property :mappingRelation
    property :member
    property :memberList
    property :narrowMatch
    property :narrower
    property :narrowerTransitive
    property :notation
    property :note
    property :prefLabel
    property :related
    property :relatedMatch
    property :scopeNote
    property :semanticRelation
    property :topConceptOf
  end
end
