RDF.rb: Linked Data for Ruby
============================

This is a pure-Ruby library for working with [Resource Description Framework
(RDF)][RDF] data.

* <http://github.com/bendiken/rdf>
* <http://blog.datagraph.org/2010/03/rdf-for-ruby>
* <http://blog.datagraph.org/2010/04/rdf-repository-howto>

Features
--------

* 100% pure Ruby with minimal dependencies and no bloat.
* 100% free and unencumbered [public domain](http://unlicense.org/) software.
* Provides a clean, well-designed RDF object model and related APIs.
* Supports parsing and serializing N-Triples out of the box, with more
  serialization format support available through add-on plugins.
* Plays nice with others: entirely contained in the `RDF` module, and does
  not modify any of Ruby's core classes or standard library.
* Based entirely on Ruby's autoloading, meaning that you can generally make
  use of any one part of the library without needing to load up the rest.
* Compatible with Ruby 1.8.x, Ruby 1.9.x, and JRuby (tested with JRuby 1.4).

Examples
--------

    require 'rdf'

### Creating an RDF statement

    s = RDF::URI("http://rubygems.org/gems/rdf")
    p = RDF::DC.creator
    o = RDF::URI("http://ar.to/#self")
    
    stmt = RDF::Statement(s, p, o)

### Using pre-defined RDF vocabularies

    include RDF
    
    DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
    FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
    RDF.type      #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
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

    RDF::Reader.open("spec/data/test.nt") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

Documentation
-------------

<http://rdf.rubyforge.org/>

### RDF Object Model

* {RDF::Value}
  * {RDF::Literal}
  * {RDF::Resource}
    * {RDF::Node}
    * {RDF::URI}
    * {RDF::Graph}
  * {RDF::Statement}

### RDF Serialization

* {RDF::Format}
* {RDF::Reader}
* {RDF::Writer}

### RDF Serialization Formats

* {RDF::NTriples}
* [`RDF::JSON`](http://rdf.rubyforge.org/json/) (plugin)
* [`RDF::Trix`](http://rdf.rubyforge.org/trix/) (plugin)
* [`RDF::Raptor::RDFXML`](http://rdf.rubyforge.org/raptor/) (plugin)
* [`RDF::Raptor::Turtle`](http://rdf.rubyforge.org/raptor/) (plugin)

### RDF Storage

* {RDF::Repository}
  * {RDF::Enumerable}
  * {RDF::Durable}
  * {RDF::Mutable}
  * {RDF::Queryable}
* [`RDF::DataObjects`](http://rdf.rubyforge.org/do/) (plugin)
* [`RDF::Sesame`](http://rdf.rubyforge.org/sesame/) (plugin)

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
official release from [RubyGems](http://rubygems.org/), do:

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
* <http://rubygems.org/gems/rdf>
* <http://rubyforge.org/projects/rdf/>
* <http://raa.ruby-lang.org/project/rdf/>
* <http://www.ohloh.net/p/rdf>

See Also
--------

* [RDF::BERT](http://rdf.rubyforge.org/bert/)
* [RDF::Isomorphic](http://rdf.rubyforge.org/isomorphic/)
* [RDF::Spec](http://rdf.rubyforge.org/spec/)
* [RDFS.rb](http://rdfs.rubyforge.org/)
* [RDFize](http://rdfize.rubyforge.org/)
* [RDFbus](http://rdfbus.rubyforge.org/)
* [RDFcache](http://rdfcache.rubyforge.org/)
* [RDFgrid](http://rdfgrid.rubyforge.org/)
* [Trinity](http://trinity.datagraph.org/)

Authors
-------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>
* [Ben Lavender](mailto:blavender@gmail.com) - <http://bhuga.net/>

License
-------

RDF.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.

[RDF]: http://www.w3.org/RDF/
