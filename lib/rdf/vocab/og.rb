# This file generated automatically using vocab-fetch from http://ogp.me/ns#
require 'rdf'
module RDF
  class OG < StrictVocabulary("http://ogp.me/ns#")

    # Property definitions
    property :isbn, :label => 'International Standard Book Number', :comment =>
      %([DEPRECATED] International Standard Book Number for you
        object.)
    property :audio, :label => 'audio', :comment =>
      %(A relevant audio URL for your object.)
    property :"audio:album", :label => 'audio album', :comment =>
      %([DEPRECATED] An album to which some audio belongs.)
    property :"audio:artist", :label => 'audio artist', :comment =>
      %([DEPRECATED] An artist of some audio.)
    property :"audio:secure_url", :label => 'audio secure URL', :comment =>
      %(A relevant, secure audio URL for your object.)
    property :"audio:title", :label => 'audio title', :comment =>
      %([DEPRECATED] A title for some audio.)
    property :"audio:type", :label => 'audio type', :comment =>
      %(The mime type of an audio file e.g., "application/mp3")
    property :"country-name", :label => 'country name', :comment =>
      %([DEPRECATED] The country name of the resource e.g., "USA")
    property :description, :label => 'description', :comment =>
      %(A one to two sentence description of your object.)
    property :determiner, :label => 'determiner', :comment =>
      %(The word to precede the object's title in a sentence \(e.g.,
        "the" in "the statue of liberty"\). Valid values are "a",
        "an", "the", "", and "auto".)
    property :email, :label => 'email', :comment =>
      %([DEPRECATED] Email of the contact for your object.)
    property :fax_number, :label => 'fax number', :comment =>
      %([DEPRECATED] Fax number of the contact for your object.)
    property :image, :label => 'image', :comment =>
      %(An image URL which should represent your object within the
        graph.)
    property :"image:height", :label => 'image height', :comment =>
      %(The height of an image.)
    property :"image:secure_url", :label => 'image secure url', :comment =>
      %(A secure image URL which should represent your object within
        the graph.)
    property :"image:type", :label => 'image type', :comment =>
      %(The mime type of an image.)
    property :"image:width", :label => 'image width', :comment =>
      %(The width of an image.)
    property :isbn, :label => 'isbn', :comment =>
      %([DEPRECATED] International Standard Book Number for you
        object.)
    property :latitude, :label => 'latitude', :comment =>
      %([DEPRECATED] The latitude of the resource e.g., the latitude
        of a company.)
    property :locale, :label => 'locale', :comment =>
      %(A Unix locale in which this markup is rendered.)
    property :locality, :label => 'locality', :comment =>
      %([DEPRECATED] The locality of the resource e.g, "Palo Alto")
    property :longitude, :label => 'longitude', :comment =>
      %([DEPRECATED] The longitude of the resource e.g., the longitude
        of a company.)
    property :phone_number, :label => 'phone number', :comment =>
      %([DEPRECATED] Phone number of the contact for your object.)
    property :"postal-code", :label => 'postal code', :comment =>
      %([DEPRECATED] The postal code of the resource e.g., "94304")
    property :region, :label => 'region', :comment =>
      %([DEPRECATED] The region of the resource e.g., "CA")
    property :site_name, :label => 'site name', :comment =>
      %(If your object is part of a larger web site, the name which
        should be displayed for the overall site. e.g., "IMDb".)
    property :"street-address", :label => 'street address', :comment =>
      %([DEPRECATED] The street address of the resource e.g., "1601 S
        California Ave".)
    property :title, :label => 'title', :comment =>
      %(The title of the object as it should appear within the graph,
        e.g., "The Rock".)
    property :type, :label => 'type', :comment =>
      %(The type of your object, e.g., "movie". Depending on the type
        you specify, other properties may also be required.)
    property :upc, :label => 'universal product code', :comment =>
      %([DEPRECATED] Universal Product Code for your object.)
    property :upc, :label => 'upc', :comment =>
      %([DEPRECATED] Universal Product Code for your object.)
    property :url, :label => 'url', :comment =>
      %(The canonical URL of your object that will be used as its
        permanent ID in the graph, e.g.,
        "http://www.imdb.com/title/tt0117500/".)
    property :video, :label => 'video', :comment =>
      %(A relevant video URL for your object.)
    property :"video:height", :label => 'video height', :comment =>
      %(The height of a video.)
    property :"video:secure_url", :label => 'video secure URL', :comment =>
      %(A relevant, secure video URL for your object.)
    property :"video:type", :label => 'video type', :comment =>
      %(The mime type of a video e.g., "application/x-shockwave-flash")
    property :"video:width", :label => 'video width', :comment =>
      %(The width of a video.)

    # Datatype definitions
  end
end
