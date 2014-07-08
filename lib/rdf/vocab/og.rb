# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://ogp.me/ns#
require 'rdf'
module RDF
  class OG < RDF::StrictVocabulary("http://ogp.me/ns#")

    # Property definitions
    property :audio,
      label: "audio".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:album",
      label: "audio:album".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:artist",
      label: "audio:artist".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:secure_url",
      label: "audio:secure_url".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:title",
      label: "audio:title".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:type",
      label: "audio:type".freeze,
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"country-name",
      label: "country-name".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:country-name).freeze,
      type: "rdf:Property".freeze
    property :description,
      label: "description".freeze,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:comment".freeze,
      type: "rdf:Property".freeze
    property :determiner,
      label: "determiner".freeze,
      range: "http://ogp.me/ns/class#determiner_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :email,
      label: "email".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:mbox).freeze,
      type: "rdf:Property".freeze
    property :fax_number,
      label: "fax_number".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :image,
      label: "image".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:height",
      label: "image:height".freeze,
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:secure_url",
      label: "image:secure_url".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:type",
      label: "image:type".freeze,
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:width",
      label: "image:width".freeze,
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :isbn,
      label: "isbn".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(http://purl.org/ontology/bibo/isbn).freeze,
      type: "rdf:Property".freeze
    property :latitude,
      label: "latitude".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:lat).freeze,
      type: "rdf:Property".freeze
    property :locale,
      label: "locale".freeze,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :locality,
      label: "locality".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:locality).freeze,
      type: "rdf:Property".freeze
    property :longitude,
      label: "longitude".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:long).freeze,
      type: "rdf:Property".freeze
    property :phone_number,
      label: "phone_number".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :"postal-code",
      label: "postal-code".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:postal-code).freeze,
      type: "rdf:Property".freeze
    property :region,
      label: "region".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:region).freeze,
      type: "rdf:Property".freeze
    property :site_name,
      label: "site_name".freeze,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"street-address",
      label: "street-address".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:street-address).freeze,
      type: "rdf:Property".freeze
    property :title,
      label: "title".freeze,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:label".freeze,
      type: "rdf:Property".freeze
    property :type,
      label: "type".freeze,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(rdf:type).freeze,
      type: "rdf:Property".freeze
    property :upc,
      label: "upc".freeze,
      "rdfs:seeAlso" => %(gr:hasEAN_UCC-13).freeze,
      type: "rdf:Property".freeze
    property :url,
      label: "url".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => [%(dc11:identifier).freeze, %(foaf:homepage).freeze],
      type: "rdf:Property".freeze
    property :video,
      label: "video".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:height",
      label: "video:height".freeze,
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:secure_url",
      label: "video:secure_url".freeze,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:type",
      label: "video:type".freeze,
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:width",
      label: "video:width".freeze,
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
  end
end
