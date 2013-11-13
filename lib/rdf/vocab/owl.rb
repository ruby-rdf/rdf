# This file generated automatically using vocab-fetch from http://www.w3.org/2002/07/owl#
require 'rdf'
module RDF
  class OWL < StrictVocabulary("http://www.w3.org/2002/07/owl#")

    # Class definitions
    property :AllDifferent, :label => 'AllDifferent', :comment =>
      %(The class of collections of pairwise different individuals.)
    property :AllDisjointClasses, :label => 'AllDisjointClasses', :comment =>
      %(The class of collections of pairwise disjoint classes.)
    property :AllDisjointProperties, :label => 'AllDisjointProperties', :comment =>
      %(The class of collections of pairwise disjoint properties.)
    property :Annotation, :label => 'Annotation', :comment =>
      %(The class of annotated annotations for which the RDF
        serialization consists of an annotated subject, predicate and
        object.)
    property :AnnotationProperty, :label => 'AnnotationProperty', :comment =>
      %(The class of annotation properties.)
    property :AsymmetricProperty, :label => 'AsymmetricProperty', :comment =>
      %(The class of asymmetric properties.)
    property :Axiom, :label => 'Axiom', :comment =>
      %(The class of annotated axioms for which the RDF serialization
        consists of an annotated subject, predicate and object.)
    property :Class, :label => 'Class', :comment =>
      %(The class of OWL classes.)
    property :DataRange, :label => 'DataRange', :comment =>
      %(The class of OWL data ranges, which are special kinds of
        datatypes. Note: The use of the IRI owl:DataRange has been
        deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used
        instead.)
    property :DatatypeProperty, :label => 'DatatypeProperty', :comment =>
      %(The class of data properties.)
    property :DeprecatedClass, :label => 'DeprecatedClass', :comment =>
      %(The class of deprecated classes.)
    property :DeprecatedProperty, :label => 'DeprecatedProperty', :comment =>
      %(The class of deprecated properties.)
    property :FunctionalProperty, :label => 'FunctionalProperty', :comment =>
      %(The class of functional properties.)
    property :InverseFunctionalProperty, :label => 'InverseFunctionalProperty', :comment =>
      %(The class of inverse-functional properties.)
    property :IrreflexiveProperty, :label => 'IrreflexiveProperty', :comment =>
      %(The class of irreflexive properties.)
    property :NamedIndividual, :label => 'NamedIndividual', :comment =>
      %(The class of named individuals.)
    property :NegativePropertyAssertion, :label => 'NegativePropertyAssertion', :comment =>
      %(The class of negative property assertions.)
    property :Nothing, :label => 'Nothing', :comment =>
      %(This is the empty class.)
    property :ObjectProperty, :label => 'ObjectProperty', :comment =>
      %(The class of object properties.)
    property :Ontology, :label => 'Ontology', :comment =>
      %(The class of ontologies.)
    property :OntologyProperty, :label => 'OntologyProperty', :comment =>
      %(The class of ontology properties.)
    property :ReflexiveProperty, :label => 'ReflexiveProperty', :comment =>
      %(The class of reflexive properties.)
    property :Restriction, :label => 'Restriction', :comment =>
      %(The class of property restrictions.)
    property :SymmetricProperty, :label => 'SymmetricProperty', :comment =>
      %(The class of symmetric properties.)
    property :Thing, :label => 'Thing', :comment =>
      %(The class of OWL individuals.)
    property :TransitiveProperty, :label => 'TransitiveProperty', :comment =>
      %(The class of transitive properties.)

    # Property definitions
    property :allValuesFrom, :label => 'allValuesFrom', :comment =>
      %(The property that determines the class that a universal
        property restriction refers to.)
    property :annotatedProperty, :label => 'annotatedProperty', :comment =>
      %(The property that determines the predicate of an annotated
        axiom or annotated annotation.)
    property :annotatedSource, :label => 'annotatedSource', :comment =>
      %(The property that determines the subject of an annotated axiom
        or annotated annotation.)
    property :annotatedTarget, :label => 'annotatedTarget', :comment =>
      %(The property that determines the object of an annotated axiom
        or annotated annotation.)
    property :assertionProperty, :label => 'assertionProperty', :comment =>
      %(The property that determines the predicate of a negative
        property assertion.)
    property :cardinality, :label => 'cardinality', :comment =>
      %(The property that determines the cardinality of an exact
        cardinality restriction.)
    property :complementOf, :label => 'complementOf', :comment =>
      %(The property that determines that a given class is the
        complement of another class.)
    property :datatypeComplementOf, :label => 'datatypeComplementOf', :comment =>
      %(The property that determines that a given data range is the
        complement of another data range with respect to the data
        domain.)
    property :differentFrom, :label => 'differentFrom', :comment =>
      %(The property that determines that two given individuals are
        different.)
    property :disjointUnionOf, :label => 'disjointUnionOf', :comment =>
      %(The property that determines that a given class is equivalent
        to the disjoint union of a collection of other classes.)
    property :disjointWith, :label => 'disjointWith', :comment =>
      %(The property that determines that two given classes are
        disjoint.)
    property :distinctMembers, :label => 'distinctMembers', :comment =>
      %(The property that determines the collection of pairwise
        different individuals in a owl:AllDifferent axiom.)
    property :equivalentClass, :label => 'equivalentClass', :comment =>
      %(The property that determines that two given classes are
        equivalent, and that is used to specify datatype definitions.)
    property :equivalentProperty, :label => 'equivalentProperty', :comment =>
      %(The property that determines that two given properties are
        equivalent.)
    property :hasKey, :label => 'hasKey', :comment =>
      %(The property that determines the collection of properties that
        jointly build a key.)
    property :hasSelf, :label => 'hasSelf', :comment =>
      %(The property that determines the property that a self
        restriction refers to.)
    property :hasValue, :label => 'hasValue', :comment =>
      %(The property that determines the individual that a has-value
        restriction refers to.)
    property :intersectionOf, :label => 'intersectionOf', :comment =>
      %(The property that determines the collection of classes or data
        ranges that build an intersection.)
    property :inverseOf, :label => 'inverseOf', :comment =>
      %(The property that determines that two given properties are
        inverse.)
    property :maxCardinality, :label => 'maxCardinality', :comment =>
      %(The property that determines the cardinality of a maximum
        cardinality restriction.)
    property :maxQualifiedCardinality, :label => 'maxQualifiedCardinality', :comment =>
      %(The property that determines the cardinality of a maximum
        qualified cardinality restriction.)
    property :members, :label => 'members', :comment =>
      %(The property that determines the collection of members in
        either a owl:AllDifferent, owl:AllDisjointClasses or
        owl:AllDisjointProperties axiom.)
    property :minCardinality, :label => 'minCardinality', :comment =>
      %(The property that determines the cardinality of a minimum
        cardinality restriction.)
    property :minQualifiedCardinality, :label => 'minQualifiedCardinality', :comment =>
      %(The property that determines the cardinality of a minimum
        qualified cardinality restriction.)
    property :onClass, :label => 'onClass', :comment =>
      %(The property that determines the class that a qualified object
        cardinality restriction refers to.)
    property :onDataRange, :label => 'onDataRange', :comment =>
      %(The property that determines the data range that a qualified
        data cardinality restriction refers to.)
    property :onDatatype, :label => 'onDatatype', :comment =>
      %(The property that determines the datatype that a datatype
        restriction refers to.)
    property :onProperties, :label => 'onProperties', :comment =>
      %(The property that determines the n-tuple of properties that a
        property restriction on an n-ary data range refers to.)
    property :onProperty, :label => 'onProperty', :comment =>
      %(The property that determines the property that a property
        restriction refers to.)
    property :oneOf, :label => 'oneOf', :comment =>
      %(The property that determines the collection of individuals or
        data values that build an enumeration.)
    property :propertyChainAxiom, :label => 'propertyChainAxiom', :comment =>
      %(The property that determines the n-tuple of properties that
        build a sub property chain of a given property.)
    property :propertyDisjointWith, :label => 'propertyDisjointWith', :comment =>
      %(The property that determines that two given properties are
        disjoint.)
    property :qualifiedCardinality, :label => 'qualifiedCardinality', :comment =>
      %(The property that determines the cardinality of an exact
        qualified cardinality restriction.)
    property :sameAs, :label => 'sameAs', :comment =>
      %(The property that determines that two given individuals are
        equal.)
    property :someValuesFrom, :label => 'someValuesFrom', :comment =>
      %(The property that determines the class that an existential
        property restriction refers to.)
    property :sourceIndividual, :label => 'sourceIndividual', :comment =>
      %(The property that determines the subject of a negative
        property assertion.)
    property :targetIndividual, :label => 'targetIndividual', :comment =>
      %(The property that determines the object of a negative object
        property assertion.)
    property :targetValue, :label => 'targetValue', :comment =>
      %(The property that determines the value of a negative data
        property assertion.)
    property :unionOf, :label => 'unionOf', :comment =>
      %(The property that determines the collection of classes or data
        ranges that build a union.)
    property :withRestrictions, :label => 'withRestrictions', :comment =>
      %(The property that determines the collection of facet-value
        pairs that define a datatype restriction.)
    property :bottomDataProperty, :label => 'bottomDataProperty', :comment =>
      %(The data property that does not relate any individual to any
        data value.)
    property :topDataProperty, :label => 'topDataProperty', :comment =>
      %(The data property that relates every individual to every data
        value.)
    property :bottomObjectProperty, :label => 'bottomObjectProperty', :comment =>
      %(The object property that does not relate any two individuals.)
    property :topObjectProperty, :label => 'topObjectProperty', :comment =>
      %(The object property that relates every two individuals.)
    property :backwardCompatibleWith, :label => 'backwardCompatibleWith', :comment =>
      %(The annotation property that indicates that a given ontology
        is backward compatible with another ontology.)
    property :deprecated, :label => 'deprecated', :comment =>
      %(The annotation property that indicates that a given entity has
        been deprecated.)
    property :incompatibleWith, :label => 'incompatibleWith', :comment =>
      %(The annotation property that indicates that a given ontology
        is incompatible with another ontology.)
    property :priorVersion, :label => 'priorVersion', :comment =>
      %(The annotation property that indicates the predecessor
        ontology of a given ontology.)
    property :versionInfo, :label => 'versionInfo', :comment =>
      %(The annotation property that provides version information for
        an ontology or another OWL construct.)
    property :backwardCompatibleWith, :label => 'backwardCompatibleWith', :comment =>
      %(The annotation property that indicates that a given ontology
        is backward compatible with another ontology.)
    property :imports, :label => 'imports', :comment =>
      %(The property that is used for importing other ontologies into
        a given ontology.)
    property :incompatibleWith, :label => 'incompatibleWith', :comment =>
      %(The annotation property that indicates that a given ontology
        is incompatible with another ontology.)
    property :priorVersion, :label => 'priorVersion', :comment =>
      %(The annotation property that indicates the predecessor
        ontology of a given ontology.)
    property :versionIRI, :label => 'versionIRI', :comment =>
      %(The property that identifies the version IRI of an ontology.)
  end
end
