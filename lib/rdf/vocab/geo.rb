# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/2003/01/geo/wgs84_pos#
require 'rdf'
module RDF
  # @deprecated Please use `RDF::Vocab::GEO` from the rdf-vocab gem instead
  class GEO < RDF::StrictVocabulary("http://www.w3.org/2003/01/geo/wgs84_pos#")

    # Class definitions
    term :Point,
      comment: [%(A point, typically described using a coordinate system relative to Earth, such as WGS84.
  ).freeze, %( 
Uniquely identified by lat/long/alt. i.e.

spaciallyIntersects\(P1, P2\) :- lat\(P1, LAT\), long\(P1, LONG\), alt\(P1, ALT\),
  lat\(P2, LAT\), long\(P2, LONG\), alt\(P2, ALT\).

sameThing\(P1, P2\) :- type\(P1, Point\), type\(P2, Point\), spaciallyIntersects\(P1, P2\).
  ).freeze],
      label: "point".freeze,
      subClassOf: "geo:SpatialThing".freeze,
      type: "rdfs:Class".freeze
    term :SpatialThing,
      comment: %(Anything with spatial extent, i.e. size, shape, or position.
 e.g. people, places, bowling balls, as well as abstract areas like cubes.
).freeze,
      label: "SpatialThing".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :alt,
      comment: %(The WGS84 altitude of a SpatialThing \(decimal meters 
above the local reference ellipsoid\).).freeze,
      domain: "geo:SpatialThing".freeze,
      label: "altitude".freeze,
      type: "rdf:Property".freeze
    property :lat,
      comment: %(The WGS84 latitude of a SpatialThing \(decimal degrees\).).freeze,
      domain: "geo:SpatialThing".freeze,
      label: "latitude".freeze,
      type: "rdf:Property".freeze
    property :lat_long,
      comment: %(A comma-separated representation of a latitude, longitude coordinate.).freeze,
      label: "lat/long".freeze,
      type: "rdf:Property".freeze
    property :location,
      comment: %(The relation between something and the point, 
 or other geometrical thing in space, where it is.  For example, the realtionship between
 a radio tower and a Point with a given lat and long.
 Or a relationship between a park and its outline as a closed arc of points, or a road and
 its location as a arc \(a sequence of points\).
 Clearly in practice there will be limit to the accuracy of any such statement, but one would expect
 an accuracy appropriate for the size of the object and uses such as mapping .
 ).freeze,
      label: "location".freeze,
      range: "geo:SpatialThing".freeze,
      subPropertyOf: "foaf:based_near".freeze,
      type: "rdf:Property".freeze
    property :long,
      comment: %(The WGS84 longitude of a SpatialThing \(decimal degrees\).).freeze,
      domain: "geo:SpatialThing".freeze,
      label: "longitude".freeze,
      type: "rdf:Property".freeze

    # Extra definitions
    term :"",
      comment: %(
Recent changes to this namespace:
$Log: wgs84_pos.rdf,v $
Revision 1.22  2009/04/20 15:00:30  timbl
Remove the time bits which have been deal with elsewhere eg in iCal.

Revision 1.21  2009/04/20 12:52:47  timbl
try again

Revision 1.20  2009/04/20 12:42:11  timbl
Add Event \(edited ages ago and never checked in\), and location \(following discussion http://chatlogs.planetrdf.com/swig/2009-04-20#T12-36-09\)

Revision 1.19  2009/04/20 12:36:31  timbl
Add Event \(edited ages ago and never checked in\), and location \(following discussion http://chatlogs.planetrdf.com/swig/2009-04-20#T12-36-09\)

Revision 1.18  2006/02/01 22:01:04  danbri
Clarified that lat and long are decimal degrees, and that alt is decimal metres about local reference ellipsoid

Revision 1.17  2004/02/06 17:38:12  danbri
Fixed a bad commit screwup

Revision 1.15  2003/04/19 11:24:08  danbri
Fixed the typo even more.

Revision 1.14  2003/04/19 11:16:56  danbri
fixed a typo

Revision 1.13  2003/02/19 22:27:27  connolly
relaxed domain constraints on lat/long/alt from Point to SpatialThing

Revision 1.12  2003/01/12 01:41:41  danbri
Trying local copy of XSLT doc.

Revision 1.11  2003/01/12 01:20:18  danbri
added a link to morten's xslt rdfs viewer.

Revision 1.10  2003/01/11 18:56:49  danbri
Removed datatype range from lat and long properties, since they would
have required each occurance of the property to mention the datatype.

Revision 1.9  2003/01/11 11:41:31  danbri
Another typo; repaired rdfs:Property to rdf:Property x4

Revision 1.8  2003/01/11 11:05:02  danbri
Added an rdfs:range for each lat/long/alt property,
http://www.w3.org/2001/XMLSchema#float

Revision 1.7  2003/01/10 20:25:16  danbri
Longer rdfs:comment for Point, trying to be Earth-centric and neutral about
coordinate system\(s\) at the same time. Feedback welcomed.

Revision 1.6  2003/01/10 20:18:30  danbri
Added CVS log comments into the RDF/XML as an rdfs:comment property of the
vocabulary. Note that this is not common practice \(but seems both harmless
and potentially useful\).


revision 1.5
date: 2003/01/10 20:14:31;  author: danbri;  state: Exp;  lines: +16 -5
Updated schema:
Added a dc:date, added url for more info. Changed the rdfs:label of the
namespace from gp to geo. Added a class Point, set as the rdfs:domain of
each property. Added XML comment on the lat_long property suggesting that
we might not need it \(based on #rdfig commentary from implementors\).

revision 1.4
date: 2003/01/10 20:01:07;  author: danbri;  state: Exp;  lines: +6 -5
Fixed typo; several rdfs:about attributes are now rdf:about. Thanks to MortenF in
#rdfig for catching this error.

revision 1.3
date: 2003/01/10 11:59:03;  author: danbri;  state: Exp;  lines: +4 -3
fixed buglet in vocab, added more wgs links

revision 1.2
date: 2003/01/10 11:01:11;  author: danbri;  state: Exp;  lines: +4 -4
Removed alt from the as-a-flat-string property, and switched from
space separated to comma separated.

revision 1.1
date: 2003/01/10 10:53:23;  author: danbri;  state: Exp;
basic geo vocab

).freeze,
      "dc11:date" => %($Date: 2009/04/20 15:00:30 $).freeze,
      "dc11:description" => %(A vocabulary for representing latitude, longitude and 
 altitude information in the WGS84 geodetic reference datum. 
 Version $Id: wgs84_pos.rdf,v 1.22 2009/04/20 15:00:30 timbl Exp $. See http://www.w3.org/2003/01/geo/ for more details.).freeze,
      "dc11:title" => %(WGS84 Geo Positioning: an RDF vocabulary).freeze,
      label: "geo".freeze
  end
end
