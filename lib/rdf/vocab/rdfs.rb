# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2000/01/rdf-schema#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2000/01/rdf-schema#>
  #   #
  #   # The RDF Schema vocabulary (RDFS)
  #   # @see http://www.w3.org/2000/01/rdf-schema-more
  #   class RDFS < RDF::StrictVocabulary
  #     # The class of classes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Class
  #
  #     # The class of RDF containers.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Container
  #
  #     # The class of container membership properties, rdf:_1, rdf:_2, ..., all of which are sub-properties of 'member'.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ContainerMembershipProperty
  #
  #     # The class of RDF datatypes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Datatype
  #
  #     # The class of literal values, eg. textual strings and integers.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Literal
  #
  #     # The class resource, everything.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Resource
  #
  #     # A description of the subject resource.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :comment
  #
  #     # A domain of the subject property.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :domain
  #
  #     # The defininition of the subject resource.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :isDefinedBy
  #
  #     # A human-readable name for the subject.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :label
  #
  #     # A member of the subject resource.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :member
  #
  #     # A range of the subject property.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :range
  #
  #     # Further information about the subject resource.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :seeAlso
  #
  #     # The subject is a subclass of a class.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :subClassOf
  #
  #     # The subject is a subproperty of a property.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :subPropertyOf
  #
  #   end
  RDFS = Class.new(RDF::StrictVocabulary("http://www.w3.org/2000/01/rdf-schema#")) do

    # Ontology definition
    ontology :"http://www.w3.org/2000/01/rdf-schema#",
      "http://purl.org/dc/elements/1.1/title": "The RDF Schema vocabulary (RDFS)",
      "http://www.w3.org/2000/01/rdf-schema#seeAlso": "http://www.w3.org/2000/01/rdf-schema-more",
      type: "http://www.w3.org/2002/07/owl#Ontology"

    # Class definitions
    term :Class,
      comment: "The class of classes.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "Class",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Container,
      comment: "The class of RDF containers.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "Container",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :ContainerMembershipProperty,
      comment: "The class of container membership properties, rdf:_1, rdf:_2, ...,\n                    all of which are sub-properties of 'member'.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "ContainerMembershipProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Datatype,
      comment: "The class of RDF datatypes.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "Datatype",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Literal,
      comment: "The class of literal values, eg. textual strings and integers.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "Literal",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Resource,
      comment: "The class resource, everything.",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"

    # Property definitions
    property :comment,
      comment: "A description of the subject resource.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "comment",
      range: "http://www.w3.org/2000/01/rdf-schema#Literal",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :domain,
      comment: "A domain of the subject property.",
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "domain",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :isDefinedBy,
      comment: "The defininition of the subject resource.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "isDefinedBy",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      subPropertyOf: "http://www.w3.org/2000/01/rdf-schema#seeAlso",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :label,
      comment: "A human-readable name for the subject.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "label",
      range: "http://www.w3.org/2000/01/rdf-schema#Literal",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :member,
      comment: "A member of the subject resource.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "member",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :range,
      comment: "A range of the subject property.",
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "range",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :seeAlso,
      comment: "Further information about the subject resource.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "seeAlso",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :subClassOf,
      comment: "The subject is a subclass of a class.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Class",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "subClassOf",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :subPropertyOf,
      comment: "The subject is a subproperty of a property.",
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#",
      label: "subPropertyOf",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
  end
end
