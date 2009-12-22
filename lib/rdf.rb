require 'rdf/version'

module RDF
  autoload :Reader,     'rdf/reader'
  autoload :Node,       'rdf/node'
  autoload :Statement,  'rdf/statement'
  autoload :URI,        'rdf/uri'
  autoload :Vocabulary, 'rdf/vocabulary'
  autoload :Writer,     'rdf/writer'

  autoload :CC,         'rdf/vocabulary/cc'
  autoload :DC,         'rdf/vocabulary/dc'
  autoload :DOAP,       'rdf/vocabulary/doap'
  autoload :EXIF,       'rdf/vocabulary/exif'
  autoload :FOAF,       'rdf/vocabulary/foaf'
  autoload :HTTP,       'rdf/vocabulary/http'
  autoload :OWL,        'rdf/vocabulary/owl'
  autoload :RDFS,       'rdf/vocabulary/rdfs'
  autoload :RSS,        'rdf/vocabulary/rss'
  autoload :SIOC,       'rdf/vocabulary/sioc'
  autoload :SKOS,       'rdf/vocabulary/skos'
  autoload :WOT,        'rdf/vocabulary/wot'
  autoload :XHTML,      'rdf/vocabulary/xhtml'
  autoload :XSD,        'rdf/vocabulary/xsd'

  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end

  def self.[](property)
    RDF::URI.parse([to_s, property.to_s].join)
  end

  def self.method_missing(property, *args, &block)
    if args.empty?
      self[property]
    else
      super
    end
  end

  def self.to_uri() RDF::URI.parse(to_s) end
  def self.to_s()   "http://www.w3.org/1999/02/22-rdf-syntax-ns#" end
end
