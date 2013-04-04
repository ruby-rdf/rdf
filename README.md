# RDF.rb: Linked Data for Ruby
[![Build Status](https://secure.travis-ci.org/ruby-rdf/rdf.png?branch=master)](http://travis-ci.org/ruby-rdf/rdf)

This is a pure-Ruby library for working with [Resource Description Framework
(RDF)][RDF] data.

* <http://ruby-rdf.github.com/rdf>
* <http://blog.datagraph.org/2010/12/rdf-for-ruby>
* <http://blog.datagraph.org/2010/03/rdf-for-ruby>
* <http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>
* <http://blog.datagraph.org/2010/04/rdf-repository-howto>

## Features

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
* Compatible with Ruby 1.8.7+, Ruby 1.9.x, Ruby 2.0, Rubinius and JRuby 1.7+.
* Compatible with older Ruby versions with the help of the [Backports][] gem.
* Performs auto-detection of input to select appropriate Reader class if one
  cannot be determined from file characteristics.

## Tutorials

* [Getting data from the Semantic Web using Ruby and RDF.rb](http://semanticweb.org/wiki/Getting_data_from_the_Semantic_Web_%28Ruby%29)
* [Using RDF.rb and Spira to process RDF data from the British Ordnance Survey](http://stephenpope.co.uk/?p=85)
* [Getting started with RDF and SPARQL using 4store and RDF.rb](http://www.jenitennison.com/blog/node/152)

## Command Line
When installed, RDF.rb includes a `rdf` shell script which acts as a wrapper to perform a number of different
operations on RDF files using available readers and writers.

* `serialize`: Parse an RDF input and re-serializing to N-Triples or another available format using `--output-format` option.
* `count`: Parse and RDF input and count the number of statements.
* `subjects`: Returns unique subjects from parsed input.
* `objects`: Returns unique objects from parsed input.
* `predicates`: Returns unique objects from parsed input.

## Examples

    require 'rdf'
    include RDF

### Writing RDF data using the N-Triples format

    require 'rdf/ntriples'
    graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]
    graph.dump(:ntriples)
    
or

    RDF::Writer.open("hello.nt") { |writer| writer << graph }

### Reading RDF data in the N-Triples format

    require 'rdf/ntriples'
    graph = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")
    
or

    RDF::Reader.open("http://ruby-rdf.github.com/rdf/etc/doap.nt") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

### Reading RDF data in other formats
{RDF::Reader.open} and {RDF::Repository.load} use a number of mechanisms to determine the appropriate reader
to use when loading a file. The specific format to use can be forced using, e.g. `:format => :ntriples`
option where the specific format symbol is determined by the available readers. Both also use
MimeType or file extension, where available.

    require 'linkeddata'
    
    graph = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nq", :format => :nquads)

A specific sub-type of Reader can also be invoked directly:

    require 'rdf/nquads'
    
    RDF::NQuads::Reader.open("http://ruby-rdf.github.com/rdf/etc/doap.nq") do |reader|
      reader.each_statement do |statement|
        puts statement.inspect
      end
    end

Reader/Writer implementations may override {RDF::Format.detect}, which takes a small sample if input
and return a boolean indicating if it matches that specific format. In the case that a format cannot
be detected from filename or other options, or that more than one format is identified,
{RDF::Format.for} will query each loaded format by invoking it's `detect` method, and the first successful
match will be used to read the input.

### Writing RDF data using other formats
{RDF::Writer.open}, {RDF::Enumerable#dump}, {RDF::Writer.dump} take similar options to {RDF::Reader.open} to determine the
appropriate writer to use.

    require 'linkeddata'

    RDF::Writer.open("hello.nq", :format => :nquads) do |writer|
      writer << RDF::Repository.new do |repo|
        repo << RDF::Statement.new(:hello, RDF::DC.title, "Hello, world!", :context => RDF::URI("context"))
      end
    end

A specific sub-type of Writer can also be invoked directly:

    graph.dump(:nquads)

## Reader/Writer convenience methods
{RDF::Enumerable} implements `to_{format}` for each available instance of {RDF::Reader}.
For example, if `rdf/turtle` is loaded, this allows the following:

    graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]
    graph.to_ttl

Similarly, {RDF::Mutable} implements `from_{format}` for each available instance
of {RDF::Writer}. For example:

    graph = RDF::Graph.new
    graph.from_ttl("[ a <http://www.w3.org/1999/02/22-rdf-syntax-ns#Resource>]")

Note that no prefixes are loaded automatically, however they can be provided as arguments:

    graph.from_ttl("[ a rdf:Resource]", :prefixes => {:rdf => RDF.to_uri})

### Querying RDF data using basic graph patterns (BGPs)

    require 'rdf/ntriples'
    
    graph = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nt")
    query = RDF::Query.new({
      :person => {
        RDF.type  => FOAF.Person,
        FOAF.name => :name,
        FOAF.mbox => :email,
      }
    })
    
    query.execute(graph).each do |solution|
      puts "name=#{solution.name} email=#{solution.email}"
    end

A separate [SPARQL][SPARQL doc] gem builds on basic BGP support to provide full support for [SPARQL 1.0](http://www.w3.org/TR/rdf-sparql-query/) queries.

### Using pre-defined RDF vocabularies

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

## Documentation

<http://rubydoc.info/github/ruby-rdf/rdf/frames>

### RDF Object Model

<http://blog.datagraph.org/2010/03/rdf-for-ruby>

* {RDF::Value}
  * {RDF::Term}
    * {RDF::Literal}
      * {RDF::Literal::Boolean}
      * {RDF::Literal::Date}
      * {RDF::Literal::DateTime}
      * {RDF::Literal::Decimal}
      * {RDF::Literal::Double}
      * {RDF::Literal::Integer}
      * {RDF::Literal::Time}
      * [RDF::XSD](http://rubydoc.info/github/gkellogg/rdf-xsd/master/frames) (plugin)
    * {RDF::Resource}
      * {RDF::List}
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

The following is a partial list of RDF formats implemented either natively, or through the inclusion of
other gems:

* {RDF::NTriples}
* {RDF::NQuads}
* [JSON::LD][] (plugin)
* [RDF::JSON][] (plugin)
* [RDF::Microdata][] (plugin)
* [RDF::N3][] (plugin)
* [RDF::Raptor::RDFXML](http://ruby-rdf.github.com/rdf-raptor) (plugin)
* [RDF::Raptor::Turtle](http://ruby-rdf.github.com/rdf-raptor) (plugin)
* [RDF::RDFa][] (plugin)
* [RDF::RDFXML][] (plugin)
* [RDF::TriG][] (plugin)
* [RDF::TriX][] (plugin)
* [RDF::Turtle][] (plugin)

The meta-gem [LinkedData][LinkedData doc] includes many of these gems.

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
* {RDF::Transaction}
* [RDF::AllegroGraph](http://rubydoc.info/github/emk/rdf-agraph/master/frames) (plugin)
* [RDF::Mongo](http://rubydoc.info/github/pius/rdf-mongo/master/frames) (plugin)
* [RDF::DataObjects](http://rubydoc.info/github/ruby-rdf/rdf-do/frames) (plugin)
* [RDF::Sesame](http://rdf.rubyforge.org/sesame/) (plugin)

### RDF Querying

* {RDF::Query}
  * {RDF::Query::HashPatternNormalizer}
  * {RDF::Query::Pattern}
  * {RDF::Query::Solution}
  * {RDF::Query::Solutions}
  * {RDF::Query::Variable}
* [SPARQL](http://rubydoc.info/github/ruby-rdf/sparql/frames) (plugin)


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

## Dependencies

* [Ruby](http://ruby-lang.org/) (>= 1.8.7) or (>= 1.8.1 with [Backports][])

## Installation

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of RDF.rb, do:

    % [sudo] gem install rdf             # Ruby 1.8.7+ or 1.9.x
    % [sudo] gem install backports rdf   # Ruby 1.8.1+

## Download

To get a local working copy of the development repository, do:

    % git clone git://github.com/ruby-rdf/rdf.git

Alternatively, download the latest development version as a tarball as
follows:

    % wget http://github.com/ruby-rdf/rdf/tarball/master

## Resources

* <http://rubydoc.info/github/ruby-rdf/rdf/frames>
* <http://github.com/ruby-rdf/rdf>
* <http://rubygems.org/gems/rdf>
* <http://rubyforge.org/projects/rdf/>
* <http://raa.ruby-lang.org/project/rdf/>
* <http://www.ohloh.net/p/rdf>

## Mailing List

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

## Authors

* [Arto Bendiken](http://github.com/bendiken) - <http://ar.to/>
* [Ben Lavender](http://github.com/bhuga) - <http://bhuga.net/>
* [Gregg Kellogg](http://github.com/gkellogg) - <http://kellogg-assoc.com/>

## Contributors

* [Călin Ardelean](http://github.com/clnx) - <http://github.com/clnx>
* [Mark Borkum](http://github.com/markborkum) - <http://github.com/markborkum>
* [Danny Gagne](http://github.com/danny) - <http://www.dannygagne.com/>
* [Joey Geiger](http://github.com/jgeiger) - <http://github.com/jgeiger>
* [Fumihiro Kato](http://github.com/fumi) - <http://fumi.me/>
* [Naoki Kawamukai](http://github.com/kna) - <http://github.com/kna>
* [Hellekin O. Wolf](http://github.com/hellekin) - <http://hellekin.cepheide.org/>
* [John Fieber](http://github.com/jfieber) - <http://github.com/jfieber>
* [Keita Urashima](http://github.com/ursm) - <http://ursm.jp/>
* [Pius Uzamere](http://github.com/pius) - <http://pius.me/>

## Contributing

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
  Before committing, run `git diff --check` to make sure of this.
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

## License

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[RDF]:              http://www.w3.org/RDF/
[YARD]:             http://yardoc.org/
[YARD-GS]:          http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:              http://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
[Backports]:        http://rubygems.org/gems/backports
[JSONLD doc]:       http://rubydoc.info/github/gkellogg/json-ld/frames
[LinkedData doc]:   http://rubydoc.info/github/datagraph/linkeddata/master/frames
[Microdata doc]:    http://rubydoc.info/github/ruby-rdf/rdf-microdata/frames
[N3 doc]:           http://rubydoc.info/github/ruby-rdf/rdf-n3/master/frames
[RDFa doc]:         http://rubydoc.info/github/ruby-rdf/rdf-rdfa/master/frames
[RDFXML doc]:       http://rubydoc.info/github/ruby-rdf/rdf-rdfxml/master/frames
[Turtle doc]:       http://rubydoc.info/github/ruby-rdf/rdf-turtle/master/frames
[SPARQL doc]:       http://rubydoc.info/github/ruby-rdf/sparql/frames
[SPARQL 1.0]:       http://www.w3.org/TR/rdf-sparql-query/
[RDF.rb]:           http://ruby-rdf.github.com/
[RDF::DO]:          http://ruby-rdf.github.com/rdf-do
[RDF::Mongo]:       http://ruby-rdf.github.com/rdf-mongo
[RDF::Sesame]:      http://ruby-rdf.github.com/rdf-sesame
[RDF::JSON]:        http://ruby-rdf.github.com/rdf-json
[RDF::Microdata]:   http://ruby-rdf.github.com/rdf-microdata
[RDF::N3]:          http://ruby-rdf.github.com/rdf-n3
[RDF::RDFa]:        http://ruby-rdf.github.com/rdf-rdfa
[RDF::RDFXML]:      http://ruby-rdf.github.com/rdf-rdfxml
[RDF::TriG]:        http://ruby-rdf.github.com/rdf-trig
[RDF::TriX]:        http://ruby-rdf.github.com/rdf-trix
[RDF::Turtle]:      http://ruby-rdf.github.com/rdf-turtle
[RDF::Raptor]:      http://ruby-rdf.github.com/rdf-raptor
[LinkedData]:       http://ruby-rdf.github.com/linkeddata
[JSON::LD]:         http://gkellogg.github.com/json-ld
