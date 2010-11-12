RDF.rb: Linked Data for Ruby
============================

This is a pure-Ruby library for working with [Resource Description Framework
(RDF)][RDF] data.

* <http://github.com/bendiken/rdf>
* <http://blog.datagraph.org/2010/03/rdf-for-ruby>
* <http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>
* <http://blog.datagraph.org/2010/04/rdf-repository-howto>

Features
--------

* 100% pure Ruby with minimal dependencies and no bloat.
* 100% free and unencumbered [public domain](http://unlicense.org/) software.
* Provides a clean, well-designed RDF object model and related APIs.
* Supports parsing and serializing N-Triples out of the box, with more
  serialization format support available through add-on plugins.
* Includes in-memory graph and repository implementations, with more storage
  adapter support available through add-on plugins.
* Implements basic graph pattern (BGP) query evaluation.
* Plays nice with others: entirely contained in the `RDF` module, and does
  not modify any of Ruby's core classes or standard library.
* Based entirely on Ruby's autoloading, meaning that you can generally make
  use of any one part of the library without needing to load up the rest.
* Compatible with Ruby 1.8.7+, Ruby 1.9.x, and JRuby 1.4/1.5.
* Compatible with older Ruby versions with the help of the [Backports][] gem.

Examples
--------

    require 'rubygems'
    require 'rdf'

### Writing RDF data using the N-Triples format

    require 'rdf/ntriples'
    
    RDF::Writer.open("hello.nt") do |writer|
      writer << RDF::Graph.new do |graph|
        graph << [:hello, RDF::DC.title, "Hello, world!"]
      end
    end

### Reading RDF data in the N-Triples format

    require 'rdf/ntriples'
    
    RDF::Reader.open("http://rdf.rubyforge.org/doap.nt") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

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

Documentation
-------------

<http://rdf.rubyforge.org/>

### RDF Object Model

<http://blog.datagraph.org/2010/03/rdf-for-ruby>

* {RDF::Value}
  * {RDF::Literal}
  * {RDF::Resource}
    * {RDF::Node}
    * {RDF::URI}
    * {RDF::Graph}
  * {RDF::Statement}

### RDF Serialization

<http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>

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

<http://blog.datagraph.org/2010/04/rdf-repository-howto>

* {RDF::Repository}
  * {RDF::Countable}
  * {RDF::Enumerable}
  * {RDF::Indexable}
  * {RDF::Inferable}
  * {RDF::Queryable}
  * {RDF::Mutable}
  * {RDF::Durable}
* [`RDF::DataObjects`](http://rdf.rubyforge.org/do/) (plugin)
* [`RDF::Sesame`](http://rdf.rubyforge.org/sesame/) (plugin)

### RDF Querying

* {RDF::Query}
  * {RDF::Query::Pattern}
  * {RDF::Query::Solution}
  * {RDF::Query::Solutions}
  * {RDF::Query::Variable}

### RDF Vocabularies

* {RDF}        - Resource Description Framework (RDF)
* {RDF::CC}    - Creative Commons (CC)
* {RDF::CERT}  - W3 Authentication Certificate (CERT)
* {RDF::DC}    - Dublin Core (DC)
* {RDF::DC11}  - Dublin Core 1.1 (DC11) _deprecated_
* {RDF::DOAP}  - Description of a Project (DOAP)
* {RDF::EXIF}  - Exchangeable Image File Format (EXIF)
* {RDF::FOAF}  - Friend of a Friend (FOAF)
* {RDF::GEO}   - WGS84 Geo Positioning (GEO)
* {RDF::HTTP}  - Hypertext Transfer Protocol (HTTP)
* {RDF::OWL}   - Web Ontology Language (OWL)
* {RDF::RDFS}  - RDF Schema (RDFS)
* {RDF::RSA}   - W3 RSA Keys (RSA)
* {RDF::RSS}   - RDF Site Summary (RSS)
* {RDF::SIOC}  - Semantically-Interlinked Online Communities (SIOC)
* {RDF::SKOS}  - Simple Knowledge Organization System (SKOS)
* {RDF::WOT}   - Web of Trust (WOT)
* {RDF::XHTML} - Extensible HyperText Markup Language (XHTML)
* {RDF::XSD}   - XML Schema (XSD)

Dependencies
------------

* [Ruby](http://ruby-lang.org/) (>= 1.8.7) or (>= 1.8.1 with [Backports][])
* [Addressable](http://rubygems.org/gems/addressable) (>= 2.2.0)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of RDF.rb, do:

    % [sudo] gem install rdf             # Ruby 1.8.7+ or 1.9.x
    % [sudo] gem install backports rdf   # Ruby 1.8.1+

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

Mailing List
------------

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

Authors
-------

* [Arto Bendiken](http://github.com/bendiken) - <http://ar.to/>
* [Ben Lavender](http://github.com/bhuga) - <http://bhuga.net/>
* [Gregg Kellogg](http://github.com/gkellogg) - <http://kellogg-assoc.com/>

Contributors
------------

* [Călin Ardelean](http://github.com/clnx) - <http://github.com/clnx>
* [Joey Geiger](http://github.com/jgeiger) - <http://github.com/jgeiger>
* [Fumihiro Kato](http://github.com/fumi) - <http://fumi.me/>
* [Hellekin O. Wolf](http://github.com/hellekin) - <http://hellekin.cepheide.org/>
* [John Fieber](http://github.com/jfieber) - <http://github.com/jfieber>
* [Keita Urashima](http://github.com/ursm) - <http://ursm.jp/>
* [Pius Uzamere](http://github.com/pius) - <http://pius.me/>

Contributing
------------

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec` or `VERSION` files. If you need to change them,
  do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the
  corresponding list in the the `README`. Alphabetical order applies.
* Don't touch the `AUTHORS` file. If your contributions are significant
  enough, be assured we will eventually add you in there.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

License
-------

RDF.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.

[RDF]:       http://www.w3.org/RDF/
[YARD]:      http://yardoc.org/
[YARD-GS]:   http://yardoc.org/docs/yard/file:docs/GettingStarted.md
[PDD]:       http://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
[Backports]: http://rubygems.org/gems/backports
