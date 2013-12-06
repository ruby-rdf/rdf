# This file generated automatically using vocab-fetch from http://www.w3.org/2003/01/geo/wgs84_pos#
require 'rdf'
module RDF
  class GEO < StrictVocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")

    # Class definitions
    property :SpatialThing, :label => 'SpatialThing', :comment =>
      %(Anything with spatial extent, i.e. size, shape, or position.
        e.g. people, places, bowling balls, as well as abstract areas
        like cubes.)
    property :Point, :label => 'point', :comment =>
      %(A point, typically described using a coordinate system
        relative to Earth, such as WGS84.)
    property :Point, :label => 'point', :comment =>
      %(Uniquely identified by lat/long/alt. i.e.
        spaciallyIntersects\(P1, P2\) :- lat\(P1, LAT\), long\(P1,
        LONG\), alt\(P1, ALT\), lat\(P2, LAT\), long\(P2, LONG\),
        alt\(P2, ALT\). sameThing\(P1, P2\) :- type\(P1, Point\),
        type\(P2, Point\), spaciallyIntersects\(P1, P2\).)

    # Property definitions
    property :alt, :label => 'altitude', :comment =>
      %(The WGS84 altitude of a SpatialThing \(decimal meters above
        the local reference ellipsoid\).)
    property :lat_long, :label => 'lat/long', :comment =>
      %(A comma-separated representation of a latitude, longitude
        coordinate.)
    property :lat, :label => 'latitude', :comment =>
      %(The WGS84 latitude of a SpatialThing \(decimal degrees\).)
    property :location, :label => 'location', :comment =>
      %(The relation between something and the point, or other
        geometrical thing in space, where it is. For example, the
        realtionship between a radio tower and a Point with a given
        lat and long. Or a relationship between a park and its outline
        as a closed arc of points, or a road and its location as a arc
        \(a sequence of points\). Clearly in practice there will be
        limit to the accuracy of any such statement, but one would
        expect an accuracy appropriate for the size of the object and
        uses such as mapping .)
    property :long, :label => 'longitude', :comment =>
      %(The WGS84 longitude of a SpatialThing \(decimal degrees\).)
  end
end
