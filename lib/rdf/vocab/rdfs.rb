# This file generated automatically using vocab-fetch from http://www.w3.org/2000/01/rdf-schema#
require 'rdf'
module RDF
  class RDFS < StrictVocabulary("http://www.w3.org/2000/01/rdf-schema#")

    # Class definitions
    property :Class, :label => 'Class', :comment =>
      %(The class of classes.)
    property :Container, :label => 'Container', :comment =>
      %(The class of RDF containers.)
    property :ContainerMembershipProperty, :label => 'ContainerMembershipProperty', :comment =>
      %(The class of container membership properties, rdf:_1, rdf:_2,
        ..., all of which are sub-properties of 'member'.)
    property :Datatype, :label => 'Datatype', :comment =>
      %(The class of RDF datatypes.)
    property :Literal, :label => 'Literal', :comment =>
      %(The class of literal values, eg. textual strings and integers.)
    property :Resource, :label => 'Resource', :comment =>
      %(The class resource, everything.)

    # Property definitions
    property :comment, :label => 'comment', :comment =>
      %(A description of the subject resource.)
    property :domain, :label => 'domain', :comment =>
      %(A domain of the subject property.)
    property :isDefinedBy, :label => 'isDefinedBy', :comment =>
      %(The defininition of the subject resource.)
    property :label, :label => 'label', :comment =>
      %(A human-readable name for the subject.)
    property :member, :label => 'member', :comment =>
      %(A member of the subject resource.)
    property :range, :label => 'range', :comment =>
      %(A range of the subject property.)
    property :seeAlso, :label => 'seeAlso', :comment =>
      %(Further information about the subject resource.)
    property :subClassOf, :label => 'subClassOf', :comment =>
      %(The subject is a subclass of a class.)
    property :subPropertyOf, :label => 'subPropertyOf', :comment =>
      %(The subject is a subproperty of a property.)
  end
end
