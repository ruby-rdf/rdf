module RDF
  ##
  # Dublin Core (DC) legacy vocabulary.
  #
  # @see http://dublincore.org/schemas/rdfs/
  class DC11 < Vocabulary("http://purl.org/dc/elements/1.1/")
    property :contributor
    property :coverage
    property :creator
    property :date
    property :description
    property :format
    property :identifier
    property :language
    property :publisher
    property :relation
    property :rights
    property :source
    property :subject
    property :title
    property :type
  end
end
