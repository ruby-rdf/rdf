# This file generated automatically using vocab-fetch from http://purl.org/rss/1.0/schema.rdf
require 'rdf'
module RDF
  class RSS < StrictVocabulary("http://purl.org/rss/1.0/")

    # Class definitions
    property :channel, :label => 'Channel', :comment =>
      %(An RSS information channel.)
    property :image, :label => 'Image', :comment =>
      %(An RSS image.)
    property :item, :label => 'Item', :comment =>
      %(An RSS item.)
    property :textinput, :label => 'Text Input', :comment =>
      %(An RSS text input.)

    # Property definitions
    property :description, :label => 'Description', :comment =>
      %(A short text description of the subject.)
    property :items, :label => 'Items', :comment =>
      %(Points to a list of rss:item elements that are members of the
        subject channel.)
    property :link, :label => 'Link', :comment =>
      %(The URL to which an HTML rendering of the subject will link.)
    property :name, :label => 'Name', :comment =>
      %(The text input field's \(variable\) name.)
    property :title, :label => 'Title', :comment =>
      %(A descriptive title for the channel.)
    property :url, :label => 'URL', :comment =>
      %(The URL of the image to used in the 'src' attribute of the
        channel's image tag when rendered as HTML.)
  end
end
