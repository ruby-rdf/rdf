# This file generated automatically using vocab-fetch from http://www.w3.org/2004/02/skos/core#
require 'rdf'
module RDF
  class SKOS < StrictVocabulary("http://www.w3.org/2004/02/skos/core#")

    # Class definitions
    property :Collection, :label => 'Collection'
    property :Concept, :label => 'Concept'
    property :ConceptScheme, :label => 'Concept Scheme'
    property :OrderedCollection, :label => 'Ordered Collection'

    # Property definitions
    property :altLabel, :label => 'alternative label', :comment =>
      %(The range of skos:altLabel is the class of RDF plain literals.)
    property :altLabel, :label => 'alternative label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :changeNote, :label => 'change note'
    property :definition, :label => 'definition'
    property :editorialNote, :label => 'editorial note'
    property :example, :label => 'example'
    property :broader, :label => 'has broader', :comment =>
      %(Broader concepts are typically rendered as parents in a
        concept hierarchy \(tree\).)
    property :broadMatch, :label => 'has broader match'
    property :broaderTransitive, :label => 'has broader transitive'
    property :closeMatch, :label => 'has close match'
    property :exactMatch, :label => 'has exact match', :comment =>
      %(skos:exactMatch is disjoint with each of the properties
        skos:broadMatch and skos:relatedMatch.)
    property :member, :label => 'has member'
    property :memberList, :label => 'has member list', :comment =>
      %(For any resource, every item in the list given as the value of
        the skos:memberList property is also a value of the
        skos:member property.)
    property :narrower, :label => 'has narrower', :comment =>
      %(Narrower concepts are typically rendered as children in a
        concept hierarchy \(tree\).)
    property :narrowMatch, :label => 'has narrower match'
    property :narrowerTransitive, :label => 'has narrower transitive'
    property :related, :label => 'has related', :comment =>
      %(skos:related is disjoint with skos:broaderTransitive)
    property :relatedMatch, :label => 'has related match'
    property :hasTopConcept, :label => 'has top concept'
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(The range of skos:hiddenLabel is the class of RDF plain
        literals.)
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :historyNote, :label => 'history note'
    property :mappingRelation, :label => 'is in mapping relation with', :comment =>
      %(These concept mapping relations mirror semantic relations, and
        the data model defined below is similar \(with the exception
        of skos:exactMatch\) to the data model defined for semantic
        relations. A distinct vocabulary is provided for concept
        mapping relations, to provide a convenient way to
        differentiate links within a concept scheme from links between
        concept schemes. However, this pattern of usage is not a
        formal requirement of the SKOS data model, and relies on
        informal definitions of best practice.)
    property :inScheme, :label => 'is in scheme'
    property :semanticRelation, :label => 'is in semantic relation with'
    property :topConceptOf, :label => 'is top concept in scheme'
    property :notation, :label => 'notation'
    property :note, :label => 'note'
    property :prefLabel, :label => 'preferred label', :comment =>
      %(The range of skos:prefLabel is the class of RDF plain
        literals.)
    property :prefLabel, :label => 'preferred label', :comment =>
      %(A resource has no more than one value of skos:prefLabel per
        language tag, and no more than one value of skos:prefLabel
        without language tag.)
    property :prefLabel, :label => 'preferred label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :scopeNote, :label => 'scope note'
    property :notation, :label => 'notation'
    property :broader, :label => 'has broader', :comment =>
      %(Broader concepts are typically rendered as parents in a
        concept hierarchy \(tree\).)
    property :broadMatch, :label => 'has broader match'
    property :broaderTransitive, :label => 'has broader transitive'
    property :closeMatch, :label => 'has close match'
    property :exactMatch, :label => 'has exact match', :comment =>
      %(skos:exactMatch is disjoint with each of the properties
        skos:broadMatch and skos:relatedMatch.)
    property :member, :label => 'has member'
    property :memberList, :label => 'has member list', :comment =>
      %(For any resource, every item in the list given as the value of
        the skos:memberList property is also a value of the
        skos:member property.)
    property :narrower, :label => 'has narrower', :comment =>
      %(Narrower concepts are typically rendered as children in a
        concept hierarchy \(tree\).)
    property :narrowMatch, :label => 'has narrower match'
    property :narrowerTransitive, :label => 'has narrower transitive'
    property :related, :label => 'has related', :comment =>
      %(skos:related is disjoint with skos:broaderTransitive)
    property :relatedMatch, :label => 'has related match'
    property :hasTopConcept, :label => 'has top concept'
    property :mappingRelation, :label => 'is in mapping relation with', :comment =>
      %(These concept mapping relations mirror semantic relations, and
        the data model defined below is similar \(with the exception
        of skos:exactMatch\) to the data model defined for semantic
        relations. A distinct vocabulary is provided for concept
        mapping relations, to provide a convenient way to
        differentiate links within a concept scheme from links between
        concept schemes. However, this pattern of usage is not a
        formal requirement of the SKOS data model, and relies on
        informal definitions of best practice.)
    property :inScheme, :label => 'is in scheme'
    property :semanticRelation, :label => 'is in semantic relation with'
    property :topConceptOf, :label => 'is top concept in scheme'
    property :altLabel, :label => 'alternative label', :comment =>
      %(The range of skos:altLabel is the class of RDF plain literals.)
    property :altLabel, :label => 'alternative label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :changeNote, :label => 'change note'
    property :definition, :label => 'definition'
    property :editorialNote, :label => 'editorial note'
    property :example, :label => 'example'
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(The range of skos:hiddenLabel is the class of RDF plain
        literals.)
    property :historyNote, :label => 'history note'
    property :note, :label => 'note'
    property :prefLabel, :label => 'preferred label', :comment =>
      %(A resource has no more than one value of skos:prefLabel per
        language tag, and no more than one value of skos:prefLabel
        without language tag.)
    property :prefLabel, :label => 'preferred label', :comment =>
      %(skos:prefLabel, skos:altLabel and skos:hiddenLabel are
        pairwise disjoint properties.)
    property :prefLabel, :label => 'preferred label', :comment =>
      %(The range of skos:prefLabel is the class of RDF plain
        literals.)
    property :scopeNote, :label => 'scope note'
  end
end
