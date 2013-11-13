# This file generated automatically using vocab-fetch from http://vocab.deri.ie/void.rdf
require 'rdf'
module RDF
  class VOID < StrictVocabulary("http://rdfs.org/ns/void#")

    # Class definitions
    property :Dataset, :label => 'dataset', :comment =>
      %(A set of RDF triples that are published, maintained or
        aggregated by a single provider.)
    property :Dataset, :label => 'dataset', :comment =>
      %(A set of RDF triples that are published, maintained or
        aggregated by a single provider.)
    property :DatasetDescription, :label => 'dataset description', :comment =>
      %(A web resource whose foaf:primaryTopic or foaf:topics include
        void:Datasets.)
    property :DatasetDescription, :label => 'dataset description', :comment =>
      %(A web resource whose foaf:primaryTopic or foaf:topics include
        void:Datasets.)
    property :Linkset, :label => 'linkset', :comment =>
      %(A collection of RDF links between two void:Datasets.)
    property :Linkset, :label => 'linkset', :comment =>
      %(A collection of RDF links between two void:Datasets.)
    property :TechnicalFeature, :label => 'technical feature', :comment =>
      %(A technical feature of a void:Dataset, such as a supported RDF
        serialization format.)
    property :TechnicalFeature, :label => 'technical feature', :comment =>
      %(A technical feature of a void:Dataset, such as a supported RDF
        serialization format.)

    # Property definitions
    property :dataDump, :label => 'Data Dump', :comment =>
      %(An RDF dump, partial or complete, of a void:Dataset.)
    property :objectsTarget, :label => 'Objects Target', :comment =>
      %(The dataset describing the objects of the triples contained in
        the Linkset.)
    property :subjectsTarget, :label => 'Subjects Target', :comment =>
      %(The dataset describing the subjects of triples contained in
        the Linkset.)
    property :target, :label => 'Target', :comment =>
      %(One of the two datasets linked by the Linkset.)
    property :uriSpace, :label => 'URI space', :comment =>
      %(A URI that is a common string prefix of all the entity URIs in
        a void:Dataset.)
    property :linkPredicate, :label => 'a link predicate'
    property :class, :label => 'class', :comment =>
      %(The rdfs:Class that is the rdf:type of all entities in a
        class-based partition.)
    property :classPartition, :label => 'class partition', :comment =>
      %(A subset of a void:Dataset that contains only the entities of
        a certain rdfs:Class.)
    property :classes, :label => 'classes', :comment =>
      %(The total number of distinct classes in a void:Dataset. In
        other words, the number of distinct resources occuring as
        objects of rdf:type triples in the dataset.)
    property :distinctObjects, :label => 'distinct objects', :comment =>
      %(The total number of distinct objects in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the object position of triples in the dataset. Literals are
        included in this count.)
    property :distinctSubjects, :label => 'distinct subjects', :comment =>
      %(The total number of distinct subjects in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the subject position of triples in the dataset.)
    property :exampleResource, :label => 'example resource of dataset'
    property :feature, :label => 'feature'
    property :uriRegexPattern, :label => 'has URI regular expression pattern', :comment =>
      %(Defines a regular expression pattern matching URIs in the
        dataset.)
    property :sparqlEndpoint, :label => 'has a SPARQL endpoint at'
    property :uriLookupEndpoint, :label => 'has an URI look-up endpoint at', :comment =>
      %(Defines a simple URI look-up protocol for accessing a dataset.)
    property :subset, :label => 'has subset'
    property :inDataset, :label => 'in dataset', :comment =>
      %(Points to the void:Dataset that a document is a part of.)
    property :documents, :label => 'number of documents', :comment =>
      %(The total number of documents, for datasets that are published
        as a set of individual documents, such as RDF/XML documents or
        RDFa-annotated web pages. Non-RDF documents, such as web pages
        in HTML or images, are usually not included in this count.
        This property is intended for datasets where the total number
        of triples or entities is hard to determine. void:triples or
        void:entities should be preferred where practical.)
    property :entities, :label => 'number of entities', :comment =>
      %(The total number of entities that are described in a
        void:Dataset.)
    property :properties, :label => 'number of properties', :comment =>
      %(The total number of distinct properties in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the predicate position of triples in the dataset.)
    property :triples, :label => 'number of triples', :comment =>
      %(The total number of triples contained in a void:Dataset.)
    property :openSearchDescription, :label => 'open search description', :comment =>
      %(An OpenSearch description document for a free-text search
        service over a void:Dataset.)
    property :property, :label => 'property', :comment =>
      %(The rdf:Property that is the predicate of all triples in a
        property-based partition.)
    property :propertyPartition, :label => 'property partition', :comment =>
      %(A subset of a void:Dataset that contains only the triples of a
        certain rdf:Property.)
    property :rootResource, :label => 'root resource', :comment =>
      %(A top concept or entry point for a void:Dataset that is
        structured in a tree-like fashion. All resources in a dataset
        can be reached by following links from its root resources in a
        small number of steps.)
    property :vocabulary, :label => 'vocabulary', :comment =>
      %(A vocabulary that is used in the dataset.)
    property :uriSpace, :label => 'URI space', :comment =>
      %(A URI that is a common string prefix of all the entity URIs in
        a void:Dataset.)
    property :classes, :label => 'classes', :comment =>
      %(The total number of distinct classes in a void:Dataset. In
        other words, the number of distinct resources occuring as
        objects of rdf:type triples in the dataset.)
    property :distinctObjects, :label => 'distinct objects', :comment =>
      %(The total number of distinct objects in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the object position of triples in the dataset. Literals are
        included in this count.)
    property :distinctSubjects, :label => 'distinct subjects', :comment =>
      %(The total number of distinct subjects in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the subject position of triples in the dataset.)
    property :documents, :label => 'number of documents', :comment =>
      %(The total number of documents, for datasets that are published
        as a set of individual documents, such as RDF/XML documents or
        RDFa-annotated web pages. Non-RDF documents, such as web pages
        in HTML or images, are usually not included in this count.
        This property is intended for datasets where the total number
        of triples or entities is hard to determine. void:triples or
        void:entities should be preferred where practical.)
    property :entities, :label => 'number of entities', :comment =>
      %(The total number of entities that are described in a
        void:Dataset.)
    property :properties, :label => 'number of properties', :comment =>
      %(The total number of distinct properties in a void:Dataset. In
        other words, the number of distinct resources that occur in
        the predicate position of triples in the dataset.)
    property :triples, :label => 'number of triples', :comment =>
      %(The total number of triples contained in a void:Dataset.)
  end
end
