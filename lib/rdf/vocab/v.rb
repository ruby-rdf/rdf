# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://rdf.data-vocabulary.org/
require 'rdf'
module RDF
  class V < StrictVocabulary("http://rdf.data-vocabulary.org/")

    # Class definitions
    term :"#Address",
      comment: %(Postal address for a Person or Organization.).freeze,
      label: "#Address".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Breadcrumb",
      comment: %(Represents a single Breadcrumb in a Breadcrumb trail.
  ).freeze,
      label: "#Breadcrumb".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Offer",
      comment: %(Represents an offer to sell a product.).freeze,
      label: "#Offer".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#OfferAggregate",
      comment: %(
    Represents a collection of offers to sell a product.
  ).freeze,
      label: "#OfferAggregate".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Organization",
      comment: %(An Organization is a business, agency, school, etc.).freeze,
      label: "#Organization".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Person",
      comment: %(Represents a Person, living/dead/fictional.).freeze,
      label: "#Person".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Product",
      comment: %(Represents a product or service in a Review or Review-aggregate.).freeze,
      label: "#Product".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Rating",
      comment: %(Represents a rating in a Review or Review-aggregate.).freeze,
      label: "#Rating".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Recipe",
      comment: %(A single instance of a Recipe.).freeze,
      label: "#Recipe".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Review",
      comment: %(A single instance of a Review.).freeze,
      label: "#Review".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#Review-aggregate",
      comment: %(Represents data from a collection of reviews.
    Can be used whether or not there is instance-level Review data on the page.
  ).freeze,
      label: "#Review-aggregate".freeze,
      subClassOf: "http://rdf.data-vocabulary.org/#Review".freeze,
      type: "rdfs:Class".freeze
    term :"#ingredient",
      comment: %(Represents ingredients used in a recipe.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#ingredient".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#instructions",
      comment: %(Represents the steps to make a dish.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#instructions".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#nutrition",
      comment: %(Represents the nutrition information about a recipe.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#nutrition".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze
    term :"#timeRange",
      comment: %(Represents the length of time it takes to prepare a recipe.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#timeRange".freeze,
      subClassOf: "rdf:Resource".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :"#acquaintance",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#acquaintance".freeze,
      type: "rdf:Property".freeze
    property :"#address",
      domain: "_:g2180795640".freeze,
      label: "#address".freeze,
      range: "http://rdf.data-vocabulary.org/#Address".freeze,
      type: "rdf:Property".freeze
    property :"#affiliation",
      comment: %(An affiliation can be specified by a string literal or an Organization instance.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#affiliation".freeze,
      range: "_:g2180111840".freeze,
      type: "rdf:Property".freeze
    property :"#amount",
      domain: "http://rdf.data-vocabulary.org/#ingredient".freeze,
      label: "#amount".freeze,
      type: "rdf:Property".freeze
    property :"#author",
      comment: %(An author of the recipe can be specified by a string literal or a Person instance.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#author".freeze,
      range: "_:g2228964700".freeze,
      type: "rdf:Property".freeze
    property :"#availability",
      domain: "http://rdf.data-vocabulary.org/#Offer".freeze,
      label: "#availability".freeze,
      type: "rdf:Property".freeze
    property :"#average",
      comment: %(The average of an aggregate value.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#average".freeze,
      type: "rdf:Property".freeze
    property :"#best",
      comment: %(The best value of a rating scale \(default 5\).).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#best".freeze,
      type: "rdf:Property".freeze
    property :"#brand",
      domain: "http://rdf.data-vocabulary.org/#Product".freeze,
      label: "#brand".freeze,
      type: "rdf:Property".freeze
    property :"#calories",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#calories".freeze,
      type: "rdf:Property".freeze
    property :"#carbohydrates",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#carbohydrates".freeze,
      type: "rdf:Property".freeze
    property :"#category",
      domain: "_:g2179781240".freeze,
      label: "#category".freeze,
      type: "rdf:Property".freeze
    property :"#child",
      domain: "http://rdf.data-vocabulary.org/#Breadcrumb".freeze,
      label: "#child".freeze,
      type: "rdf:Property".freeze
    property :"#cholesterol",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#cholesterol".freeze,
      type: "rdf:Property".freeze
    property :"#colleague",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#colleague".freeze,
      type: "rdf:Property".freeze
    property :"#condition",
      domain: "_:g2229901780".freeze,
      label: "#condition".freeze,
      type: "rdf:Property".freeze
    property :"#contact",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#contact".freeze,
      type: "rdf:Property".freeze
    property :"#cookTime",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#cookTime".freeze,
      range: "_:g2229492680".freeze,
      type: "rdf:Property".freeze
    property :"#count",
      comment: %(The total number of items used in an aggregate \(e.g., number of reviews\).).freeze,
      domain: "http://rdf.data-vocabulary.org/#Review-aggregate".freeze,
      label: "#count".freeze,
      type: "rdf:Property".freeze
    property :"#country-name",
      domain: "http://rdf.data-vocabulary.org/#Address".freeze,
      label: "#country-name".freeze,
      type: "rdf:Property".freeze
    property :"#currency",
      domain: "_:g2187546520".freeze,
      label: "#currency".freeze,
      type: "rdf:Property".freeze
    property :"#description",
      domain: "_:g2179106940".freeze,
      label: "#description".freeze,
      type: "rdf:Property".freeze
    property :"#dtreviewed",
      comment: %(The date of the review.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Review".freeze,
      label: "#dtreviewed".freeze,
      type: "rdf:Property".freeze
    property :"#duration",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#duration".freeze,
      range: "_:g2229179440".freeze,
      type: "rdf:Property".freeze
    property :"#fat",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#fat".freeze,
      type: "rdf:Property".freeze
    property :"#fiber",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#fiber".freeze,
      type: "rdf:Property".freeze
    property :"#friend",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#friend".freeze,
      type: "rdf:Property".freeze
    property :"#highprice",
      domain: "http://rdf.data-vocabulary.org/#OfferAggregate".freeze,
      label: "#highprice".freeze,
      type: "rdf:Property".freeze
    property :"#identifier",
      domain: "_:g2187220940".freeze,
      label: "#identifier".freeze,
      type: "rdf:Property".freeze
    property :"#image",
      domain: "http://rdf.data-vocabulary.org/#Product".freeze,
      label: "#image".freeze,
      type: "rdf:Property".freeze
    property :"#instruction",
      domain: "http://rdf.data-vocabulary.org/#instructions".freeze,
      label: "#instruction".freeze,
      type: "rdf:Property".freeze
    property :"#itemoffered",
      domain: "_:g2186645000".freeze,
      label: "#itemoffered".freeze,
      type: "rdf:Property".freeze
    property :"#itemreviewed",
      domain: "http://rdf.data-vocabulary.org/#Review".freeze,
      label: "#itemreviewed".freeze,
      type: "rdf:Property".freeze
    property :"#locality",
      domain: "http://rdf.data-vocabulary.org/#Address".freeze,
      label: "#locality".freeze,
      type: "rdf:Property".freeze
    property :"#lowprice",
      domain: "http://rdf.data-vocabulary.org/#OfferAggregate".freeze,
      label: "#lowprice".freeze,
      type: "rdf:Property".freeze
    property :"#max",
      comment: %(The maximum value of an aggregated Rating.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#max".freeze,
      type: "rdf:Property".freeze
    property :"#min",
      comment: %(The minimum value of an aggregated Rating.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#min".freeze,
      type: "rdf:Property".freeze
    property :"#name",
      domain: "rdf:Resource".freeze,
      label: "#name".freeze,
      type: "rdf:Property".freeze
    property :"#nickname",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#nickname".freeze,
      type: "rdf:Property".freeze
    property :"#offercount",
      domain: "http://rdf.data-vocabulary.org/#OfferAggregate".freeze,
      label: "#offercount".freeze,
      type: "rdf:Property".freeze
    property :"#offerdetails",
      domain: "http://rdf.data-vocabulary.org/#Product".freeze,
      label: "#offerdetails".freeze,
      type: "rdf:Property".freeze
    property :"#offerurl",
      domain: "_:g2188169820".freeze,
      label: "#offerurl".freeze,
      type: "rdf:Property".freeze
    property :"#photo",
      domain: "rdf:Resource".freeze,
      label: "#photo".freeze,
      type: "rdf:Property".freeze
    property :"#postal-code",
      domain: "http://rdf.data-vocabulary.org/#Address".freeze,
      label: "#postal-code".freeze,
      type: "rdf:Property".freeze
    property :"#prepTime",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#prepTime".freeze,
      range: "_:g2229636760".freeze,
      type: "rdf:Property".freeze
    property :"#price",
      domain: "http://rdf.data-vocabulary.org/#Offer".freeze,
      label: "#price".freeze,
      type: "rdf:Property".freeze
    property :"#pricerange",
      comment: %(The price range of products and services offered
    by a restaurant, business or other organization.
  ).freeze,
      domain: "http://rdf.data-vocabulary.org/#Organization".freeze,
      label: "#pricerange".freeze,
      type: "rdf:Property".freeze
    property :"#pricevaliduntil",
      domain: "http://rdf.data-vocabulary.org/#Offer".freeze,
      label: "#pricevaliduntil".freeze,
      type: "rdf:Property".freeze
    property :"#protein",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#protein".freeze,
      type: "rdf:Property".freeze
    property :"#published",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#published".freeze,
      type: "rdf:Property".freeze
    property :"#quantity",
      domain: "http://rdf.data-vocabulary.org/#Offer".freeze,
      label: "#quantity".freeze,
      type: "rdf:Property".freeze
    property :"#rating",
      comment: %(A rating can be specified by a string literal or a Rating instance.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Review".freeze,
      label: "#rating".freeze,
      range: "_:g2170904920".freeze,
      type: "rdf:Property".freeze
    property :"#recipeType",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#recipeType".freeze,
      type: "rdf:Property".freeze
    property :"#region",
      domain: "http://rdf.data-vocabulary.org/#Address".freeze,
      label: "#region".freeze,
      type: "rdf:Property".freeze
    property :"#reviewer",
      comment: %(A reviewer can be specified by a string literal or a Person instance.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Review".freeze,
      label: "#reviewer".freeze,
      range: "_:g2232391340".freeze,
      type: "rdf:Property".freeze
    property :"#role",
      domain: "http://rdf.data-vocabulary.org/#Person".freeze,
      label: "#role".freeze,
      type: "rdf:Property".freeze
    property :"#saturatedFat",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#saturatedFat".freeze,
      type: "rdf:Property".freeze
    property :"#seller",
      domain: "http://rdf.data-vocabulary.org/#Offer".freeze,
      label: "#seller".freeze,
      type: "rdf:Property".freeze
    property :"#servingSize",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#servingSize".freeze,
      type: "rdf:Property".freeze
    property :"#street-address",
      domain: "http://rdf.data-vocabulary.org/#Address".freeze,
      label: "#street-address".freeze,
      type: "rdf:Property".freeze
    property :"#sugar",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#sugar".freeze,
      type: "rdf:Property".freeze
    property :"#summary",
      domain: "_:g2231658960".freeze,
      label: "#summary".freeze,
      type: "rdf:Property".freeze
    property :"#tag",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#tag".freeze,
      type: "rdf:Property".freeze
    property :"#tel",
      domain: "_:g2230660800".freeze,
      label: "#tel".freeze,
      type: "rdf:Property".freeze
    property :"#title",
      domain: "_:g2230547400".freeze,
      label: "#title".freeze,
      type: "rdf:Property".freeze
    property :"#totalTime",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#totalTime".freeze,
      range: "_:g2229356940".freeze,
      type: "rdf:Property".freeze
    property :"#unsaturatedFat",
      domain: "http://rdf.data-vocabulary.org/#nutrition".freeze,
      label: "#unsaturatedFat".freeze,
      type: "rdf:Property".freeze
    property :"#url",
      domain: "_:g2230417740".freeze,
      label: "#url".freeze,
      type: "rdf:Property".freeze
    property :"#value",
      comment: %(The value of a single Rating.).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#value".freeze,
      type: "rdf:Property".freeze
    property :"#worst",
      comment: %(The poorest value of a rating scale \(default 1\).).freeze,
      domain: "http://rdf.data-vocabulary.org/#Rating".freeze,
      label: "#worst".freeze,
      type: "rdf:Property".freeze
    property :"#yield",
      domain: "http://rdf.data-vocabulary.org/#Recipe".freeze,
      label: "#yield".freeze,
      type: "rdf:Property".freeze
  end
end
