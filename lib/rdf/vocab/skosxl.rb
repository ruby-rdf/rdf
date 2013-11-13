# This file generated automatically using vocab-fetch from http://www.w3.org/TR/skos-reference/skos-xl.rdf
require 'rdf'
module RDF
  class SKOSXL < StrictVocabulary("http://www.w3.org/2008/05/skos-xl#")

    # Class definitions
    property :Label, :label => 'Label'

    # Property definitions
    property :altLabel, :label => 'alternative label', :comment =>
      %(If C skosxl:altLabel L and L skosxl:literalForm V, then X
        skos:altLabel V.)
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(If C skosxl:hiddenLabel L and L skosxl:literalForm V, then C
        skos:hiddenLabel V.)
    property :labelRelation, :label => 'label relation'
    property :literalForm, :label => 'literal form', :comment =>
      %(If two instances of the class skosxl:Label have the same
        literal form, they are not necessarily the same resource.)
    property :literalForm, :label => 'literal form', :comment =>
      %(The range of skosxl:literalForm is the class of RDF plain
        literals.)
    property :prefLabel, :label => 'preferred label', :comment =>
      %(If C skosxl:prefLabel L and L skosxl:literalForm V, then X
        skos:prefLabel V.)
    property :literalForm, :label => 'literal form', :comment =>
      %(If two instances of the class skosxl:Label have the same
        literal form, they are not necessarily the same resource.)
    property :literalForm, :label => 'literal form', :comment =>
      %(The range of skosxl:literalForm is the class of RDF plain
        literals.)
    property :altLabel, :label => 'alternative label', :comment =>
      %(If C skosxl:altLabel L and L skosxl:literalForm V, then X
        skos:altLabel V.)
    property :hiddenLabel, :label => 'hidden label', :comment =>
      %(If C skosxl:hiddenLabel L and L skosxl:literalForm V, then C
        skos:hiddenLabel V.)
    property :labelRelation, :label => 'label relation'
    property :prefLabel, :label => 'preferred label', :comment =>
      %(If C skosxl:prefLabel L and L skosxl:literalForm V, then X
        skos:prefLabel V.)
  end
end
