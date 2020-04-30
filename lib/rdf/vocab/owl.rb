# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# This file generated automatically using rdf vocabulary format from http://www.w3.org/2002/07/owl#
require 'rdf'
module RDF
  # @!parse
  #   # Vocabulary for <http://www.w3.org/2002/07/owl#>
  #   #
  #   # The OWL 2 Schema vocabulary (OWL 2)
  #   #
  #   #    This ontology partially describes the built-in classes and   properties that together form the basis of the RDF/XML syntax of OWL 2.   The content of this ontology is based on Tables 6.1 and 6.2   in Section 6.4 of the OWL 2 RDF-Based Semantics specification,   available at http://www.w3.org/TR/owl2-rdf-based-semantics/.   Please note that those tables do not include the different annotations   (labels, comments and rdfs:isDefinedBy links) used in this file.   Also note that the descriptions provided in this ontology do not   provide a complete and correct formal description of either the syntax   or the semantics of the introduced terms (please see the OWL 2   recommendations for the complete and normative specifications).   Furthermore, the information provided by this ontology may be   misleading if not used with care. This ontology SHOULD NOT be imported   into OWL ontologies. Importing this file into an OWL 2 DL ontology   will cause it to become an OWL 2 Full ontology and may have other,   unexpected, consequences.    
  #   # @version $Date: 2009/11/15 10:54:12 $
  #   # @see http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties
  #   # @see http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes
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
      comment: %(
  This ontology partially describes the built-in classes and
  properties that together form the basis of the RDF/XML syntax of OWL 2.
  The content of this ontology is based on Tables 6.1 and 6.2
  in Section 6.4 of the OWL 2 RDF-Based Semantics specification,
  available at http://www.w3.org/TR/owl2-rdf-based-semantics/.
  Please note that those tables do not include the different annotations
  \(labels, comments and rdfs:isDefinedBy links\) used in this file.
  Also note that the descriptions provided in this ontology do not
  provide a complete and correct formal description of either the syntax
  or the semantics of the introduced terms \(please see the OWL 2
  recommendations for the complete and normative specifications\).
  Furthermore, the information provided by this ontology may be
  misleading if not used with care. This ontology SHOULD NOT be imported
  into OWL ontologies. Importing this file into an OWL 2 DL ontology
  will cause it to become an OWL 2 Full ontology and may have other,
  unexpected, consequences.
   ).freeze,
      "dc11:title": "The OWL 2 Schema vocabulary (OWL 2)".freeze,
      "http://www.w3.org/2003/g/data-view#namespaceTransformation": "http://dev.w3.org/cvsweb/2009/owl-grddl/owx2rdf.xsl".freeze,
      isDefinedBy: ["http://www.w3.org/TR/owl2-mapping-to-rdf/".freeze, "http://www.w3.org/TR/owl2-rdf-based-semantics/".freeze, "http://www.w3.org/TR/owl2-syntax/".freeze],
      "owl:imports": "http://www.w3.org/2000/01/rdf-schema".freeze,
      "owl:versionIRI": "http://www.w3.org/2002/07/owl".freeze,
      "owl:versionInfo": "$Date: 2009/11/15 10:54:12 $".freeze,
      "rdfs:seeAlso": ["http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes".freeze, "http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties".freeze],
      type: "owl:Ontology".freeze

    # Class definitions
    term :AllDifferent,
      comment: %(The class of collections of pairwise different individuals.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "AllDifferent".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :AllDisjointClasses,
      comment: %(The class of collections of pairwise disjoint classes.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "AllDisjointClasses".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :AllDisjointProperties,
      comment: %(The class of collections of pairwise disjoint properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "AllDisjointProperties".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Annotation,
      comment: %(The class of annotated annotations for which the RDF serialization consists of an annotated subject, predicate and object.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Annotation".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :AnnotationProperty,
      comment: %(The class of annotation properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "AnnotationProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :AsymmetricProperty,
      comment: %(The class of asymmetric properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "AsymmetricProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze
    term :Axiom,
      comment: %(The class of annotated axioms for which the RDF serialization consists of an annotated subject, predicate and object.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Axiom".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Class,
      comment: %(The class of OWL classes.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Class".freeze,
      subClassOf: "rdfs:Class".freeze,
      type: "rdfs:Class".freeze
    term :DataRange,
      comment: %(The class of OWL data ranges, which are special kinds of datatypes. Note: The use of the IRI owl:DataRange has been deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used instead.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "DataRange".freeze,
      subClassOf: "rdfs:Datatype".freeze,
      type: "rdfs:Class".freeze
    term :DatatypeProperty,
      comment: %(The class of data properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "DatatypeProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :DeprecatedClass,
      comment: %(The class of deprecated classes.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "DeprecatedClass".freeze,
      subClassOf: "rdfs:Class".freeze,
      type: "rdfs:Class".freeze
    term :DeprecatedProperty,
      comment: %(The class of deprecated properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "DeprecatedProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :FunctionalProperty,
      comment: %(The class of functional properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "FunctionalProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :InverseFunctionalProperty,
      comment: %(The class of inverse-functional properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "InverseFunctionalProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze
    term :IrreflexiveProperty,
      comment: %(The class of irreflexive properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "IrreflexiveProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze
    term :NamedIndividual,
      comment: %(The class of named individuals.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "NamedIndividual".freeze,
      subClassOf: "owl:Thing".freeze,
      type: "rdfs:Class".freeze
    term :NegativePropertyAssertion,
      comment: %(The class of negative property assertions.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "NegativePropertyAssertion".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :Nothing,
      comment: %(This is the empty class.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Nothing".freeze,
      subClassOf: "owl:Thing".freeze,
      type: "owl:Class".freeze
    term :ObjectProperty,
      comment: %(The class of object properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "ObjectProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :Ontology,
      comment: %(The class of ontologies.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Ontology".freeze,
      subClassOf: "rdfs:Resource".freeze,
      type: "rdfs:Class".freeze
    term :OntologyProperty,
      comment: %(The class of ontology properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "OntologyProperty".freeze,
      subClassOf: "rdf:Property".freeze,
      type: "rdfs:Class".freeze
    term :ReflexiveProperty,
      comment: %(The class of reflexive properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "ReflexiveProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze
    term :Restriction,
      comment: %(The class of property restrictions.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Restriction".freeze,
      subClassOf: "owl:Class".freeze,
      type: "rdfs:Class".freeze
    term :SymmetricProperty,
      comment: %(The class of symmetric properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "SymmetricProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze
    term :Thing,
      comment: %(The class of OWL individuals.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "Thing".freeze,
      type: "owl:Class".freeze
    term :TransitiveProperty,
      comment: %(The class of transitive properties.).freeze,
      isDefinedBy: "owl:".freeze,
      label: "TransitiveProperty".freeze,
      subClassOf: "owl:ObjectProperty".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :allValuesFrom,
      comment: %(The property that determines the class that a universal property restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "allValuesFrom".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :annotatedProperty,
      comment: %(The property that determines the predicate of an annotated axiom or annotated annotation.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "annotatedProperty".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :annotatedSource,
      comment: %(The property that determines the subject of an annotated axiom or annotated annotation.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "annotatedSource".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :annotatedTarget,
      comment: %(The property that determines the object of an annotated axiom or annotated annotation.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "annotatedTarget".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :assertionProperty,
      comment: %(The property that determines the predicate of a negative property assertion.).freeze,
      domain: "owl:NegativePropertyAssertion".freeze,
      isDefinedBy: "owl:".freeze,
      label: "assertionProperty".freeze,
      range: "rdf:Property".freeze,
      type: "rdf:Property".freeze
    property :backwardCompatibleWith,
      comment: %(The annotation property that indicates that a given ontology is backward compatible with another ontology.).freeze,
      domain: "owl:Ontology".freeze,
      isDefinedBy: "owl:".freeze,
      label: "backwardCompatibleWith".freeze,
      range: "owl:Ontology".freeze,
      type: ["owl:AnnotationProperty".freeze, "owl:OntologyProperty".freeze]
    property :bottomDataProperty,
      comment: %(The data property that does not relate any individual to any data value.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "bottomDataProperty".freeze,
      range: "rdfs:Literal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :bottomObjectProperty,
      comment: %(The object property that does not relate any two individuals.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "bottomObjectProperty".freeze,
      range: "owl:Thing".freeze,
      type: "owl:ObjectProperty".freeze
    property :cardinality,
      comment: %(The property that determines the cardinality of an exact cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "cardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :complementOf,
      comment: %(The property that determines that a given class is the complement of another class.).freeze,
      domain: "owl:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "complementOf".freeze,
      range: "owl:Class".freeze,
      type: "rdf:Property".freeze
    property :datatypeComplementOf,
      comment: %(The property that determines that a given data range is the complement of another data range with respect to the data domain.).freeze,
      domain: "rdfs:Datatype".freeze,
      isDefinedBy: "owl:".freeze,
      label: "datatypeComplementOf".freeze,
      range: "rdfs:Datatype".freeze,
      type: "rdf:Property".freeze
    property :deprecated,
      comment: %(The annotation property that indicates that a given entity has been deprecated.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "deprecated".freeze,
      range: "rdfs:Resource".freeze,
      type: "owl:AnnotationProperty".freeze
    property :differentFrom,
      comment: %(The property that determines that two given individuals are different.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "differentFrom".freeze,
      range: "owl:Thing".freeze,
      type: "rdf:Property".freeze
    property :disjointUnionOf,
      comment: %(The property that determines that a given class is equivalent to the disjoint union of a collection of other classes.).freeze,
      domain: "owl:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "disjointUnionOf".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :disjointWith,
      comment: %(The property that determines that two given classes are disjoint.).freeze,
      domain: "owl:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "disjointWith".freeze,
      range: "owl:Class".freeze,
      type: "rdf:Property".freeze
    property :distinctMembers,
      comment: %(The property that determines the collection of pairwise different individuals in a owl:AllDifferent axiom.).freeze,
      domain: "owl:AllDifferent".freeze,
      isDefinedBy: "owl:".freeze,
      label: "distinctMembers".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :equivalentClass,
      comment: %(The property that determines that two given classes are equivalent, and that is used to specify datatype definitions.).freeze,
      domain: "rdfs:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "equivalentClass".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :equivalentProperty,
      comment: %(The property that determines that two given properties are equivalent.).freeze,
      domain: "rdf:Property".freeze,
      isDefinedBy: "owl:".freeze,
      label: "equivalentProperty".freeze,
      range: "rdf:Property".freeze,
      type: "rdf:Property".freeze
    property :hasKey,
      comment: %(The property that determines the collection of properties that jointly build a key.).freeze,
      domain: "owl:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "hasKey".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :hasSelf,
      comment: %(The property that determines the property that a self restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "hasSelf".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :hasValue,
      comment: %(The property that determines the individual that a has-value restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "hasValue".freeze,
      range: "rdfs:Resource".freeze,
      type: "rdf:Property".freeze
    property :imports,
      comment: %(The property that is used for importing other ontologies into a given ontology.).freeze,
      domain: "owl:Ontology".freeze,
      isDefinedBy: "owl:".freeze,
      label: "imports".freeze,
      range: "owl:Ontology".freeze,
      type: "owl:OntologyProperty".freeze
    property :incompatibleWith,
      comment: %(The annotation property that indicates that a given ontology is incompatible with another ontology.).freeze,
      domain: "owl:Ontology".freeze,
      isDefinedBy: "owl:".freeze,
      label: "incompatibleWith".freeze,
      range: "owl:Ontology".freeze,
      type: ["owl:AnnotationProperty".freeze, "owl:OntologyProperty".freeze]
    property :intersectionOf,
      comment: %(The property that determines the collection of classes or data ranges that build an intersection.).freeze,
      domain: "rdfs:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "intersectionOf".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :inverseOf,
      comment: %(The property that determines that two given properties are inverse.).freeze,
      domain: "owl:ObjectProperty".freeze,
      isDefinedBy: "owl:".freeze,
      label: "inverseOf".freeze,
      range: "owl:ObjectProperty".freeze,
      type: "rdf:Property".freeze
    property :maxCardinality,
      comment: %(The property that determines the cardinality of a maximum cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "maxCardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :maxQualifiedCardinality,
      comment: %(The property that determines the cardinality of a maximum qualified cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "maxQualifiedCardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :members,
      comment: %(The property that determines the collection of members in either a owl:AllDifferent, owl:AllDisjointClasses or owl:AllDisjointProperties axiom.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "members".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :minCardinality,
      comment: %(The property that determines the cardinality of a minimum cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "minCardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :minQualifiedCardinality,
      comment: %(The property that determines the cardinality of a minimum qualified cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "minQualifiedCardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :onClass,
      comment: %(The property that determines the class that a qualified object cardinality restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "onClass".freeze,
      range: "owl:Class".freeze,
      type: "rdf:Property".freeze
    property :onDataRange,
      comment: %(The property that determines the data range that a qualified data cardinality restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "onDataRange".freeze,
      range: "rdfs:Datatype".freeze,
      type: "rdf:Property".freeze
    property :onDatatype,
      comment: %(The property that determines the datatype that a datatype restriction refers to.).freeze,
      domain: "rdfs:Datatype".freeze,
      isDefinedBy: "owl:".freeze,
      label: "onDatatype".freeze,
      range: "rdfs:Datatype".freeze,
      type: "rdf:Property".freeze
    property :onProperties,
      comment: %(The property that determines the n-tuple of properties that a property restriction on an n-ary data range refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "onProperties".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :onProperty,
      comment: %(The property that determines the property that a property restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "onProperty".freeze,
      range: "rdf:Property".freeze,
      type: "rdf:Property".freeze
    property :oneOf,
      comment: %(The property that determines the collection of individuals or data values that build an enumeration.).freeze,
      domain: "rdfs:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "oneOf".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :priorVersion,
      comment: %(The annotation property that indicates the predecessor ontology of a given ontology.).freeze,
      domain: "owl:Ontology".freeze,
      isDefinedBy: "owl:".freeze,
      label: "priorVersion".freeze,
      range: "owl:Ontology".freeze,
      type: ["owl:AnnotationProperty".freeze, "owl:OntologyProperty".freeze]
    property :propertyChainAxiom,
      comment: %(The property that determines the n-tuple of properties that build a sub property chain of a given property.).freeze,
      domain: "owl:ObjectProperty".freeze,
      isDefinedBy: "owl:".freeze,
      label: "propertyChainAxiom".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :propertyDisjointWith,
      comment: %(The property that determines that two given properties are disjoint.).freeze,
      domain: "rdf:Property".freeze,
      isDefinedBy: "owl:".freeze,
      label: "propertyDisjointWith".freeze,
      range: "rdf:Property".freeze,
      type: "rdf:Property".freeze
    property :qualifiedCardinality,
      comment: %(The property that determines the cardinality of an exact qualified cardinality restriction.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "qualifiedCardinality".freeze,
      range: "xsd:nonNegativeInteger".freeze,
      type: "rdf:Property".freeze
    property :sameAs,
      comment: %(The property that determines that two given individuals are equal.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "sameAs".freeze,
      range: "owl:Thing".freeze,
      type: "rdf:Property".freeze
    property :someValuesFrom,
      comment: %(The property that determines the class that an existential property restriction refers to.).freeze,
      domain: "owl:Restriction".freeze,
      isDefinedBy: "owl:".freeze,
      label: "someValuesFrom".freeze,
      range: "rdfs:Class".freeze,
      type: "rdf:Property".freeze
    property :sourceIndividual,
      comment: %(The property that determines the subject of a negative property assertion.).freeze,
      domain: "owl:NegativePropertyAssertion".freeze,
      isDefinedBy: "owl:".freeze,
      label: "sourceIndividual".freeze,
      range: "owl:Thing".freeze,
      type: "rdf:Property".freeze
    property :targetIndividual,
      comment: %(The property that determines the object of a negative object property assertion.).freeze,
      domain: "owl:NegativePropertyAssertion".freeze,
      isDefinedBy: "owl:".freeze,
      label: "targetIndividual".freeze,
      range: "owl:Thing".freeze,
      type: "rdf:Property".freeze
    property :targetValue,
      comment: %(The property that determines the value of a negative data property assertion.).freeze,
      domain: "owl:NegativePropertyAssertion".freeze,
      isDefinedBy: "owl:".freeze,
      label: "targetValue".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :topDataProperty,
      comment: %(The data property that relates every individual to every data value.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "topDataProperty".freeze,
      range: "rdfs:Literal".freeze,
      type: "owl:DatatypeProperty".freeze
    property :topObjectProperty,
      comment: %(The object property that relates every two individuals.).freeze,
      domain: "owl:Thing".freeze,
      isDefinedBy: "owl:".freeze,
      label: "topObjectProperty".freeze,
      range: "owl:Thing".freeze,
      type: "owl:ObjectProperty".freeze
    property :unionOf,
      comment: %(The property that determines the collection of classes or data ranges that build a union.).freeze,
      domain: "rdfs:Class".freeze,
      isDefinedBy: "owl:".freeze,
      label: "unionOf".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
    property :versionIRI,
      comment: %(The property that identifies the version IRI of an ontology.).freeze,
      domain: "owl:Ontology".freeze,
      isDefinedBy: "owl:".freeze,
      label: "versionIRI".freeze,
      range: "owl:Ontology".freeze,
      type: "owl:OntologyProperty".freeze
    property :versionInfo,
      comment: %(The annotation property that provides version information for an ontology or another OWL construct.).freeze,
      domain: "rdfs:Resource".freeze,
      isDefinedBy: "owl:".freeze,
      label: "versionInfo".freeze,
      range: "rdfs:Resource".freeze,
      type: "owl:AnnotationProperty".freeze
    property :withRestrictions,
      comment: %(The property that determines the collection of facet-value pairs that define a datatype restriction.).freeze,
      domain: "rdfs:Datatype".freeze,
      isDefinedBy: "owl:".freeze,
      label: "withRestrictions".freeze,
      range: "rdf:List".freeze,
      type: "rdf:Property".freeze
  end
end
