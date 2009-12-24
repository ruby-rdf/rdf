RDF.rb: RDF API for Ruby
========================

This is a pure-Ruby library for working with Resource Description Framework
(RDF) data.

### About the Resource Description Framework (RDF)

* <http://www.w3.org/RDF/>
* <http://en.wikipedia.org/wiki/Resource_Description_Framework>

Examples
--------

    require 'rdf'

### Creating an RDF statement

    s = RDF::URI.parse("http://gemcutter.org/gems/rdf")
    p = RDF::DC.creator
    o = RDF::URI.parse("http://ar.to/#self")
    
    stmt = RDF::Statement.new(s, p, o)

### Using pre-defined RDF vocabularies

    include RDF
    
    DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
    FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
    RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
    RSS.title     #=> RDF::URI("http://purl.org/rss/1.0/title")
    OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
    XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")

### Using ad-hoc RDF vocabularies

    foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
    foaf.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
    foaf[:name]   #=> RDF::URI("http://xmlns.com/foaf/0.1/name")
    foaf['mbox']  #=> RDF::URI("http://xmlns.com/foaf/0.1/mbox")

### Reading N-Triples data

    RDF::Reader::NTriples.open("spec/data/test.nt") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

Documentation
-------------

* <http://rdf.rubyforge.org/>

### RDF Objects

* [RDF::Graph](http://rdf.rubyforge.org/RDF/Graph.html)
* [RDF::Literal](http://rdf.rubyforge.org/RDF/Literal.html)
* [RDF::Node](http://rdf.rubyforge.org/RDF/Node.html)
* [RDF::Resource](http://rdf.rubyforge.org/RDF/Resource.html)
* [RDF::Statement](http://rdf.rubyforge.org/RDF/Statement.html)
* [RDF::URI](http://rdf.rubyforge.org/RDF/URI.html)
* [RDF::Value](http://rdf.rubyforge.org/RDF/Value.html)

### RDF Serialization

* [RDF::Reader](http://rdf.rubyforge.org/RDF/Reader.html)
* [RDF::Writer](http://rdf.rubyforge.org/RDF/Writer.html)

### RDF Vocabularies

* [RDF::CC](http://rdf.rubyforge.org/RDF/CC.html) - Creative Commons (CC)
* [RDF::DC](http://rdf.rubyforge.org/RDF/DC.html) - Dublin Core (DC)
* [RDF::DOAP](http://rdf.rubyforge.org/RDF/DOAP.html) - Description of a Project (DOAP)
* [RDF::EXIF](http://rdf.rubyforge.org/RDF/EXIF.html) - Exchangeable Image File Format (EXIF)
* [RDF::FOAF](http://rdf.rubyforge.org/RDF/FOAF.html) - Friend of a Friend (FOAF)
* [RDF::HTTP](http://rdf.rubyforge.org/RDF/HTTP.html) - Hypertext Transfer Protocol (HTTP)
* [RDF::OWL](http://rdf.rubyforge.org/RDF/OWL.html) - Web Ontology Language (OWL)
* [RDF::RDFS](http://rdf.rubyforge.org/RDF/RDFS.html) - RDF Schema (RDFS)
* [RDF::RSS](http://rdf.rubyforge.org/RDF/RSS.html) - RDF Site Summary (RSS)
* [RDF::SIOC](http://rdf.rubyforge.org/RDF/SIOC.html) - Semantically-Interlinked Online Communities (SIOC)
* [RDF::SKOS](http://rdf.rubyforge.org/RDF/SKOS.html) - Simple Knowledge Organization System (SKOS)
* [RDF::WOT](http://rdf.rubyforge.org/RDF/WOT.html) - Web of Trust (WOT)
* [RDF::XHTML](http://rdf.rubyforge.org/RDF/XHTML.html) - Extensible HyperText Markup Language (XHTML)
* [RDF::XSD](http://rdf.rubyforge.org/RDF/XSD.html) - XML Schema (XSD)

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdf/tarball/master

Dependencies
------------

* [Addressable](http://addressable.rubyforge.org/) (>= 2.1.1)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

    % [sudo] gem install rdf

Resources
---------

* <http://rdf.rubyforge.org/>
* <http://github.com/bendiken/rdf>
* <http://gemcutter.org/gems/rdf>
* <http://rubyforge.org/projects/rdf/>
* <http://raa.ruby-lang.org/project/rdf>

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

RDF.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.
