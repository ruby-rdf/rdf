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
  #   #  This ontology partially describes the built-in classes and properties that together form the basis of the RDF/XML syntax of OWL 2. The content of this ontology is based on Tables 6.1 and 6.2 in Section 6.4 of the OWL 2 RDF-Based Semantics specification, available at http://www.w3.org/TR/owl2-rdf-based-semantics/. Please note that those tables do not include the different annotations (labels, comments and rdfs:isDefinedBy links) used in this file. Also note that the descriptions provided in this ontology do not provide a complete and correct formal description of either the syntax or the semantics of the introduced terms (please see the OWL 2 recommendations for the complete and normative specifications). Furthermore, the information provided by this ontology may be misleading if not used with care. This ontology SHOULD NOT be imported into OWL ontologies. Importing this file into an OWL 2 DL ontology will cause it to become an OWL 2 Full ontology and may have other, unexpected, consequences. 
  #   # @version $Date: 2009/11/15 10:54:12 $
  #   # @see http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes
  #   # @see http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties
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
      comment: "\r\n  This ontology partially describes the built-in classes and\r\n  properties that together form the basis of the RDF/XML syntax of OWL 2.\r\n  The content of this ontology is based on Tables 6.1 and 6.2\r\n  in Section 6.4 of the OWL 2 RDF-Based Semantics specification,\r\n  available at http://www.w3.org/TR/owl2-rdf-based-semantics/.\r\n  Please note that those tables do not include the different annotations\r\n  (labels, comments and rdfs:isDefinedBy links) used in this file.\r\n  Also note that the descriptions provided in this ontology do not\r\n  provide a complete and correct formal description of either the syntax\r\n  or the semantics of the introduced terms (please see the OWL 2\r\n  recommendations for the complete and normative specifications).\r\n  Furthermore, the information provided by this ontology may be\r\n  misleading if not used with care. This ontology SHOULD NOT be imported\r\n  into OWL ontologies. Importing this file into an OWL 2 DL ontology\r\n  will cause it to become an OWL 2 Full ontology and may have other,\r\n  unexpected, consequences.\r\n   ",
      "http://purl.org/dc/elements/1.1/title": "The OWL 2 Schema vocabulary (OWL 2)",
      "http://www.w3.org/2000/01/rdf-schema#seeAlso": ["http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes", "http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties"],
      "http://www.w3.org/2002/07/owl#imports": "http://www.w3.org/2000/01/rdf-schema",
      "http://www.w3.org/2002/07/owl#versionIRI": "http://www.w3.org/2002/07/owl",
      "http://www.w3.org/2002/07/owl#versionInfo": "$Date: 2009/11/15 10:54:12 $",
      "http://www.w3.org/2003/g/data-view#namespaceTransformation": "http://dev.w3.org/cvsweb/2009/owl-grddl/owx2rdf.xsl",
      isDefinedBy: ["http://www.w3.org/TR/owl2-mapping-to-rdf/", "http://www.w3.org/TR/owl2-rdf-based-semantics/", "http://www.w3.org/TR/owl2-syntax/"],
      type: "http://www.w3.org/2002/07/owl#Ontology"

    # Class definitions
    term :AllDifferent,
      comment: "The class of collections of pairwise different individuals.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "AllDifferent",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :AllDisjointClasses,
      comment: "The class of collections of pairwise disjoint classes.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "AllDisjointClasses",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :AllDisjointProperties,
      comment: "The class of collections of pairwise disjoint properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "AllDisjointProperties",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Annotation,
      comment: "The class of annotated annotations for which the RDF serialization consists of an annotated subject, predicate and object.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Annotation",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :AnnotationProperty,
      comment: "The class of annotation properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "AnnotationProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :AsymmetricProperty,
      comment: "The class of asymmetric properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "AsymmetricProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Axiom,
      comment: "The class of annotated axioms for which the RDF serialization consists of an annotated subject, predicate and object.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Axiom",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Class,
      comment: "The class of OWL classes.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Class",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :DataRange,
      comment: "The class of OWL data ranges, which are special kinds of datatypes. Note: The use of the IRI owl:DataRange has been deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used instead.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "DataRange",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :DatatypeProperty,
      comment: "The class of data properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "DatatypeProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :DeprecatedClass,
      comment: "The class of deprecated classes.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "DeprecatedClass",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :DeprecatedProperty,
      comment: "The class of deprecated properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "DeprecatedProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :FunctionalProperty,
      comment: "The class of functional properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "FunctionalProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :InverseFunctionalProperty,
      comment: "The class of inverse-functional properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "InverseFunctionalProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :IrreflexiveProperty,
      comment: "The class of irreflexive properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "IrreflexiveProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :NamedIndividual,
      comment: "The class of named individuals.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "NamedIndividual",
      subClassOf: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :NegativePropertyAssertion,
      comment: "The class of negative property assertions.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "NegativePropertyAssertion",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Nothing,
      comment: "This is the empty class.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Nothing",
      subClassOf: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/2002/07/owl#Class"
    term :ObjectProperty,
      comment: "The class of object properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "ObjectProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Ontology,
      comment: "The class of ontologies.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Ontology",
      subClassOf: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :OntologyProperty,
      comment: "The class of ontology properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "OntologyProperty",
      subClassOf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :ReflexiveProperty,
      comment: "The class of reflexive properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "ReflexiveProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Restriction,
      comment: "The class of property restrictions.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Restriction",
      subClassOf: "http://www.w3.org/2002/07/owl#Class",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :SymmetricProperty,
      comment: "The class of symmetric properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "SymmetricProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"
    term :Thing,
      comment: "The class of OWL individuals.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "Thing",
      type: "http://www.w3.org/2002/07/owl#Class"
    term :TransitiveProperty,
      comment: "The class of transitive properties.",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "TransitiveProperty",
      subClassOf: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/2000/01/rdf-schema#Class"

    # Property definitions
    property :allValuesFrom,
      comment: "The property that determines the class that a universal property restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "allValuesFrom",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :annotatedProperty,
      comment: "The property that determines the predicate of an annotated axiom or annotated annotation.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "annotatedProperty",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :annotatedSource,
      comment: "The property that determines the subject of an annotated axiom or annotated annotation.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "annotatedSource",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :annotatedTarget,
      comment: "The property that determines the object of an annotated axiom or annotated annotation.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "annotatedTarget",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :assertionProperty,
      comment: "The property that determines the predicate of a negative property assertion.",
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "assertionProperty",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :backwardCompatibleWith,
      comment: "The annotation property that indicates that a given ontology is backward compatible with another ontology.",
      domain: "http://www.w3.org/2002/07/owl#Ontology",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "backwardCompatibleWith",
      range: "http://www.w3.org/2002/07/owl#Ontology",
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty", "http://www.w3.org/2002/07/owl#OntologyProperty"]
    property :bottomDataProperty,
      comment: "The data property that does not relate any individual to any data value.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "bottomDataProperty",
      range: "http://www.w3.org/2000/01/rdf-schema#Literal",
      type: "http://www.w3.org/2002/07/owl#DatatypeProperty"
    property :bottomObjectProperty,
      comment: "The object property that does not relate any two individuals.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "bottomObjectProperty",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/2002/07/owl#ObjectProperty"
    property :cardinality,
      comment: "The property that determines the cardinality of an exact cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "cardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :complementOf,
      comment: "The property that determines that a given class is the complement of another class.",
      domain: "http://www.w3.org/2002/07/owl#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "complementOf",
      range: "http://www.w3.org/2002/07/owl#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :datatypeComplementOf,
      comment: "The property that determines that a given data range is the complement of another data range with respect to the data domain.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "datatypeComplementOf",
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :deprecated,
      comment: "The annotation property that indicates that a given entity has been deprecated.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "deprecated",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2002/07/owl#AnnotationProperty"
    property :differentFrom,
      comment: "The property that determines that two given individuals are different.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "differentFrom",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :disjointUnionOf,
      comment: "The property that determines that a given class is equivalent to the disjoint union of a collection of other classes.",
      domain: "http://www.w3.org/2002/07/owl#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "disjointUnionOf",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :disjointWith,
      comment: "The property that determines that two given classes are disjoint.",
      domain: "http://www.w3.org/2002/07/owl#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "disjointWith",
      range: "http://www.w3.org/2002/07/owl#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :distinctMembers,
      comment: "The property that determines the collection of pairwise different individuals in a owl:AllDifferent axiom.",
      domain: "http://www.w3.org/2002/07/owl#AllDifferent",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "distinctMembers",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :equivalentClass,
      comment: "The property that determines that two given classes are equivalent, and that is used to specify datatype definitions.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "equivalentClass",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :equivalentProperty,
      comment: "The property that determines that two given properties are equivalent.",
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "equivalentProperty",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :hasKey,
      comment: "The property that determines the collection of properties that jointly build a key.",
      domain: "http://www.w3.org/2002/07/owl#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "hasKey",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :hasSelf,
      comment: "The property that determines the property that a self restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "hasSelf",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :hasValue,
      comment: "The property that determines the individual that a has-value restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "hasValue",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :imports,
      comment: "The property that is used for importing other ontologies into a given ontology.",
      domain: "http://www.w3.org/2002/07/owl#Ontology",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "imports",
      range: "http://www.w3.org/2002/07/owl#Ontology",
      type: "http://www.w3.org/2002/07/owl#OntologyProperty"
    property :incompatibleWith,
      comment: "The annotation property that indicates that a given ontology is incompatible with another ontology.",
      domain: "http://www.w3.org/2002/07/owl#Ontology",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "incompatibleWith",
      range: "http://www.w3.org/2002/07/owl#Ontology",
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty", "http://www.w3.org/2002/07/owl#OntologyProperty"]
    property :intersectionOf,
      comment: "The property that determines the collection of classes or data ranges that build an intersection.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "intersectionOf",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :inverseOf,
      comment: "The property that determines that two given properties are inverse.",
      domain: "http://www.w3.org/2002/07/owl#ObjectProperty",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "inverseOf",
      range: "http://www.w3.org/2002/07/owl#ObjectProperty",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :maxCardinality,
      comment: "The property that determines the cardinality of a maximum cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "maxCardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :maxQualifiedCardinality,
      comment: "The property that determines the cardinality of a maximum qualified cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "maxQualifiedCardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :members,
      comment: "The property that determines the collection of members in either a owl:AllDifferent, owl:AllDisjointClasses or owl:AllDisjointProperties axiom.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "members",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :minCardinality,
      comment: "The property that determines the cardinality of a minimum cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "minCardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :minQualifiedCardinality,
      comment: "The property that determines the cardinality of a minimum qualified cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "minQualifiedCardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :onClass,
      comment: "The property that determines the class that a qualified object cardinality restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "onClass",
      range: "http://www.w3.org/2002/07/owl#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :onDataRange,
      comment: "The property that determines the data range that a qualified data cardinality restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "onDataRange",
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :onDatatype,
      comment: "The property that determines the datatype that a datatype restriction refers to.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "onDatatype",
      range: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :onProperties,
      comment: "The property that determines the n-tuple of properties that a property restriction on an n-ary data range refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "onProperties",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :onProperty,
      comment: "The property that determines the property that a property restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "onProperty",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :oneOf,
      comment: "The property that determines the collection of individuals or data values that build an enumeration.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "oneOf",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :priorVersion,
      comment: "The annotation property that indicates the predecessor ontology of a given ontology.",
      domain: "http://www.w3.org/2002/07/owl#Ontology",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "priorVersion",
      range: "http://www.w3.org/2002/07/owl#Ontology",
      type: ["http://www.w3.org/2002/07/owl#AnnotationProperty", "http://www.w3.org/2002/07/owl#OntologyProperty"]
    property :propertyChainAxiom,
      comment: "The property that determines the n-tuple of properties that build a sub property chain of a given property.",
      domain: "http://www.w3.org/2002/07/owl#ObjectProperty",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "propertyChainAxiom",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :propertyDisjointWith,
      comment: "The property that determines that two given properties are disjoint.",
      domain: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "propertyDisjointWith",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :qualifiedCardinality,
      comment: "The property that determines the cardinality of an exact qualified cardinality restriction.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "qualifiedCardinality",
      range: "http://www.w3.org/2001/XMLSchema#nonNegativeInteger",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :sameAs,
      comment: "The property that determines that two given individuals are equal.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "sameAs",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :someValuesFrom,
      comment: "The property that determines the class that an existential property restriction refers to.",
      domain: "http://www.w3.org/2002/07/owl#Restriction",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "someValuesFrom",
      range: "http://www.w3.org/2000/01/rdf-schema#Class",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :sourceIndividual,
      comment: "The property that determines the subject of a negative property assertion.",
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "sourceIndividual",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :targetIndividual,
      comment: "The property that determines the object of a negative object property assertion.",
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "targetIndividual",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :targetValue,
      comment: "The property that determines the value of a negative data property assertion.",
      domain: "http://www.w3.org/2002/07/owl#NegativePropertyAssertion",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "targetValue",
      range: "http://www.w3.org/2000/01/rdf-schema#Literal",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :topDataProperty,
      comment: "The data property that relates every individual to every data value.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "topDataProperty",
      range: "http://www.w3.org/2000/01/rdf-schema#Literal",
      type: "http://www.w3.org/2002/07/owl#DatatypeProperty"
    property :topObjectProperty,
      comment: "The object property that relates every two individuals.",
      domain: "http://www.w3.org/2002/07/owl#Thing",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "topObjectProperty",
      range: "http://www.w3.org/2002/07/owl#Thing",
      type: "http://www.w3.org/2002/07/owl#ObjectProperty"
    property :unionOf,
      comment: "The property that determines the collection of classes or data ranges that build a union.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Class",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "unionOf",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
    property :versionIRI,
      comment: "The property that identifies the version IRI of an ontology.",
      domain: "http://www.w3.org/2002/07/owl#Ontology",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "versionIRI",
      range: "http://www.w3.org/2002/07/owl#Ontology",
      type: "http://www.w3.org/2002/07/owl#OntologyProperty"
    property :versionInfo,
      comment: "The annotation property that provides version information for an ontology or another OWL construct.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Resource",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "versionInfo",
      range: "http://www.w3.org/2000/01/rdf-schema#Resource",
      type: "http://www.w3.org/2002/07/owl#AnnotationProperty"
    property :withRestrictions,
      comment: "The property that determines the collection of facet-value pairs that define a datatype restriction.",
      domain: "http://www.w3.org/2000/01/rdf-schema#Datatype",
      isDefinedBy: "http://www.w3.org/2002/07/owl#",
      label: "withRestrictions",
      range: "http://www.w3.org/1999/02/22-rdf-syntax-ns#List",
      type: "http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"
  end
end
