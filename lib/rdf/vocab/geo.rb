module RDF
  ##
  # WGS84 Geo Positioning (GEO) vocabulary.
  #
  # @see   http://www.w3.org/2003/01/geo/wgs84_pos#
  # @since 0.2.0
  class GEO < Vocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")
    property :lat
    property :location
    property :long
    property :lat_long
  end
end
