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
    p = RDF::URI.parse("http://purl.org/dc/elements/1.1/creator")
    o = RDF::URI.parse("http://ar.to/#self")

    stmt = RDF::Statement.new(s, p, o)

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
