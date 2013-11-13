# This file generated automatically using vocab-fetch from http://creativecommons.org/ns#
require 'rdf'
module RDF
  class CC < StrictVocabulary("http://creativecommons.org/ns#")

    # Class definitions
    property :Jurisdiction, :label => 'Jurisdiction', :comment =>
      %(the legal jurisdiction of a license)
    property :License, :label => 'License', :comment =>
      %(a set of requests/permissions to users of a Work, e.g. a
        copyright license, the public domain, information for
        distributors)
    property :Permission, :label => 'Permission', :comment =>
      %(an action that may or may not be allowed or desired)
    property :Prohibition, :label => 'Prohibition', :comment =>
      %(something you may be asked not to do)
    property :Requirement, :label => 'Requirement', :comment =>
      %(an action that may or may not be requested of you)
    property :Work, :label => 'Work', :comment =>
      %(a potentially copyrightable work)

    # Property definitions
    property :deprecatedOn, :label => 'deprecated on'
    property :license, :label => 'has license'
    property :attributionName
    property :attributionURL
    property :legalcode
    property :morePermissions
    property :useGuidelines
    property :jurisdiction, :label => 'jurisdiction'
    property :permits, :label => 'permits'
    property :prohibits, :label => 'prohibits'
    property :requires, :label => 'requires'
  end
end
