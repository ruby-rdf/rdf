# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://ogp.me/ns
require 'rdf'
module RDF
  class OGC < RDF::StrictVocabulary("http://ogp.me/ns/class#")

    # Datatype definitions
    term :boolean_str,
      label: "boolean_str".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :date_time_str,
      label: "date_time_str".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :determiner_str,
      label: "determiner_str".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :float_str,
      label: "float_str".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :integer_str,
      label: "integer_str".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :mime_type_str,
      label: "mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :string,
      label: "string".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "xsd:string".freeze,
      type: "rdfs:Datatype".freeze
    term :url,
      label: "url".freeze,
      "rdfs:isDefinedBy" => %(ogc:).freeze,
      subClassOf: "ogc:string".freeze,
      type: "rdfs:Datatype".freeze
  end
end
