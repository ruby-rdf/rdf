# This file generated automatically using vocab-fetch from http://ogp.me/ns#
require 'rdf'
module RDF
  class OG < StrictVocabulary("http://ogp.me/ns#")

    # Property definitions
    property :audio,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:album",
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:artist",
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:secure_url",
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:title",
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"audio:type",
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"country-name",
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:country-name).freeze,
      type: "rdf:Property".freeze
    property :description,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:comment".freeze,
      type: "rdf:Property".freeze
    property :determiner,
      range: "http://ogp.me/ns/class#determiner_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :email,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:mbox).freeze,
      type: "rdf:Property".freeze
    property :fax_number,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :image,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:height",
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:secure_url",
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:depiction).freeze,
      type: "rdf:Property".freeze
    property :"image:type",
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"image:width",
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :isbn,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(http://purl.org/ontology/bibo/isbn).freeze,
      type: "rdf:Property".freeze
    property :latitude,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:lat).freeze,
      type: "rdf:Property".freeze
    property :locale,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :locality,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:locality).freeze,
      type: "rdf:Property".freeze
    property :longitude,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(geo:long).freeze,
      type: "rdf:Property".freeze
    property :phone_number,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(foaf:phone).freeze,
      type: "rdf:Property".freeze
    property :"postal-code",
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:postal-code).freeze,
      type: "rdf:Property".freeze
    property :region,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:region).freeze,
      type: "rdf:Property".freeze
    property :site_name,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"street-address",
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(vcard:street-address).freeze,
      type: "rdf:Property".freeze
    property :title,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      subPropertyOf: "rdfs:label".freeze,
      type: "rdf:Property".freeze
    property :type,
      range: "http://ogp.me/ns/class#string".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(rdf:type).freeze,
      type: "rdf:Property".freeze
    property :upc,
      "rdfs:seeAlso" => %(gr:hasEAN_UCC-13).freeze,
      type: "rdf:Property".freeze
    property :url,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      "rdfs:seeAlso" => %(dc11:identifier).freeze,
      type: "rdf:Property".freeze
    property :video,
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:height",
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:secure_url",
      range: "http://ogp.me/ns/class#url".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:type",
      range: "http://ogp.me/ns/class#mime_type_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
    property :"video:width",
      range: "http://ogp.me/ns/class#integer_str".freeze,
      "rdfs:isDefinedBy" => %(og:).freeze,
      type: "rdf:Property".freeze
  end
end
