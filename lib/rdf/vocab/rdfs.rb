# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2000/01/rdf-schema#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2000/01/rdf-schema#>
  #   #
  #   # The RDF Schema vocabulary (RDFS)
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
      "http://purl.org/dc/elements/1.1/title": "The RDF Schema vocabulary (RDFS)".freeze,
      "http://www.w3.org/2000/01/rdf-schema#seeAlso": "http://www.w3.org/2000/01/rdf-schema-more".freeze,
      type: "http://www.w3.org/2002/07/owl#Ontology".freeze

    # Class definitions
    term :Class,
      comment: "The class of classes.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "Class".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Container,
      comment: "The class of RDF containers.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "Container".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :ContainerMembershipProperty,
      comment: "The class of container membership properties, rdf:_1, rdf:_2, ...,\n                    all of which are sub-properties of 'member'.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "ContainerMembershipProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Datatype,
      comment: "The class of RDF datatypes.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "Datatype".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Literal,
      comment: "The class of literal values, eg. textual strings and integers.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "Literal".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Resource,
      comment: "The class resource, everything.".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze

    # Property definitions
    property :comment,
      comment: "A description of the subject resource.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "comment".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Literal".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :domain,
      comment: "A domain of the subject property.".freeze,
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "domain".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :isDefinedBy,
      comment: "The defininition of the subject resource.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "isDefinedBy".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      subPropertyOf: "http://www.w3.org/2000/01/rdf-schema#seeAlso".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :label,
      comment: "A human-readable name for the subject.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "label".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Literal".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :member,
      comment: "A member of the subject resource.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "member".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :range,
      comment: "A range of the subject property.".freeze,
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "range".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :seeAlso,
      comment: "Further information about the subject resource.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "seeAlso".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :subClassOf,
      comment: "The subject is a subclass of a class.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "subClassOf".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :subPropertyOf,
      comment: "The subject is a subproperty of a property.".freeze,
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      isDefinedBy: "http://www.w3.org/2000/01/rdf-schema#".freeze,
      label: "subPropertyOf".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
  end
end
