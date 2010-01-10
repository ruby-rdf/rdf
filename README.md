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

    RDF::NTriples::Reader.open("spec/data/test.nt") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

Documentation
-------------

* <http://rdf.rubyforge.org/>

### RDF Objects

* {RDF::Graph}
* {RDF::Literal}
* {RDF::Node}
* {RDF::Resource}
* {RDF::Statement}
* {RDF::URI}
* {RDF::Value}

### RDF Serialization

* {RDF::Format}
* {RDF::Reader}
* {RDF::Writer}

### RDF Serialization Formats

* {RDF::NTriples}

### RDF Storage

* {RDF::Repository}

### RDF Querying

* {RDF::Query}
* {RDF::Query::Pattern}
* {RDF::Query::Solution}
* {RDF::Query::Variable}

### RDF Vocabularies

* {RDF::CC}    - Creative Commons (CC)
* {RDF::DC}    - Dublin Core (DC)
* {RDF::DOAP}  - Description of a Project (DOAP)
* {RDF::EXIF}  - Exchangeable Image File Format (EXIF)
* {RDF::FOAF}  - Friend of a Friend (FOAF)
* {RDF::HTTP}  - Hypertext Transfer Protocol (HTTP)
* {RDF::OWL}   - Web Ontology Language (OWL)
* {RDF::RDFS}  - RDF Schema (RDFS)
* {RDF::RSS}   - RDF Site Summary (RSS)
* {RDF::SIOC}  - Semantically-Interlinked Online Communities (SIOC)
* {RDF::SKOS}  - Simple Knowledge Organization System (SKOS)
* {RDF::WOT}   - Web of Trust (WOT)
* {RDF::XHTML} - Extensible HyperText Markup Language (XHTML)
* {RDF::XSD}   - XML Schema (XSD)

Dependencies
------------

* [Addressable](http://addressable.rubyforge.org/) (>= 2.1.1)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

    % [sudo] gem install rdf

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdf/tarball/master

Resources
---------

* <http://rdf.rubyforge.org/>
* <http://github.com/bendiken/rdf>
* <http://gemcutter.org/gems/rdf>
* <http://rubyforge.org/projects/rdf/>
* <http://raa.ruby-lang.org/project/rdf/>

See also
--------

* [RDFS.rb](http://rdfs.rubyforge.org/)
* [RDFize](http://rdfize.rubyforge.org/)
* [RDFbus](http://rdfbus.rubyforge.org/)
* [RDFcache](http://rdfcache.rubyforge.org/)

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>
* [Ben Lavender](mailto:blavender@gmail.com) - <http://bhuga.net/>

License
-------

RDF.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.
