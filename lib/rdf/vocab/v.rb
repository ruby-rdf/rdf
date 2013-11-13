# This file generated automatically using vocab-fetch from http://rdf.data-vocabulary.org/#
require 'rdf'
module RDF
  class V < StrictVocabulary("http://rdf.data-vocabulary.org/")

    # Class definitions
    property :Address, :comment =>
      %(Postal address for a Person or Organization.)
    property :Breadcrumb, :comment =>
      %(Represents a single Breadcrumb in a Breadcrumb trail.)
    property :Breadcrumb, :comment =>
      %(Represents a single Breadcrumb in a Breadcrumb trail.)
    property :Offer, :comment =>
      %(Represents an offer to sell a product.)
    property :Offer, :comment =>
      %(Represents an offer to sell a product.)
    property :OfferAggregate, :comment =>
      %(Represents a collection of offers to sell a product.)
    property :OfferAggregate, :comment =>
      %(Represents a collection of offers to sell a product.)
    property :Organization, :comment =>
      %(An Organization is a business, agency, school, etc.)
    property :Organization, :comment =>
      %(An Organization is a business, agency, school, etc.)
    property :Person, :comment =>
      %(Represents a Person, living/dead/fictional.)
    property :Person, :comment =>
      %(Represents a Person, living/dead/fictional.)
    property :Product, :comment =>
      %(Represents a product or service in a Review or
        Review-aggregate.)
    property :Product, :comment =>
      %(Represents a product or service in a Review or
        Review-aggregate.)
    property :Rating, :comment =>
      %(Represents a rating in a Review or Review-aggregate.)
    property :Rating, :comment =>
      %(Represents a rating in a Review or Review-aggregate.)
    property :Recipe, :comment =>
      %(A single instance of a Recipe.)
    property :Recipe, :comment =>
      %(A single instance of a Recipe.)
    property :Review, :comment =>
      %(A single instance of a Review.)
    property :Review, :comment =>
      %(A single instance of a Review.)
    property :"Review-aggregate", :comment =>
      %(Represents data from a collection of reviews. Can be used
        whether or not there is instance-level Review data on the
        page.)
    property :ingredient, :comment =>
      %(Represents ingredients used in a recipe.)
    property :instructions, :comment =>
      %(Represents the steps to make a dish.)
    property :nutrition, :comment =>
      %(Represents the nutrition information about a recipe.)
    property :timeRange, :comment =>
      %(Represents the length of time it takes to prepare a recipe.)
    property :timeRange, :comment =>
      %(Represents the length of time it takes to prepare a recipe.)

    # Property definitions
    property :acquaintance
    property :address
    property :affiliation, :comment =>
      %(An affiliation can be specified by a string literal or an
        Organization instance.)
    property :amount
    property :author, :comment =>
      %(An author of the recipe can be specified by a string literal
        or a Person instance.)
    property :availability
    property :average, :comment =>
      %(The average of an aggregate value.)
    property :best, :comment =>
      %(The best value of a rating scale \(default 5\).)
    property :brand
    property :calories
    property :carbohydrates
    property :category
    property :child
    property :cholesterol
    property :colleague
    property :condition
    property :contact
    property :cookTime
    property :count, :comment =>
      %(The total number of items used in an aggregate \(e.g., number
        of reviews\).)
    property :"country-name"
    property :currency
    property :description
    property :dtreviewed, :comment =>
      %(The date of the review.)
    property :duration
    property :fat
    property :fiber
    property :friend
    property :highprice
    property :identifier
    property :image
    property :instruction
    property :itemoffered
    property :itemreviewed
    property :locality
    property :lowprice
    property :max, :comment =>
      %(The maximum value of an aggregated Rating.)
    property :min, :comment =>
      %(The minimum value of an aggregated Rating.)
    property :name
    property :nickname
    property :offercount
    property :offerdetails
    property :offerurl
    property :photo
    property :"postal-code"
    property :prepTime
    property :price
    property :pricerange, :comment =>
      %(The price range of products and services offered by a
        restaurant, business or other organization.)
    property :pricevaliduntil
    property :protein
    property :published
    property :quantity
    property :rating, :comment =>
      %(A rating can be specified by a string literal or a Rating
        instance.)
    property :recipeType
    property :region
    property :reviewer, :comment =>
      %(A reviewer can be specified by a string literal or a Person
        instance.)
    property :role
    property :saturatedFat
    property :seller
    property :servingSize
    property :"street-address"
    property :sugar
    property :summary
    property :tag
    property :tel
    property :title
    property :totalTime
    property :unsaturatedFat
    property :url
    property :value, :comment =>
      %(The value of a single Rating.)
    property :worst, :comment =>
      %(The poorest value of a rating scale \(default 1\).)
    property :yield
  end
end
