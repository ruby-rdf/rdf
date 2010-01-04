module RDF
  ##
  # Creative Commons (CC) vocabulary.
  #
  # @see http://creativecommons.org/ns
  class CC < Vocabulary("http://creativecommons.org/ns#")
    property :attributionName
    property :attributionURL
    property :deprecatedOn
    property :jurisdiction
    property :legalcode
    property :license
    property :morePermissions
    property :permits
    property :prohibits
    property :requires
  end
end
