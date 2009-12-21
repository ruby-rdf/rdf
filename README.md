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

Documentation
-------------

* <http://rdfrb.rubyforge.org/>

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdf/tarball/master

Requirements
------------

* [Addressable](http://addressable.rubyforge.org/) (>= 2.1.1)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

    % [sudo] gem install rdf

Resources
---------

* <http://rdfrb.rubyforge.org/>
* <http://github.com/bendiken/rdf>
* <http://gemcutter.org/gems/rdf>
* <http://rubyforge.org/projects/rdfrb/>
* <http://raa.ruby-lang.org/project/rdf>

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

RDF.rb is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.
