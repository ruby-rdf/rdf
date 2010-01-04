module RDF
  ##
  # RDF Site Summary (RSS) vocabulary.
  #
  # @see http://web.resource.org/rss/1.0/
  class RSS < Vocabulary("http://purl.org/rss/1.0/")
    property :description
    property :items
    property :link
    property :name
    property :title
    property :url
  end
end
