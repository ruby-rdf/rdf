# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/2003/06/sw-vocab-status/ns#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::VS` from the rdf-vocab gem instead
  class VS < RDF::StrictVocabulary("http://www.w3.org/2003/06/sw-vocab-status/ns#")

    # Property definitions
    property :moreinfo,
      comment: %(more information about the status etc of a term, typically human oriented).freeze,
      label: "more info".freeze,
      "rdfs:isDefinedBy" => %(vs:).freeze,
      type: "rdf:Property".freeze,
      "vs:term_status" => %(unstable).freeze
    property :term_status,
      comment: %(the status of a vocabulary term, expressed as a short symbolic string; known values include 'unstable','testing', 'stable' and 'archaic').freeze,
      label: "term status".freeze,
      "rdfs:isDefinedBy" => %(vs:).freeze,
      type: "rdf:Property".freeze,
      "vs:term_status" => %(unstable).freeze
    property :userdocs,
      comment: %(human-oriented documentation, examples etc for use of this term).freeze,
      label: "user docs".freeze,
      "rdfs:isDefinedBy" => %(vs:).freeze,
      type: "rdf:Property".freeze,
      "vs:term_status" => %(unstable).freeze
  end
end
