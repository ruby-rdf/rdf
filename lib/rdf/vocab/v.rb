# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from etc/rdf.data-vocab.ttl
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::V` from the rdf-vocab gem instead
  class V < RDF::StrictVocabulary("http://rdf.data-vocabulary.org/#")

    # Class definitions
    term :Address,
      comment: %(Postal address for a Person or Organization.).freeze,
      label: "Address".freeze,
      type: "rdfs:Class".freeze
    term :Breadcrumb,
      comment: %(Represents a single Breadcrumb in a Breadcrumb trail.).freeze,
      label: "Breadcrumb".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Instructions,
      comment: %(Represents the steps to make a dish.).freeze,
      label: "Instructions".freeze,
      type: "rdfs:Class".freeze
    term :Nutrition,
      comment: %(Represents the nutrition information about a recipe.).freeze,
      label: "Nutrition".freeze,
      type: "rdfs:Class".freeze
    term :Offer,
      comment: %(Represents an offer to sell a product.).freeze,
      label: "Offer".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :OfferAggregate,
      comment: %(Represents a collection of offers to sell a product.).freeze,
      label: "OfferAggregate".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Organization,
      comment: %(An Organization is a business, agency, school, etc.).freeze,
      label: "Organization".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Person,
      comment: %(Represents a Person, living/dead/fictional.).freeze,
      label: "Person".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Product,
      comment: %(Represents a product or service in a Review or Review-aggregate.).freeze,
      label: "Product".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Rating,
      comment: %(Represents a rating in a Review or Review-aggregate.).freeze,
      label: "Rating".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Recipe,
      comment: %(A single instance of a Recipe.).freeze,
      label: "Recipe".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :RecipeIngredient,
      comment: %(Represents ingredients used in a recipe.).freeze,
      label: "RecipeIngredient".freeze,
      type: "rdfs:Class".freeze
    term :Review,
      comment: %(A single instance of a Review.).freeze,
      label: "Review".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :"Review-aggregate",
      comment: %(Represents data from a collection of reviews.
    Can be used whether or not there is instance-level Review data on the page.
  ).freeze,
      label: "Review-aggregate".freeze,
      subClassOf: "v:Review".freeze,
      type: "rdfs:Class".freeze
    term :TimeRange,
      comment: %(Represents the length of time it takes to prepare a recipe.).freeze,
      label: "TimeRange".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]

    # Property definitions
    property :acquaintance,
      domain: "v:Person".freeze,
      label: "acquaintance".freeze,
      type: "rdf:Property".freeze
    property :address,
      label: "address".freeze,
      range: "v:Address".freeze,
      type: "rdf:Property".freeze
    property :affiliation,
      comment: %(An affiliation can be specified by a string literal or an Organization instance.).freeze,
      domain: "v:Person".freeze,
      label: "affiliation".freeze,
      type: "rdf:Property".freeze
    property :amount,
      domain: "v:RecipeIngredient".freeze,
      label: "amount".freeze,
      type: "rdf:Property".freeze
    property :author,
      comment: %(An author of the recipe can be specified by a string literal or a Person instance.).freeze,
      domain: "v:Recipe".freeze,
      label: "author".freeze,
      type: "rdf:Property".freeze
    property :availability,
      domain: "v:Offer".freeze,
      label: "availability".freeze,
      type: "rdf:Property".freeze
    property :average,
      comment: %(The average of an aggregate value.).freeze,
      domain: "v:Rating".freeze,
      label: "average".freeze,
      type: "rdf:Property".freeze
    property :best,
      comment: %(The best value of a rating scale \(default 5\).).freeze,
      domain: "v:Rating".freeze,
      label: "best".freeze,
      type: "rdf:Property".freeze
    property :brand,
      domain: "v:Product".freeze,
      label: "brand".freeze,
      type: "rdf:Property".freeze
    property :calories,
      domain: "v:Nutrition".freeze,
      label: "calories".freeze,
      type: "rdf:Property".freeze
    property :carbohydrates,
      domain: "v:Nutrition".freeze,
      label: "carbohydrates".freeze,
      type: "rdf:Property".freeze
    property :category,
      label: "category".freeze,
      type: "rdf:Property".freeze
    property :child,
      domain: "v:Breadcrumb".freeze,
      label: "child".freeze,
      type: "rdf:Property".freeze
    property :cholesterol,
      domain: "v:Nutrition".freeze,
      label: "cholesterol".freeze,
      type: "rdf:Property".freeze
    property :colleague,
      domain: "v:Person".freeze,
      label: "colleague".freeze,
      type: "rdf:Property".freeze
    property :condition,
      label: "condition".freeze,
      type: "rdf:Property".freeze
    property :contact,
      domain: "v:Person".freeze,
      label: "contact".freeze,
      type: "rdf:Property".freeze
    property :cookTime,
      domain: "v:Recipe".freeze,
      label: "cookTime".freeze,
      type: "rdf:Property".freeze
    property :count,
      comment: %(The total number of items used in an aggregate \(e.g., number of reviews\).).freeze,
      domain: "v:Review-aggregate".freeze,
      label: "count".freeze,
      type: "rdf:Property".freeze
    property :"country-name",
      domain: "v:Address".freeze,
      label: "country-name".freeze,
      type: "rdf:Property".freeze
    property :currency,
      label: "currency".freeze,
      type: "rdf:Property".freeze
    property :description,
      label: "description".freeze,
      type: "rdf:Property".freeze
    property :dtreviewed,
      comment: %(The date of the review.).freeze,
      domain: "v:Review".freeze,
      label: "dtreviewed".freeze,
      type: "rdf:Property".freeze
    property :duration,
      domain: "v:Recipe".freeze,
      label: "duration".freeze,
      type: "rdf:Property".freeze
    property :fat,
      domain: "v:Nutrition".freeze,
      label: "fat".freeze,
      type: "rdf:Property".freeze
    property :fiber,
      domain: "v:Nutrition".freeze,
      label: "fiber".freeze,
      type: "rdf:Property".freeze
    property :friend,
      domain: "v:Person".freeze,
      label: "friend".freeze,
      type: "rdf:Property".freeze
    property :highprice,
      domain: "v:OfferAggregate".freeze,
      label: "highprice".freeze,
      type: "rdf:Property".freeze
    property :identifier,
      label: "identifier".freeze,
      type: "rdf:Property".freeze
    property :image,
      domain: "v:Product".freeze,
      label: "image".freeze,
      type: "rdf:Property".freeze
    property :ingredient,
      comment: %(Represents ingredients used in a recipe.).freeze,
      domain: "v:Recipe".freeze,
      label: "ingredient".freeze,
      range: "v:RecipeIngredient".freeze,
      type: "rdf:Property".freeze
    property :instruction,
      domain: "v:Instructions".freeze,
      label: "instruction".freeze,
      type: "rdf:Property".freeze
    property :instructions,
      comment: %(Represents the steps to make a dish.).freeze,
      domain: "v:Recipe".freeze,
      label: "instructions".freeze,
      range: "v:Instructions".freeze,
      type: "rdf:Property".freeze
    property :itemoffered,
      label: "itemoffered".freeze,
      type: "rdf:Property".freeze
    property :itemreviewed,
      domain: "v:Review".freeze,
      label: "itemreviewed".freeze,
      type: "rdf:Property".freeze
    property :locality,
      domain: "v:Address".freeze,
      label: "locality".freeze,
      type: "rdf:Property".freeze
    property :lowprice,
      domain: "v:OfferAggregate".freeze,
      label: "lowprice".freeze,
      type: "rdf:Property".freeze
    property :max,
      comment: %(The maximum value of an aggregated Rating.).freeze,
      label: "max".freeze,
      type: "rdf:Property".freeze
    property :min,
      comment: %(The minimum value of an aggregated Rating.).freeze,
      label: "min".freeze,
      type: "rdf:Property".freeze
    property :name,
      label: "name".freeze,
      type: "rdf:Property".freeze
    property :nickname,
      domain: "v:Person".freeze,
      label: "nickname".freeze,
      type: "rdf:Property".freeze
    property :nutrition,
      comment: %(Represents the nutrition information about a recipe.).freeze,
      domain: "v:Recipe".freeze,
      label: "nutrition".freeze,
      range: "v:Nutrition".freeze,
      type: "rdf:Property".freeze
    property :offercount,
      domain: "v:OfferAggregate".freeze,
      label: "offercount".freeze,
      type: "rdf:Property".freeze
    property :offerdetails,
      domain: "v:Product".freeze,
      label: "offerdetails".freeze,
      type: "rdf:Property".freeze
    property :offerurl,
      label: "offerurl".freeze,
      type: "rdf:Property".freeze
    property :photo,
      label: "photo".freeze,
      type: "rdf:Property".freeze
    property :"postal-code",
      domain: "v:Address".freeze,
      label: "postal-code".freeze,
      type: "rdf:Property".freeze
    property :prepTime,
      domain: "v:Recipe".freeze,
      label: "prepTime".freeze,
      type: "rdf:Property".freeze
    property :price,
      domain: "v:Offer".freeze,
      label: "price".freeze,
      type: "rdf:Property".freeze
    property :pricerange,
      comment: %(The price range of products and services offered
    by a restaurant, business or other organization.
  ).freeze,
      domain: "v:Organization".freeze,
      label: "pricerange".freeze,
      type: "rdf:Property".freeze
    property :pricevaliduntil,
      domain: "v:Offer".freeze,
      label: "pricevaliduntil".freeze,
      type: "rdf:Property".freeze
    property :protein,
      domain: "v:Nutrition".freeze,
      label: "protein".freeze,
      type: "rdf:Property".freeze
    property :published,
      domain: "v:Recipe".freeze,
      label: "published".freeze,
      type: "rdf:Property".freeze
    property :quantity,
      domain: "v:Offer".freeze,
      label: "quantity".freeze,
      type: "rdf:Property".freeze
    property :rating,
      comment: %(A rating can be specified by a string literal or a Rating instance.).freeze,
      domain: "v:Review".freeze,
      label: "rating".freeze,
      type: "rdf:Property".freeze
    property :recipeType,
      domain: "v:Recipe".freeze,
      label: "recipeType".freeze,
      type: "rdf:Property".freeze
    property :region,
      domain: "v:Address".freeze,
      label: "region".freeze,
      type: "rdf:Property".freeze
    property :reviewer,
      comment: %(A reviewer can be specified by a string literal or a Person instance.).freeze,
      domain: "v:Review".freeze,
      label: "reviewer".freeze,
      type: "rdf:Property".freeze
    property :role,
      domain: "v:Person".freeze,
      label: "role".freeze,
      type: "rdf:Property".freeze
    property :saturatedFat,
      domain: "v:Nutrition".freeze,
      label: "saturatedFat".freeze,
      type: "rdf:Property".freeze
    property :seller,
      domain: "v:Offer".freeze,
      label: "seller".freeze,
      type: "rdf:Property".freeze
    property :servingSize,
      domain: "v:Nutrition".freeze,
      label: "servingSize".freeze,
      type: "rdf:Property".freeze
    property :"street-address",
      domain: "v:Address".freeze,
      label: "street-address".freeze,
      type: "rdf:Property".freeze
    property :sugar,
      domain: "v:Nutrition".freeze,
      label: "sugar".freeze,
      type: "rdf:Property".freeze
    property :summary,
      label: "summary".freeze,
      type: "rdf:Property".freeze
    property :tag,
      domain: "v:Recipe".freeze,
      label: "tag".freeze,
      type: "rdf:Property".freeze
    property :tel,
      label: "tel".freeze,
      type: "rdf:Property".freeze
    property :timeRange,
      comment: %(Represents the length of time it takes to prepare a recipe.).freeze,
      domain: "v:Recipe".freeze,
      label: "timeRange".freeze,
      range: "v:TimeRange".freeze,
      type: "rdf:Property".freeze
    property :title,
      label: "title".freeze,
      type: "rdf:Property".freeze
    property :totalTime,
      domain: "v:Recipe".freeze,
      label: "totalTime".freeze,
      type: "rdf:Property".freeze
    property :unsaturatedFat,
      domain: "v:Nutrition".freeze,
      label: "unsaturatedFat".freeze,
      type: "rdf:Property".freeze
    property :url,
      label: "url".freeze,
      type: "rdf:Property".freeze
    property :value,
      comment: %(The value of a single Rating.).freeze,
      domain: "v:Rating".freeze,
      label: "value".freeze,
      type: "rdf:Property".freeze
    property :worst,
      comment: %(The poorest value of a rating scale \(default 1\).).freeze,
      domain: "v:Rating".freeze,
      label: "worst".freeze,
      type: "rdf:Property".freeze
    property :yield,
      domain: "v:Recipe".freeze,
      label: "yield".freeze,
      type: "rdf:Property".freeze
  end
end
