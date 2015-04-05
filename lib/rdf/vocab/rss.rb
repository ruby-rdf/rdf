# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://purl.org/rss/1.0/schema.rdf
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::RSS` from the rdf-vocab gem instead
  class RSS < RDF::StrictVocabulary("http://purl.org/rss/1.0/")

    # Class definitions
    term :channel,
      comment: %(An RSS information channel.).freeze,
      label: "Channel".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdfs:Class".freeze
    term :image,
      comment: %(An RSS image.).freeze,
      label: "Image".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdfs:Class".freeze
    term :item,
      comment: %(An RSS item.).freeze,
      label: "Item".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdfs:Class".freeze
    term :textinput,
      comment: %(An RSS text input.).freeze,
      label: "Text Input".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :description,
      comment: %(A short text description of the subject.).freeze,
      label: "Description".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      subPropertyOf: "dc11:description".freeze,
      type: "rdf:Property".freeze
    property :items,
      comment: %(Points to a list of rss:item elements that are members of the subject channel.).freeze,
      label: "Items".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdf:Property".freeze
    property :link,
      comment: %(The URL to which an HTML rendering of the subject will link.).freeze,
      label: "Link".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      subPropertyOf: "dc11:identifier".freeze,
      type: "rdf:Property".freeze
    property :name,
      comment: %(The text input field's \(variable\) name.).freeze,
      label: "Name".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      type: "rdf:Property".freeze
    property :title,
      comment: %(A descriptive title for the channel.).freeze,
      label: "Title".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      subPropertyOf: "dc11:title".freeze,
      type: "rdf:Property".freeze
    property :url,
      comment: %(The URL of the image to used in the 'src' attribute of the channel's image tag when rendered as HTML.).freeze,
      label: "URL".freeze,
      "rdfs:isDefinedBy" => %(rss:).freeze,
      subPropertyOf: "dc11:identifier".freeze,
      type: "rdf:Property".freeze
  end
end
