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
  #     # The class of container membership properties, rdf:_1, rdf:_2, ...,                     all of which are sub-properties of 'member'.
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
      "dc11:title": "The RDF Schema vocabulary (RDFS)".freeze,
      "rdfs:seeAlso": "http://www.w3.org/2000/01/rdf-schema-more".freeze,
      type: "owl:Ontology".freeze

    # Class definitions
    term :Class,
      comment: %(The class of classes.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "Class".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Container,
      comment: %(The class of RDF containers.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "Container".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :ContainerMembershipProperty,
      comment: %(The class of container membership properties, rdf:_1, rdf:_2, ...,
                    all of which are sub-properties of 'member'.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "ContainerMembershipProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :Datatype,
      comment: %(The class of RDF datatypes.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "Datatype".freeze,
      subClassOf: "rdfs:Class".freeze,
      type: "rdfs:Class".freeze
    term :Literal,
      comment: %(The class of literal values, eg. textual strings and integers.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "Literal".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Resource,
      comment: %(The class resource, everything.).freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "Resource".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :comment,
      comment: %(A description of the subject resource.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "comment".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :domain,
      comment: %(A domain of the subject property.).freeze,
      domain: "rdf:Property".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "domain".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :isDefinedBy,
      comment: %(The defininition of the subject resource.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "isDefinedBy".freeze,
      range: "rdfs:Resource".freeze,
      subPropertyOf: "rdfs:seeAlso".freeze,
      type: "rdf:Property".freeze
    property :label,
      comment: %(A human-readable name for the subject.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "label".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :member,
      comment: %(A member of the subject resource.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "member".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :range,
      comment: %(A range of the subject property.).freeze,
      domain: "rdf:Property".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "range".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :seeAlso,
      comment: %(Further information about the subject resource.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "seeAlso".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :subClassOf,
      comment: %(The subject is a subclass of a class.).freeze,
      domain: "rdfs:Class".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "subClassOf".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :subPropertyOf,
      comment: %(The subject is a subproperty of a property.).freeze,
      domain: "rdf:Property".freeze,
      isDefinedBy: "rdfs:".freeze,
      label: "subPropertyOf".freeze,
      range: "rdf:Property".freeze,
      type: "rdf:Property".freeze
  end
end
