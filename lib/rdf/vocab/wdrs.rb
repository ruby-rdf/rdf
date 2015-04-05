# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/2007/05/powder-s#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::WRDS` from the rdf-vocab gem instead
  class WDRS < RDF::StrictVocabulary("http://www.w3.org/2007/05/powder-s#")

    # Class definitions
    term :Document,
      comment: %(A POWDER document.).freeze,
      label: "POWDER document".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#structure).freeze,
      subClassOf: "owl:Ontology".freeze,
      type: "rdfs:Class".freeze
    term :Processor,
      comment: %(A software agent able to process POWDER documents.).freeze,
      label: "POWDER processor".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#powderprocessor).freeze,
      subClassOf: "dc:Agent".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :authenticate,
      comment: %(A pointer to a document that describes how Description Resources created by a FOAF Agent or a DC Terms Agent may be authenticated).freeze,
      label: "authenticate".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#discover).freeze,
      type: "rdf:Property".freeze
    property :certified,
      comment: %(A property that takes a Boolean value to declare whether the author of the data certifies the described resource.).freeze,
      label: "certified".freeze,
      range: "xsd:boolean".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#certification).freeze,
      type: "rdf:Property".freeze
    property :certifiedby,
      comment: %(A property that links a resource to a POWDER document that certifies it.).freeze,
      label: "certified by".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#certification).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :data_error,
      comment: %(A property denoting a description of the specific error found in a given POWDER document.).freeze,
      domain: "wdrs:Document".freeze,
      label: "data error".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#ppErrorhandling).freeze,
      type: "rdf:Property".freeze
    property :describedby,
      comment: %(An RDF property to exactly match the describedby relationship type introduced in http://www.w3.org/TR/powder-dr/#assoc-linking and formally defined in appendix D of the same document, i.e. the relationship A 'describedby' B asserts that resource B provides a description of resource A. There are no constraints on the format or representation of either A or B, neither are there any further constraints on either resource.).freeze,
      label: "described by".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#semlink).freeze,
      type: "rdf:Property".freeze
    property :error_code,
      comment: %(A property denoting the code of any error encountered by the POWDER processor.).freeze,
      label: "error code".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#ppErrorhandling).freeze,
      type: "rdf:Property".freeze
    property :hasIRI,
      comment: %(This property is meant to be used in OWL2 instead of wdrs:matchesregex. It denotes the string data range corresponding to a set of IRIs.).freeze,
      domain: "rdfs:Resource".freeze,
      label: "has IRI".freeze,
      range: "xsd:anyURI".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-formal/#oxRegexSemantics).freeze,
      type: ["rdf:Property".freeze, "owl:DatatypeProperty".freeze]
    property :issuedby,
      comment: %(This property denotes the author of a POWDER document.).freeze,
      label: "issued by".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#line3).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :logo,
      comment: %(Points to a graphic summary for the resources in a given class. Typically, it is a logo denoting conformance of a given \(set of\) resource\(s\) to a given set of criteria.).freeze,
      label: "logo".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#line13).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :matchesregex,
      comment: %(This is the key 'include' property for IRI set definitions in POWDER-S. It is necessary to take account of the POWDER Semantic Extension to process this fully. The value is a regular expression that is matched against an IRI.).freeze,
      domain: "rdfs:Resource".freeze,
      label: "matches regular expression".freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-formal/#regexSemantics).freeze,
      "rdfs:seeAlso" => %(http://www.w3.org/TR/xpath-functions/#regex-syntax).freeze,
      type: ["rdf:Property".freeze, "owl:DatatypeProperty".freeze]
    property :notknownto,
      comment: %(Property used in results returned from a POWDER Processor that has no data about the candidate resource. The value is the IRI of the processor.).freeze,
      label: "not known to".freeze,
      range: "wdrs:Processor".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#powderprocessor).freeze,
      type: "rdf:Property".freeze
    property :notmatchesregex,
      comment: %(This is the key 'exclude' property for IRI set definitions in POWDER-S. It is necessary to take account of the POWDER Semantic Extension to process this fully. The value is a regular expression that is matched against an IRI.).freeze,
      domain: "rdfs:Resource".freeze,
      label: "matches regular expression".freeze,
      range: "xsd:string".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-formal/#regexSemantics).freeze,
      "rdfs:seeAlso" => %(http://www.w3.org/TR/xpath-functions/#regex-syntax).freeze,
      type: ["rdf:Property".freeze, "owl:DatatypeProperty".freeze]
    property :proc_error,
      comment: %(A property denoting a description of the specific software error.).freeze,
      domain: "wdrs:Processor".freeze,
      label: "processing error".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#ppErrorhandling).freeze,
      type: "rdf:Property".freeze
    property :sha1sum,
      comment: %(Links to a Base64-encoded binary SHA-1 hash of the described resource. May be used by POWDER Processors when assessing trustworthiness of a DR.).freeze,
      label: "SHA-1 sum".freeze,
      range: "xsd:base64Binary".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#certification).freeze,
      type: "rdf:Property".freeze
    property :supportedby,
      comment: %(A property that links a POWDER document to some other data source that supports the descriptions provided.).freeze,
      label: "supported by".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#supportedBy).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :tag,
      comment: %(Property linking to a free-text tag which may include spaces.).freeze,
      label: "tag".freeze,
      range: "xsd:token".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#tags).freeze,
      type: ["rdf:Property".freeze, "owl:DatatypeProperty".freeze]
    property :text,
      comment: %(This property provides a summary of the descriptorset that it annotates, suitable for display to end users.).freeze,
      label: "text that may be displayed".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#line13).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :validfrom,
      comment: %(Provides a timestamp that a POWDER Processor may use when assessing trustworthiness of a POWDER document. Informally, a POWDER Processor should normally ignore data in the document before the given date.).freeze,
      label: "valid from".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#certification).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
    property :validuntil,
      comment: %(Provides a timestamp that a POWDER Processor may use when assessing trustworthiness of a POWDER document. Informally, a POWDER Processor should normally ignore data in the document after the given date.).freeze,
      label: "valid until".freeze,
      "rdfs:isDefinedBy" => %(http://www.w3.org/TR/powder-dr/#certification).freeze,
      type: ["rdf:Property".freeze, "owl:AnnotationProperty".freeze]
  end
end
