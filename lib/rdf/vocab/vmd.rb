# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from etc/data-vocab.ttl
require 'rdf'
module RDF
  class VMD < StrictVocabulary("http://data-vocabulary.org/")

    # Class definitions
    term :Address,
      comment: %(Postal address for a Person or Organization.).freeze,
      label: "Address".freeze,
      type: "rdfs:Class".freeze
    term :Breadcrumb,
      comment: %(Represents a single Breadcrumb in a Breadcrumb trail.).freeze,
      label: "Breadcrumb".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :Ingredient,
      comment: %(Represents ingredients used in a recipe.).freeze,
      label: "Ingredient".freeze,
      type: "rdfs:Class".freeze
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
    term :Review,
      comment: %(A single instance of a Review.).freeze,
      label: "Review".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]
    term :"Review-aggregate",
      comment: %(Represents data from a collection of reviews.
    Can be used whether or not there is instance-level Review data on the page.
  ).freeze,
      label: "Review-aggregate".freeze,
      subClassOf: "http://data-vocabulary.org/Review".freeze,
      type: "rdfs:Class".freeze
    term :TimeRange,
      comment: %(Represents the length of time it takes to prepare a recipe.).freeze,
      label: "TimeRange".freeze,
      type: ["rdfs:Class".freeze, "owl:Class".freeze]

    # Property definitions
    property :acquaintance,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "acquaintance".freeze,
      type: "rdf:Property".freeze
    property :address,
      label: "address".freeze,
      range: "http://data-vocabulary.org/Address".freeze,
      type: "rdf:Property".freeze
    property :affiliation,
      comment: %(An affiliation can be specified by a string literal or an Organization instance.).freeze,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "affiliation".freeze,
      type: "rdf:Property".freeze
    property :amount,
      domain: "http://data-vocabulary.org/Ingredient".freeze,
      label: "amount".freeze,
      type: "rdf:Property".freeze
    property :author,
      comment: %(An author of the recipe can be specified by a string literal or a Person instance.).freeze,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "author".freeze,
      type: "rdf:Property".freeze
    property :availability,
      domain: "http://data-vocabulary.org/Offer".freeze,
      label: "availability".freeze,
      type: "rdf:Property".freeze
    property :average,
      comment: %(The average of an aggregate value.).freeze,
      domain: "http://data-vocabulary.org/Rating".freeze,
      label: "average".freeze,
      type: "rdf:Property".freeze
    property :best,
      comment: %(The best value of a rating scale \(default 5\).).freeze,
      domain: "http://data-vocabulary.org/Rating".freeze,
      label: "best".freeze,
      type: "rdf:Property".freeze
    property :brand,
      domain: "http://data-vocabulary.org/Product".freeze,
      label: "brand".freeze,
      type: "rdf:Property".freeze
    property :calories,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "calories".freeze,
      type: "rdf:Property".freeze
    property :carbohydrates,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "carbohydrates".freeze,
      type: "rdf:Property".freeze
    property :category,
      label: "category".freeze,
      type: "rdf:Property".freeze
    property :child,
      domain: "http://data-vocabulary.org/Breadcrumb".freeze,
      label: "child".freeze,
      type: "rdf:Property".freeze
    property :cholesterol,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "cholesterol".freeze,
      type: "rdf:Property".freeze
    property :colleague,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "colleague".freeze,
      type: "rdf:Property".freeze
    property :condition,
      label: "condition".freeze,
      type: "rdf:Property".freeze
    property :contact,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "contact".freeze,
      type: "rdf:Property".freeze
    property :cookTime,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "cookTime".freeze,
      type: "rdf:Property".freeze
    property :count,
      comment: %(The total number of items used in an aggregate \(e.g., number of reviews\).).freeze,
      domain: "http://data-vocabulary.org/Review-aggregate".freeze,
      label: "count".freeze,
      type: "rdf:Property".freeze
    property :"country-name",
      domain: "http://data-vocabulary.org/Address".freeze,
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
      domain: "http://data-vocabulary.org/Review".freeze,
      label: "dtreviewed".freeze,
      type: "rdf:Property".freeze
    property :duration,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "duration".freeze,
      type: "rdf:Property".freeze
    property :fat,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "fat".freeze,
      type: "rdf:Property".freeze
    property :fiber,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "fiber".freeze,
      type: "rdf:Property".freeze
    property :friend,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "friend".freeze,
      type: "rdf:Property".freeze
    property :highprice,
      domain: "http://data-vocabulary.org/OfferAggregate".freeze,
      label: "highprice".freeze,
      type: "rdf:Property".freeze
    property :identifier,
      label: "identifier".freeze,
      type: "rdf:Property".freeze
    property :image,
      domain: "http://data-vocabulary.org/Product".freeze,
      label: "image".freeze,
      type: "rdf:Property".freeze
    property :ingredient,
      comment: %(Represents ingredients used in a recipe.).freeze,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "ingredient".freeze,
      range: "http://data-vocabulary.org/Ingredient".freeze,
      type: "rdf:Property".freeze
    property :instruction,
      domain: "http://data-vocabulary.org/Instructions".freeze,
      label: "instruction".freeze,
      type: "rdf:Property".freeze
    property :instructions,
      comment: %(Represents the steps to make a dish.).freeze,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "instructions".freeze,
      range: "http://data-vocabulary.org/Instructions".freeze,
      type: "rdf:Property".freeze
    property :itemoffered,
      label: "itemoffered".freeze,
      type: "rdf:Property".freeze
    property :itemreviewed,
      domain: "http://data-vocabulary.org/Review".freeze,
      label: "itemreviewed".freeze,
      type: "rdf:Property".freeze
    property :locality,
      domain: "http://data-vocabulary.org/Address".freeze,
      label: "locality".freeze,
      type: "rdf:Property".freeze
    property :lowprice,
      domain: "http://data-vocabulary.org/OfferAggregate".freeze,
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
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "nickname".freeze,
      type: "rdf:Property".freeze
    property :nutrition,
      comment: %(Represents the nutrition information about a recipe.).freeze,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "nutrition".freeze,
      range: "http://data-vocabulary.org/Nutrition".freeze,
      type: "rdf:Property".freeze
    property :offercount,
      domain: "http://data-vocabulary.org/OfferAggregate".freeze,
      label: "offercount".freeze,
      type: "rdf:Property".freeze
    property :offerdetails,
      domain: "http://data-vocabulary.org/Product".freeze,
      label: "offerdetails".freeze,
      type: "rdf:Property".freeze
    property :offerurl,
      label: "offerurl".freeze,
      type: "rdf:Property".freeze
    property :photo,
      label: "photo".freeze,
      type: "rdf:Property".freeze
    property :"postal-code",
      domain: "http://data-vocabulary.org/Address".freeze,
      label: "postal-code".freeze,
      type: "rdf:Property".freeze
    property :prepTime,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "prepTime".freeze,
      type: "rdf:Property".freeze
    property :price,
      domain: "http://data-vocabulary.org/Offer".freeze,
      label: "price".freeze,
      type: "rdf:Property".freeze
    property :pricerange,
      comment: %(The price range of products and services offered
    by a restaurant, business or other organization.
  ).freeze,
      domain: "http://data-vocabulary.org/Organization".freeze,
      label: "pricerange".freeze,
      type: "rdf:Property".freeze
    property :pricevaliduntil,
      domain: "http://data-vocabulary.org/Offer".freeze,
      label: "pricevaliduntil".freeze,
      type: "rdf:Property".freeze
    property :protein,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "protein".freeze,
      type: "rdf:Property".freeze
    property :published,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "published".freeze,
      type: "rdf:Property".freeze
    property :quantity,
      domain: "http://data-vocabulary.org/Offer".freeze,
      label: "quantity".freeze,
      type: "rdf:Property".freeze
    property :rating,
      comment: %(A rating can be specified by a string literal or a Rating instance.).freeze,
      domain: "http://data-vocabulary.org/Review".freeze,
      label: "rating".freeze,
      type: "rdf:Property".freeze
    property :recipeType,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "recipeType".freeze,
      type: "rdf:Property".freeze
    property :region,
      domain: "http://data-vocabulary.org/Address".freeze,
      label: "region".freeze,
      type: "rdf:Property".freeze
    property :reviewer,
      comment: %(A reviewer can be specified by a string literal or a Person instance.).freeze,
      domain: "http://data-vocabulary.org/Review".freeze,
      label: "reviewer".freeze,
      type: "rdf:Property".freeze
    property :role,
      domain: "http://data-vocabulary.org/Person".freeze,
      label: "role".freeze,
      type: "rdf:Property".freeze
    property :saturatedFat,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "saturatedFat".freeze,
      type: "rdf:Property".freeze
    property :seller,
      domain: "http://data-vocabulary.org/Offer".freeze,
      label: "seller".freeze,
      type: "rdf:Property".freeze
    property :servingSize,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "servingSize".freeze,
      type: "rdf:Property".freeze
    property :"street-address",
      domain: "http://data-vocabulary.org/Address".freeze,
      label: "street-address".freeze,
      type: "rdf:Property".freeze
    property :sugar,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "sugar".freeze,
      type: "rdf:Property".freeze
    property :summary,
      label: "summary".freeze,
      type: "rdf:Property".freeze
    property :tag,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "tag".freeze,
      type: "rdf:Property".freeze
    property :tel,
      label: "tel".freeze,
      type: "rdf:Property".freeze
    property :timeRange,
      comment: %(Represents the length of time it takes to prepare a recipe.).freeze,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "timeRange".freeze,
      range: "http://data-vocabulary.org/TimeRange".freeze,
      type: "rdf:Property".freeze
    property :title,
      label: "title".freeze,
      type: "rdf:Property".freeze
    property :totalTime,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "totalTime".freeze,
      type: "rdf:Property".freeze
    property :unsaturatedFat,
      domain: "http://data-vocabulary.org/Nutrition".freeze,
      label: "unsaturatedFat".freeze,
      type: "rdf:Property".freeze
    property :url,
      label: "url".freeze,
      type: "rdf:Property".freeze
    property :value,
      comment: %(The value of a single Rating.).freeze,
      domain: "http://data-vocabulary.org/Rating".freeze,
      label: "value".freeze,
      type: "rdf:Property".freeze
    property :worst,
      comment: %(The poorest value of a rating scale \(default 1\).).freeze,
      domain: "http://data-vocabulary.org/Rating".freeze,
      label: "worst".freeze,
      type: "rdf:Property".freeze
    property :yield,
      domain: "http://data-vocabulary.org/Recipe".freeze,
      label: "yield".freeze,
      type: "rdf:Property".freeze
  end
end
