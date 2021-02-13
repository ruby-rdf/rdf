# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2002/07/owl#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2002/07/owl#>
  #   #
  #   # This ontology partially describes the built-in classes and   properties that together form the basis of the RDF/XML syntax of OWL 2.   The content of this ontology is based on Tables 6.1 and 6.2   in Section 6.4 of the OWL 2 RDF-Based Semantics specification,   available at http://www.w3.org/TR/owl2-rdf-based-semantics/.   Please note that those tables do not include the different annotations   (labels, comments and rdfs:isDefinedBy links) used in this file.   Also note that the descriptions provided in this ontology do not   provide a complete and correct formal description of either the syntax   or the semantics of the introduced terms (please see the OWL 2   recommendations for the complete and normative specifications).   Furthermore, the information provided by this ontology may be   misleading if not used with care. This ontology SHOULD NOT be imported   into OWL ontologies. Importing this file into an OWL 2 DL ontology   will cause it to become an OWL 2 Full ontology and may have other,   unexpected, consequences.    
  #   class OWL < RDF::StrictVocabulary
  #     # The class of collections of pairwise different individuals.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :AllDifferent
  #
  #     # The class of collections of pairwise disjoint classes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :AllDisjointClasses
  #
  #     # The class of collections of pairwise disjoint properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :AllDisjointProperties
  #
  #     # The class of annotated annotations for which the RDF serialization consists of an annotated subject, predicate and object.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Annotation
  #
  #     # The class of annotation properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :AnnotationProperty
  #
  #     # The class of asymmetric properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :AsymmetricProperty
  #
  #     # The class of annotated axioms for which the RDF serialization consists of an annotated subject, predicate and object.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Axiom
  #
  #     # The class of OWL classes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Class
  #
  #     # The class of OWL data ranges, which are special kinds of datatypes. Note: The use of the IRI owl:DataRange has been deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used instead.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :DataRange
  #
  #     # The class of data properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :DatatypeProperty
  #
  #     # The class of deprecated classes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :DeprecatedClass
  #
  #     # The class of deprecated properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :DeprecatedProperty
  #
  #     # The class of functional properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :FunctionalProperty
  #
  #     # The class of inverse-functional properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :InverseFunctionalProperty
  #
  #     # The class of irreflexive properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :IrreflexiveProperty
  #
  #     # The class of named individuals.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NamedIndividual
  #
  #     # The class of negative property assertions.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :NegativePropertyAssertion
  #
  #     # This is the empty class.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Nothing
  #
  #     # The class of object properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ObjectProperty
  #
  #     # The class of ontologies.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Ontology
  #
  #     # The class of ontology properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :OntologyProperty
  #
  #     # The class of reflexive properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :ReflexiveProperty
  #
  #     # The class of property restrictions.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Restriction
  #
  #     # The class of symmetric properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :SymmetricProperty
  #
  #     # The class of OWL individuals.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :Thing
  #
  #     # The class of transitive properties.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :TransitiveProperty
  #
  #     # The property that determines the class that a universal property restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :allValuesFrom
  #
  #     # The property that determines the predicate of an annotated axiom or annotated annotation.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :annotatedProperty
  #
  #     # The property that determines the subject of an annotated axiom or annotated annotation.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :annotatedSource
  #
  #     # The property that determines the object of an annotated axiom or annotated annotation.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :annotatedTarget
  #
  #     # The property that determines the predicate of a negative property assertion.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :assertionProperty
  #
  #     # The annotation property that indicates that a given ontology is backward compatible with another ontology.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :backwardCompatibleWith
  #
  #     # The data property that does not relate any individual to any data value.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :bottomDataProperty
  #
  #     # The object property that does not relate any two individuals.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :bottomObjectProperty
  #
  #     # The property that determines the cardinality of an exact cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :cardinality
  #
  #     # The property that determines that a given class is the complement of another class.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :complementOf
  #
  #     # The property that determines that a given data range is the complement of another data range with respect to the data domain.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :datatypeComplementOf
  #
  #     # The annotation property that indicates that a given entity has been deprecated.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :deprecated
  #
  #     # The property that determines that two given individuals are different.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :differentFrom
  #
  #     # The property that determines that a given class is equivalent to the disjoint union of a collection of other classes.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :disjointUnionOf
  #
  #     # The property that determines that two given classes are disjoint.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :disjointWith
  #
  #     # The property that determines the collection of pairwise different individuals in a owl:AllDifferent axiom.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :distinctMembers
  #
  #     # The property that determines that two given classes are equivalent, and that is used to specify datatype definitions.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :equivalentClass
  #
  #     # The property that determines that two given properties are equivalent.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :equivalentProperty
  #
  #     # The property that determines the collection of properties that jointly build a key.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :hasKey
  #
  #     # The property that determines the property that a self restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :hasSelf
  #
  #     # The property that determines the individual that a has-value restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :hasValue
  #
  #     # The property that is used for importing other ontologies into a given ontology.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :imports
  #
  #     # The annotation property that indicates that a given ontology is incompatible with another ontology.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :incompatibleWith
  #
  #     # The property that determines the collection of classes or data ranges that build an intersection.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :intersectionOf
  #
  #     # The property that determines that two given properties are inverse.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :inverseOf
  #
  #     # The property that determines the cardinality of a maximum cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :maxCardinality
  #
  #     # The property that determines the cardinality of a maximum qualified cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :maxQualifiedCardinality
  #
  #     # The property that determines the collection of members in either a owl:AllDifferent, owl:AllDisjointClasses or owl:AllDisjointProperties axiom.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :members
  #
  #     # The property that determines the cardinality of a minimum cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :minCardinality
  #
  #     # The property that determines the cardinality of a minimum qualified cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :minQualifiedCardinality
  #
  #     # The property that determines the class that a qualified object cardinality restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :onClass
  #
  #     # The property that determines the data range that a qualified data cardinality restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :onDataRange
  #
  #     # The property that determines the datatype that a datatype restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :onDatatype
  #
  #     # The property that determines the n-tuple of properties that a property restriction on an n-ary data range refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :onProperties
  #
  #     # The property that determines the property that a property restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :onProperty
  #
  #     # The property that determines the collection of individuals or data values that build an enumeration.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :oneOf
  #
  #     # The annotation property that indicates the predecessor ontology of a given ontology.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :priorVersion
  #
  #     # The property that determines the n-tuple of properties that build a sub property chain of a given property.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :propertyChainAxiom
  #
  #     # The property that determines that two given properties are disjoint.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :propertyDisjointWith
  #
  #     # The property that determines the cardinality of an exact qualified cardinality restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :qualifiedCardinality
  #
  #     # The property that determines that two given individuals are equal.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :sameAs
  #
  #     # The property that determines the class that an existential property restriction refers to.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :someValuesFrom
  #
  #     # The property that determines the subject of a negative property assertion.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :sourceIndividual
  #
  #     # The property that determines the object of a negative object property assertion.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :targetIndividual
  #
  #     # The property that determines the value of a negative data property assertion.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :targetValue
  #
  #     # The data property that relates every individual to every data value.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :topDataProperty
  #
  #     # The object property that relates every two individuals.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :topObjectProperty
  #
  #     # The property that determines the collection of classes or data ranges that build a union.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :unionOf
  #
  #     # The property that identifies the version IRI of an ontology.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :versionIRI
  #
  #     # The annotation property that provides version information for an ontology or another OWL construct.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :versionInfo
  #
  #     # The property that determines the collection of facet-value pairs that define a datatype restriction.
  #     # @return [RDF::Vocabulary::Term]
  #     attr_reader :withRestrictions
  #
  #   end
  OWL = Class.new(RDF::StrictVocabulary("http://www.w3.org/2002/07/owl#")) do

    # Ontology definition
    ontology :"http://www.w3.org/2002/07/owl#",
      comment: "\r\n  This ontology partially describes the built-in classes and\r\n  properties that together form the basis of the RDF/XML syntax of OWL 2.\r\n  The content of this ontology is based on Tables 6.1 and 6.2\r\n  in Section 6.4 of the OWL 2 RDF-Based Semantics specification,\r\n  available at http://www.w3.org/TR/owl2-rdf-based-semantics/.\r\n  Please note that those tables do not include the different annotations\r\n  (labels, comments and rdfs:isDefinedBy links) used in this file.\r\n  Also note that the descriptions provided in this ontology do not\r\n  provide a complete and correct formal description of either the syntax\r\n  or the semantics of the introduced terms (please see the OWL 2\r\n  recommendations for the complete and normative specifications).\r\n  Furthermore, the information provided by this ontology may be\r\n  misleading if not used with care. This ontology SHOULD NOT be imported\r\n  into OWL ontologies. Importing this file into an OWL 2 DL ontology\r\n  will cause it to become an OWL 2 Full ontology and may have other,\r\n  unexpected, consequences.\r\n   ".freeze,
      "http://purl.org/dc/elements/1.1/title": "The OWL 2 Schema vocabulary (OWL 2)".freeze,
      "http://www.w3.org/2000/01/rdf-schema#seeAlso": ["http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes".freeze, "http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties".freeze],
      "http://www.w3.org/2002/07/owl#imports": "http://www.w3.org/2000/01/rdf-schema".freeze,
      "http://www.w3.org/2002/07/owl#versionIRI": "http://www.w3.org/2002/07/owl".freeze,
      "http://www.w3.org/2002/07/owl#versionInfo": "$Date: 2009/11/15 10:54:12 $".freeze,
      "http://www.w3.org/2003/g/data-view#namespaceTransformation": "http://dev.w3.org/cvsweb/2009/owl-grddl/owx2rdf.xsl".freeze,
      isDefinedBy: ["http://www.w3.org/TR/owl2-mapping-to-rdf/".freeze, "http://www.w3.org/TR/owl2-rdf-based-semantics/".freeze, "http://www.w3.org/TR/owl2-syntax/".freeze],
      type: "http://www.w3.org/2002/07/owl#Ontology".freeze

    # Class definitions
    term :AllDifferent,
      comment: "The class of collections of pairwise different individuals.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "AllDifferent".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :AllDisjointClasses,
      comment: "The class of collections of pairwise disjoint classes.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "AllDisjointClasses".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :AllDisjointProperties,
      comment: "The class of collections of pairwise disjoint properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "AllDisjointProperties".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Annotation,
      comment: "The class of annotated annotations for which the RDF serialization consists of an annotated subject, predicate and object.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Annotation".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :AnnotationProperty,
      comment: "The class of annotation properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "AnnotationProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :AsymmetricProperty,
      comment: "The class of asymmetric properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "AsymmetricProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Axiom,
      comment: "The class of annotated axioms for which the RDF serialization consists of an annotated subject, predicate and object.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Axiom".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Class,
      comment: "The class of OWL classes.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Class".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :DataRange,
      comment: "The class of OWL data ranges, which are special kinds of datatypes. Note: The use of the IRI owl:DataRange has been deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used instead.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "DataRange".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :DatatypeProperty,
      comment: "The class of data properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "DatatypeProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :DeprecatedClass,
      comment: "The class of deprecated classes.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "DeprecatedClass".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :DeprecatedProperty,
      comment: "The class of deprecated properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "DeprecatedProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :FunctionalProperty,
      comment: "The class of functional properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "FunctionalProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :InverseFunctionalProperty,
      comment: "The class of inverse-functional properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "InverseFunctionalProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :IrreflexiveProperty,
      comment: "The class of irreflexive properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "IrreflexiveProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :NamedIndividual,
      comment: "The class of named individuals.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "NamedIndividual".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :NegativePropertyAssertion,
      comment: "The class of negative property assertions.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "NegativePropertyAssertion".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Nothing,
      comment: "This is the empty class.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Nothing".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/2002/07/owl#Class".freeze
    term :ObjectProperty,
      comment: "The class of object properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "ObjectProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Ontology,
      comment: "The class of ontologies.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Ontology".freeze,
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :OntologyProperty,
      comment: "The class of ontology properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "OntologyProperty".freeze,
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :ReflexiveProperty,
      comment: "The class of reflexive properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "ReflexiveProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Restriction,
      comment: "The class of property restrictions.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Restriction".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#Class".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :SymmetricProperty,
      comment: "The class of symmetric properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "SymmetricProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze
    term :Thing,
      comment: "The class of OWL individuals.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "Thing".freeze,
      type: "http://www.w3.org/2002/07/owl#Class".freeze
    term :TransitiveProperty,
      comment: "The class of transitive properties.".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "TransitiveProperty".freeze,
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/2000/01/rdf-schema#Class".freeze

    # Property definitions
    property :allValuesFrom,
      comment: "The property that determines the class that a universal property restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "allValuesFrom".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :annotatedProperty,
      comment: "The property that determines the predicate of an annotated axiom or annotated annotation.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "annotatedProperty".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :annotatedSource,
      comment: "The property that determines the subject of an annotated axiom or annotated annotation.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "annotatedSource".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :annotatedTarget,
      comment: "The property that determines the object of an annotated axiom or annotated annotation.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "annotatedTarget".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :assertionProperty,
      comment: "The property that determines the predicate of a negative property assertion.".freeze,
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "assertionProperty".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :backwardCompatibleWith,
      comment: "The annotation property that indicates that a given ontology is backward compatible with another ontology.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "backwardCompatibleWith".freeze,
      range: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty".freeze, "http://www.w3.org/2002/07/owl#OntologyProperty".freeze]
    property :bottomDataProperty,
      comment: "The data property that does not relate any individual to any data value.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "bottomDataProperty".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Literal".freeze,
      type: "http://www.w3.org/2002/07/owl#DatatypeProperty".freeze
    property :bottomObjectProperty,
      comment: "The object property that does not relate any two individuals.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "bottomObjectProperty".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze
    property :cardinality,
      comment: "The property that determines the cardinality of an exact cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "cardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :complementOf,
      comment: "The property that determines that a given class is the complement of another class.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "complementOf".freeze,
      range: "http://www.w3.org/2002/07/owl#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :datatypeComplementOf,
      comment: "The property that determines that a given data range is the complement of another data range with respect to the data domain.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "datatypeComplementOf".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :deprecated,
      comment: "The annotation property that indicates that a given entity has been deprecated.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "deprecated".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2002/07/owl#AnnotationProperty".freeze
    property :differentFrom,
      comment: "The property that determines that two given individuals are different.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "differentFrom".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :disjointUnionOf,
      comment: "The property that determines that a given class is equivalent to the disjoint union of a collection of other classes.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "disjointUnionOf".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :disjointWith,
      comment: "The property that determines that two given classes are disjoint.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "disjointWith".freeze,
      range: "http://www.w3.org/2002/07/owl#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :distinctMembers,
      comment: "The property that determines the collection of pairwise different individuals in a owl:AllDifferent axiom.".freeze,
      domain: "http://www.w3.org/2002/07/owl#AllDifferent".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "distinctMembers".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :equivalentClass,
      comment: "The property that determines that two given classes are equivalent, and that is used to specify datatype definitions.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "equivalentClass".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :equivalentProperty,
      comment: "The property that determines that two given properties are equivalent.".freeze,
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "equivalentProperty".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :hasKey,
      comment: "The property that determines the collection of properties that jointly build a key.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "hasKey".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :hasSelf,
      comment: "The property that determines the property that a self restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "hasSelf".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :hasValue,
      comment: "The property that determines the individual that a has-value restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "hasValue".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :imports,
      comment: "The property that is used for importing other ontologies into a given ontology.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "imports".freeze,
      range: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      type: "http://www.w3.org/2002/07/owl#OntologyProperty".freeze
    property :incompatibleWith,
      comment: "The annotation property that indicates that a given ontology is incompatible with another ontology.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "incompatibleWith".freeze,
      range: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty".freeze, "http://www.w3.org/2002/07/owl#OntologyProperty".freeze]
    property :intersectionOf,
      comment: "The property that determines the collection of classes or data ranges that build an intersection.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "intersectionOf".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :inverseOf,
      comment: "The property that determines that two given properties are inverse.".freeze,
      domain: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "inverseOf".freeze,
      range: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :maxCardinality,
      comment: "The property that determines the cardinality of a maximum cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "maxCardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :maxQualifiedCardinality,
      comment: "The property that determines the cardinality of a maximum qualified cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "maxQualifiedCardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :members,
      comment: "The property that determines the collection of members in either a owl:AllDifferent, owl:AllDisjointClasses or owl:AllDisjointProperties axiom.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "members".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :minCardinality,
      comment: "The property that determines the cardinality of a minimum cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "minCardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :minQualifiedCardinality,
      comment: "The property that determines the cardinality of a minimum qualified cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "minQualifiedCardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :onClass,
      comment: "The property that determines the class that a qualified object cardinality restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "onClass".freeze,
      range: "http://www.w3.org/2002/07/owl#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :onDataRange,
      comment: "The property that determines the data range that a qualified data cardinality restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "onDataRange".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :onDatatype,
      comment: "The property that determines the datatype that a datatype restriction refers to.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "onDatatype".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :onProperties,
      comment: "The property that determines the n-tuple of properties that a property restriction on an n-ary data range refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "onProperties".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :onProperty,
      comment: "The property that determines the property that a property restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "onProperty".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :oneOf,
      comment: "The property that determines the collection of individuals or data values that build an enumeration.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "oneOf".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :priorVersion,
      comment: "The annotation property that indicates the predecessor ontology of a given ontology.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "priorVersion".freeze,
      range: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty".freeze, "http://www.w3.org/2002/07/owl#OntologyProperty".freeze]
    property :propertyChainAxiom,
      comment: "The property that determines the n-tuple of properties that build a sub property chain of a given property.".freeze,
      domain: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "propertyChainAxiom".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :propertyDisjointWith,
      comment: "The property that determines that two given properties are disjoint.".freeze,
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "propertyDisjointWith".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :qualifiedCardinality,
      comment: "The property that determines the cardinality of an exact qualified cardinality restriction.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "qualifiedCardinality".freeze,
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :sameAs,
      comment: "The property that determines that two given individuals are equal.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "sameAs".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :someValuesFrom,
      comment: "The property that determines the class that an existential property restriction refers to.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Restriction".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "someValuesFrom".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :sourceIndividual,
      comment: "The property that determines the subject of a negative property assertion.".freeze,
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "sourceIndividual".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :targetIndividual,
      comment: "The property that determines the object of a negative object property assertion.".freeze,
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "targetIndividual".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :targetValue,
      comment: "The property that determines the value of a negative data property assertion.".freeze,
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "targetValue".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Literal".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :topDataProperty,
      comment: "The data property that relates every individual to every data value.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "topDataProperty".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Literal".freeze,
      type: "http://www.w3.org/2002/07/owl#DatatypeProperty".freeze
    property :topObjectProperty,
      comment: "The object property that relates every two individuals.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Thing".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "topObjectProperty".freeze,
      range: "http://www.w3.org/2002/07/owl#Thing".freeze,
      type: "http://www.w3.org/2002/07/owl#ObjectProperty".freeze
    property :unionOf,
      comment: "The property that determines the collection of classes or data ranges that build a union.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Class".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "unionOf".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
    property :versionIRI,
      comment: "The property that identifies the version IRI of an ontology.".freeze,
      domain: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "versionIRI".freeze,
      range: "http://www.w3.org/2002/07/owl#Ontology".freeze,
      type: "http://www.w3.org/2002/07/owl#OntologyProperty".freeze
    property :versionInfo,
      comment: "The annotation property that provides version information for an ontology or another OWL construct.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "versionInfo".freeze,
      range: "http://www.w3.org/2000/01/rdf-schema#Resource".freeze,
      type: "http://www.w3.org/2002/07/owl#AnnotationProperty".freeze
    property :withRestrictions,
      comment: "The property that determines the collection of facet-value pairs that define a datatype restriction.".freeze,
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype".freeze,
      isDefinedBy: "http://www.w3.org/2002/07/owl#".freeze,
      label: "withRestrictions".freeze,
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List".freeze,
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property".freeze
  end
end
