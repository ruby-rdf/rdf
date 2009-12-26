require 'rdf/version'

module RDF
  # RDF objects
  autoload :Graph,      'rdf/graph'
  autoload :Literal,    'rdf/literal'
  autoload :Node,       'rdf/node'
  autoload :Resource,   'rdf/resource'
  autoload :Statement,  'rdf/statement'
  autoload :URI,        'rdf/uri'
  autoload :Value,      'rdf/value'

  # RDF serialization
  autoload :Reader,     'rdf/reader'
  autoload :Writer,     'rdf/writer'

  # RDF storage
  autoload :Repository, 'rdf/repository'

  # RDF vocabularies
  autoload :Vocabulary, 'rdf/vocabulary'
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

  ##
  # @return [String] uri
  # @return [Class]
  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end

  ##
  # @return [#to_s] property
  # @return [URI]
  def self.[](property)
    RDF::URI.parse([to_s, property.to_s].join)
  end

  ##
  # @param  [Symbol] property
  # @return [URI]
  # @raise  [NoMethodError]
  def self.method_missing(property, *args, &block)
    if args.empty?
      self[property]
    else
      super
    end
  end

  ##
  # @return [URI]
  def self.to_uri
    RDF::URI.parse(to_s)
  end

  ##
  # @return [String]
  def self.to_s # FIXME
    "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  end
end
