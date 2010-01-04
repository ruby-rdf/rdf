module RDF
  ##
  # Description of a Project (DOAP) vocabulary.
  #
  # @see http://trac.usefulinc.com/doap
  class DOAP < Vocabulary("http://usefulinc.com/ns/doap#")
    property :'anon-root'
    property :audience
    property :blog
    property :browse
    property :'bug-database'
    property :category
    property :created
    property :description
    property :developer
    property :documenter
    property :'download-mirror'
    property :'download-page'
    property :'file-release'
    property :helper
    property :homepage
    property :implements
    property :language
    property :license
    property :location
    property :'mailing-list'
    property :maintainer
    property :module
    property :name
    property :'old-homepage'
    property :os
    property :platform
    property :'programming-language'
    property :release
    property :repository
    property :revision
    property :screenshots
    property :'service-endpoint'
    property :shortdesc
    property :tester
    property :translator
    property :vendor
    property :wiki
  end
end
