require 'rdf/version'

module RDF
  # RDF mixins
  autoload :Durable,    'rdf/mixin/durable'
  autoload :Enumerable, 'rdf/mixin/enumerable'
  autoload :Inferable,  'rdf/mixin/inferable'
  autoload :Mutable,    'rdf/mixin/mutable'
  autoload :Queryable,  'rdf/mixin/queryable'
  autoload :Readable,   'rdf/mixin/readable'
  autoload :Writable,   'rdf/mixin/writable'

  # RDF objects
  autoload :Graph,      'rdf/model/graph'
  autoload :Literal,    'rdf/model/literal'
  autoload :Node,       'rdf/model/node'
  autoload :Resource,   'rdf/model/resource'
  autoload :Statement,  'rdf/model/statement'
  autoload :URI,        'rdf/model/uri'
  autoload :Value,      'rdf/model/value'

  # RDF serialization
  autoload :Format,     'rdf/format'
  autoload :Reader,     'rdf/reader'
  autoload :ReaderError,'rdf/reader'
  autoload :Writer,     'rdf/writer'
  autoload :WriterError,'rdf/writer'

  # RDF serialization formats
  autoload :NTriples,   'rdf/ntriples'

  # RDF storage
  autoload :Repository, 'rdf/repository'

  # RDF querying
  autoload :Query,      'rdf/query'

  # RDF vocabularies
  autoload :Vocabulary, 'rdf/vocab'
  autoload :CC,         'rdf/vocab/cc'
  autoload :DC,         'rdf/vocab/dc'
  autoload :DC11,       'rdf/vocab/dc11'
  autoload :DOAP,       'rdf/vocab/doap'
  autoload :EXIF,       'rdf/vocab/exif'
  autoload :FOAF,       'rdf/vocab/foaf'
  autoload :HTTP,       'rdf/vocab/http'
  autoload :OWL,        'rdf/vocab/owl'
  autoload :RDFS,       'rdf/vocab/rdfs'
  autoload :RSS,        'rdf/vocab/rss'
  autoload :SIOC,       'rdf/vocab/sioc'
  autoload :SKOS,       'rdf/vocab/skos'
  autoload :WOT,        'rdf/vocab/wot'
  autoload :XHTML,      'rdf/vocab/xhtml'
  autoload :XSD,        'rdf/vocab/xsd'

  ##
  # @return [String] uri
  # @return [Class]
  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end

  ##
  # @return [URI]
  def self.type
    self[:type]
  end

  ##
  # @return [#to_s] property
  # @return [URI]
  def self.[](property)
    RDF::URI.new([to_uri.to_s, property.to_s].join)
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
  def self.to_rdf
    to_uri
  end

  ##
  # @return [URI]
  def self.to_uri
    RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  end

  class << self
    # For compatibility with `RDF::Vocabulary.__name__`:
    alias_method :__name__, :name
  end
end
