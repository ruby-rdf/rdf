# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://ogp.me/ns#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::OG` from the rdf-vocab gem instead
  class OG < RDF::StrictVocabulary("http://ogp.me/ns#")

    # Property definitions
    property :audio,
      comment: %(A relevant audio URL for your object.).freeze,
      label: "audio".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:album",
      comment: %([DEPRECATED] An album to which some audio belongs.).freeze,
      label: "audio album".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:artist",
      comment: %([DEPRECATED] An artist of some audio.).freeze,
      label: "audio artist".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:secure_url",
      comment: %(A relevant, secure audio URL for your object.).freeze,
      label: "audio secure URL".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:title",
      comment: %([DEPRECATED] A title for some audio.).freeze,
      label: "audio title".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:type",
      comment: %(The mime type of an audio file e.g., "application/mp3").freeze,
      label: "audio type".freeze,
      range: "ogc:mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"country-name",
      comment: %([DEPRECATED] The country name of the resource e.g., "USA").freeze,
      label: "country name".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:country-name).freeze,
      type: "rdf:Property".freeze
    property :description,
      comment: %(A one to two sentence description of your object.).freeze,
      label: "description".freeze,
      range: "ogc:string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:comment".freeze,
      type: "rdf:Property".freeze
    property :determiner,
      comment: %(The word to precede the object's title in a sentence \(e.g., "the" in "the statue of liberty"\).  Valid values are "a", "an", "the", "", and "auto".).freeze,
      label: "determiner".freeze,
      range: "ogc:determiner_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :email,
      comment: %([DEPRECATED] Email of the contact for your object.).freeze,
      label: "email".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:mbox).freeze,
      type: "rdf:Property".freeze
    property :fax_number,
      comment: %([DEPRECATED] Fax number of the contact for your object.).freeze,
      label: "fax number".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :image,
      comment: %(An image URL which should represent your object within the graph.).freeze,
      label: "image".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:height",
      comment: %(The height of an image.).freeze,
      label: "image height".freeze,
      range: "ogc:integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:secure_url",
      comment: %(A secure image URL which should represent your object within the graph.).freeze,
      label: "image secure url".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:type",
      comment: %(The mime type of an image.).freeze,
      label: "image type".freeze,
      range: "ogc:mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:width",
      comment: %(The width of an image.).freeze,
      label: "image width".freeze,
      range: "ogc:integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :isbn,
      comment: %([DEPRECATED] International Standard Book Number for you object.).freeze,
      label: ["isbn".freeze, "International Standard Book Number".freeze],
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(http://purl.org/ontology/bibo/isbn).freeze,
      type: "rdf:Property".freeze
    property :latitude,
      comment: %([DEPRECATED] The latitude of the resource e.g., the latitude of a company.).freeze,
      label: "latitude".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:lat).freeze,
      type: "rdf:Property".freeze
    property :locale,
      comment: %(A Unix locale in which this markup is rendered.).freeze,
      label: "locale".freeze,
      range: "ogc:string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :locality,
      comment: %([DEPRECATED] The locality of the resource e.g, "Palo Alto").freeze,
      label: "locality".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:locality).freeze,
      type: "rdf:Property".freeze
    property :longitude,
      comment: %([DEPRECATED] The longitude of the resource e.g., the longitude of a company.).freeze,
      label: "longitude".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:long).freeze,
      type: "rdf:Property".freeze
    property :phone_number,
      comment: %([DEPRECATED] Phone number of the contact for your object.).freeze,
      label: "phone number".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :"postal-code",
      comment: %([DEPRECATED] The postal code of the resource e.g., "94304").freeze,
      label: "postal code".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:postal-code).freeze,
      type: "rdf:Property".freeze
    property :region,
      comment: %([DEPRECATED] The region of the resource e.g., "CA").freeze,
      label: "region".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:region).freeze,
      type: "rdf:Property".freeze
    property :site_name,
      comment: %(If your object is part of a larger web site, the name which should be displayed for the overall site. e.g., "IMDb".).freeze,
      label: "site name".freeze,
      range: "ogc:string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"street-address",
      comment: %([DEPRECATED] The street address of the resource e.g., "1601 S California Ave".).freeze,
      label: "street address".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:street-address).freeze,
      type: "rdf:Property".freeze
    property :title,
      comment: %(The title of the object as it should appear within the graph, e.g.,  "The Rock".).freeze,
      label: "title".freeze,
      range: "ogc:string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:label".freeze,
      type: "rdf:Property".freeze
    property :type,
      comment: %(The type of your object, e.g., "movie".  Depending on the type you specify, other properties may also be required.).freeze,
      label: "type".freeze,
      range: "ogc:string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(rdf:type).freeze,
      type: "rdf:Property".freeze
    property :upc,
      comment: %([DEPRECATED] Universal Product Code for your object.).freeze,
      label: ["upc".freeze, "universal product code".freeze],
      "rdfs:seeAlso" => %(gr:hasEAN_UCC-13).freeze,
      type: "rdf:Property".freeze
    property :url,
      comment: %(The canonical URL of your object that will be used as its permanent ID in the graph, e.g., "http://www.imdb.com/title/tt0117500/".).freeze,
      label: "url".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => [%(dc11:identifier).freeze, %(foaf:homepage).freeze],
      type: "rdf:Property".freeze
    property :video,
      comment: %(A relevant video URL for your object.).freeze,
      label: "video".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:height",
      comment: %(The height of a video.).freeze,
      label: "video height".freeze,
      range: "ogc:integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:secure_url",
      comment: %(A relevant, secure video URL for your object.).freeze,
      label: "video secure URL".freeze,
      range: "ogc:url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:type",
      comment: %(The mime type of a video e.g., "application/x-shockwave-flash").freeze,
      label: "video type".freeze,
      range: "ogc:mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:width",
      comment: %(The width of a video.).freeze,
      label: "video width".freeze,
      range: "ogc:integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
  end
end
