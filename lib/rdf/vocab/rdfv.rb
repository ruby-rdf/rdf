# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/1999/02/22-rdf-syntax-ns#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  #   #
  #   # This is the RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts.
  #   class RDFV < RDF::StrictVocabulary
  #     # The class of containers of alternatives.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Alt
  #
  #     # The class of unordered containers.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Bag
  #
  #     # A class representing a compound literal.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :CompoundLiteral
  #
  #     # The class of RDF Lists.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :List
  #
  #     # The class of RDF properties.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Property
  #
  #     # The class of ordered containers.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Seq
  #
  #     # The class of RDF statements.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Statement
  #
  #     # The direction component of a CompoundLiteral.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :direction
  #
  #     # The first item in the subject RDF list.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :first
  #
  #     # The object of the subject RDF statement.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :object
  #
  #     # The language component of a CompoundLiteral.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :language
  #
  #     # The predicate of the subject RDF statement.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :predicate
  #
  #     # The rest of the subject RDF list after the first item.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :rest
  #
  #     # The subject of the subject RDF statement.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :subject
  #
  #     # The subject is an instance of a class.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :type
  #
  #     # Idiomatic property used for structured values.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :value
  #
  #     # The datatype of RDF literals storing fragments of HTML content.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :HTML
  #
  #     # The datatype of RDF literals storing JSON content.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :JSON
  #
  #     # The class of plain (i.e. untyped) literal values, as used in RIF and OWL 2.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :PlainLiteral
  #
  #     # The datatype of XML literal values.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :XMLLiteral
  #
  #     # The datatype of language-tagged string values.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :langString
  #
  #     # RDF/XML node element.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :Description
  #
  #     # RDF/XML attribute creating a Reification.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :ID
  #
  #     # RDF/XML attribute declaring subject.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :about
  #
  #     # RDF/XML literal datatype.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :datatype
  #
  #     # RDF/XML container membership list element.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :li
  #
  #     # The empty list, with no items in it. If the rest of a list is nil then the list has no more items in it.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :nil
  #
  #     # RDF/XML Blank Node identifier.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :nodeID
  #
  #     # Parse type for RDF/XML, either Collection, Literal or Resource.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :parseType
  #
  #     # RDF/XML attribute declaring object.
  #     # @return [RDF::Vocabulary::Term]
  #     # @attr_reader :resource
  #   end
  RDFV = Class.new(RDF::StrictVocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")) do

    class << self
      def name; "RDF"; end
      alias_method :__name__, :name
    end

    # Ontology definition
    ontology :"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "dc11:description": %(This is the RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts.).freeze,
      "dc11:title": %(The RDF Concepts Vocabulary \(RDF\)).freeze,
      type: "owl:Ontology".freeze

    # Class definitions
    term :Alt,
      comment: %(The class of containers of alternatives.).freeze,
      label: "Alt".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Container".freeze,
      type: "rdfs:Class".freeze
    term :Bag,
      comment: %(The class of unordered containers.).freeze,
      label: "Bag".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Container".freeze,
      type: "rdfs:Class".freeze
    term :CompoundLiteral,
      comment: %(A class representing a compound literal.).freeze,
      label: "CompoundLiteral".freeze,
      isDefinedBy: %(http://www.w3.org/1999/02/22-rdf-syntax-ns#).freeze,
      subClassOf: "rdfs:Class".freeze,
      type: "rdfs:Class".freeze
    term :List,
      comment: %(The class of RDF Lists.).freeze,
      label: "List".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Property,
      comment: %(The class of RDF properties.).freeze,
      label: "Property".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Seq,
      comment: %(The class of ordered containers.).freeze,
      label: "Seq".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Container".freeze,
      type: "rdfs:Class".freeze
    term :Statement,
      comment: %(The class of RDF statements.).freeze,
      label: "Statement".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :direction,
      comment: %(The direction component of a CompoundLiteral.).freeze,
      domain: "rdf:CompoundLiteral".freeze,
      label: "direction".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(http://www.w3.org/1999/02/22-rdf-syntax-ns#).freeze,
      type: "rdf:Property".freeze
    property :first,
      comment: %(The first item in the subject RDF list.).freeze,
      domain: "rdf:List".freeze,
      label: "first".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :object,
      comment: %(The object of the subject RDF statement.).freeze,
      domain: "rdf:Statement".freeze,
      label: "object".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :language,
      comment: %(The language component of a CompoundLiteral.).freeze,
      domain: "rdf:CompoundLiteral".freeze,
      label: "language".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(http://www.w3.org/1999/02/22-rdf-syntax-ns#).freeze,
      type: "rdf:Property".freeze
    property :predicate,
      comment: %(The predicate of the subject RDF statement.).freeze,
      domain: "rdf:Statement".freeze,
      label: "predicate".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :rest,
      comment: %(The rest of the subject RDF list after the first item.).freeze,
      domain: "rdf:List".freeze,
      label: "rest".freeze,
      range: "rdf:List".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :subject,
      comment: %(The subject of the subject RDF statement.).freeze,
      domain: "rdf:Statement".freeze,
      label: "subject".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :type,
      comment: %(The subject is an instance of a class.).freeze,
      domain: "rdfs:Resource".freeze,
      label: "type".freeze,
      range: "rdfs:Class".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze
    property :value,
      comment: %(Idiomatic property used for structured values.).freeze,
      domain: "rdfs:Resource".freeze,
      label: "value".freeze,
      range: "rdfs:Resource".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:Property".freeze

    # Datatype definitions
    term :HTML,
      comment: %(The datatype of RDF literals storing fragments of HTML content).freeze,
      label: "HTML".freeze,
      isDefinedBy: %(rdf:).freeze,
      "rdfs:seeAlso": %(http://www.w3.org/TR/rdf11-concepts/#section-html).freeze,
      subClassOf: "rdfs:Literal".freeze,
      type: "rdfs:Datatype".freeze
    property :JSON,
      comment: %(The datatype of RDF literals storing JSON content.).freeze,
      label: "JSON".freeze,
      isDefinedBy: %(http://www.w3.org/1999/02/22-rdf-syntax-ns#).freeze,
      type: "rdfs:Datatype".freeze
    term :PlainLiteral,
      comment: %(The class of plain \(i.e. untyped\) literal values, as used in RIF and OWL 2).freeze,
      label: "PlainLiteral".freeze,
      isDefinedBy: %(rdf:).freeze,
      "rdfs:seeAlso": %(http://www.w3.org/TR/rdf-plain-literal/).freeze,
      subClassOf: "rdfs:Literal".freeze,
      type: "rdfs:Datatype".freeze
    term :XMLLiteral,
      comment: %(The datatype of XML literal values.).freeze,
      label: "XMLLiteral".freeze,
      isDefinedBy: %(rdf:).freeze,
      subClassOf: "rdfs:Literal".freeze,
      type: "rdfs:Datatype".freeze
    term :langString,
      comment: %(The datatype of language-tagged string values).freeze,
      label: "langString".freeze,
      isDefinedBy: %(rdf:).freeze,
      "rdfs:seeAlso": %(http://www.w3.org/TR/rdf11-concepts/#section-Graph-Literal).freeze,
      subClassOf: "rdfs:Literal".freeze,
      type: "rdfs:Datatype".freeze

    # Extra definitions
   term :Description,
      comment: %(RDF/XML node element).freeze,
      label: "Description".freeze
    term :ID,
      comment: %(RDF/XML attribute creating a Reification).freeze,
      label: "ID".freeze
    term :about,
      comment: %(RDF/XML attribute declaring subject).freeze,
      label: "about".freeze
    term :datatype,
      comment: %(RDF/XML literal datatype).freeze,
      label: "datatype".freeze
    term :li,
      comment: %(RDF/XML container membership list element).freeze,
      label: "li".freeze
    term :nil,
      comment: %(The empty list, with no items in it. If the rest of a list is nil then the list has no more items in it.).freeze,
      label: "nil".freeze,
      isDefinedBy: %(rdf:).freeze,
      type: "rdf:List".freeze
    term :nodeID,
      comment: %(RDF/XML Blank Node identifier).freeze,
      label: "nodeID".freeze
    term :parseType,
      comment: %(Parse type for RDF/XML, either Collection, Literal or Resource).freeze,
      label: "parseType".freeze
    term :resource,
      comment: %(RDF/XML attribute declaring object).freeze,
      label: "resource".freeze
  end
end
