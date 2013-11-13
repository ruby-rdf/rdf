# This file generated automatically using vocab-fetch from http://purl.org/dc/elements/1.1/
require 'rdf'
module RDF
  class DC11 < StrictVocabulary("http://purl.org/dc/elements/1.1/")

    # Property definitions
    property :contributor, :label => 'Contributor', :comment =>
      %(An entity responsible for making contributions to the
        resource.)
    property :coverage, :label => 'Coverage', :comment =>
      %(The spatial or temporal topic of the resource, the spatial
        applicability of the resource, or the jurisdiction under which
        the resource is relevant.)
    property :creator, :label => 'Creator', :comment =>
      %(An entity primarily responsible for making the resource.)
    property :date, :label => 'Date', :comment =>
      %(A point or period of time associated with an event in the
        lifecycle of the resource.)
    property :description, :label => 'Description', :comment =>
      %(An account of the resource.)
    property :format, :label => 'Format', :comment =>
      %(The file format, physical medium, or dimensions of the
        resource.)
    property :identifier, :label => 'Identifier', :comment =>
      %(An unambiguous reference to the resource within a given
        context.)
    property :language, :label => 'Language', :comment =>
      %(A language of the resource.)
    property :publisher, :label => 'Publisher', :comment =>
      %(An entity responsible for making the resource available.)
    property :relation, :label => 'Relation', :comment =>
      %(A related resource.)
    property :rights, :label => 'Rights', :comment =>
      %(Information about rights held in and over the resource.)
    property :source, :label => 'Source', :comment =>
      %(A related resource from which the described resource is
        derived.)
    property :subject, :label => 'Subject', :comment =>
      %(The topic of the resource.)
    property :title, :label => 'Title', :comment =>
      %(A name given to the resource.)
    property :type, :label => 'Type', :comment =>
      %(The nature or genre of the resource.)
  end
end
