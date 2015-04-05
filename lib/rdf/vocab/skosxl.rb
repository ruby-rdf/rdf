# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/TR/skos-reference/skos-xl.rdf
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::SKOSXL` from the rdf-vocab gem instead
  class SKOSXL < RDF::StrictVocabulary("http://www.w3.org/2008/05/skos-xl#")

    # Class definitions
    term :Label,
      label: "Label".freeze,
      "owl:disjointWith" => [%(skos:Concept).freeze, %(skos:Collection).freeze, %(skos:ConceptScheme).freeze],
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "skos:definition" => %(A special class of lexical entities.).freeze,
      type: "owl:Class".freeze

    # Property definitions
    property :altLabel,
      comment: %(If C skosxl:altLabel L and L skosxl:literalForm V, then X skos:altLabel V.).freeze,
      label: "alternative label".freeze,
      range: "skosxl:Label".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "rdfs:seeAlso" => %(skos:altLabel).freeze,
      "skos:definition" => %(The property skosxl:altLabel is used to associate an skosxl:Label with a skos:Concept. The property is analogous to skos:altLabel.).freeze,
      type: ["owl:ObjectProperty".freeze, "rdf:Property".freeze]
    property :hiddenLabel,
      comment: %(If C skosxl:hiddenLabel L and L skosxl:literalForm V, then C skos:hiddenLabel V.).freeze,
      label: "hidden label".freeze,
      range: "skosxl:Label".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "rdfs:seeAlso" => %(skos:hiddenLabel).freeze,
      "skos:definition" => %(The property skosxl:hiddenLabel is used to associate an skosxl:Label with a skos:Concept. The property is analogous to skos:hiddenLabel.).freeze,
      type: ["owl:ObjectProperty".freeze, "rdf:Property".freeze]
    property :labelRelation,
      domain: "skosxl:Label".freeze,
      label: "label relation".freeze,
      range: "skosxl:Label".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "skos:definition" => %(The property skosxl:labelRelation is used for representing binary \('direct'\) relations between instances of the class skosxl:Label.).freeze,
      "skos:scopeNote" => %(skosxl:labelRelation is not intended to be used directly, but rather as the basis for a design pattern which can be refined for more specific labeling scenarios.).freeze,
      type: ["owl:ObjectProperty".freeze, "owl:SymmetricProperty".freeze, "rdf:Property".freeze]
    property :literalForm,
      comment: [%(If two instances of the class skosxl:Label have the same literal form, they are not necessarily the same resource.).freeze, %(The range of skosxl:literalForm is the class of RDF plain literals.).freeze],
      domain: "skosxl:Label".freeze,
      label: "literal form".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "skos:definition" => %(The property skosxl:literalForm is used to give the literal form of an skosxl:Label.).freeze,
      type: ["owl:DatatypeProperty".freeze, "rdf:Property".freeze]
    property :prefLabel,
      comment: %(If C skosxl:prefLabel L and L skosxl:literalForm V, then X skos:prefLabel V.).freeze,
      label: "preferred label".freeze,
      range: "skosxl:Label".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/2008/05/skos-xl).freeze,
      "rdfs:seeAlso" => %(skos:prefLabel).freeze,
      "skos:definition" => %(The property skosxl:prefLabel is used to associate an skosxl:Label with a skos:Concept. The property is analogous to skos:prefLabel.).freeze,
      type: ["owl:ObjectProperty".freeze, "rdf:Property".freeze]
  end
end
