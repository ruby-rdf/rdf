require 'open-uri'
require 'stringio'
require 'bigdecimal'
require 'date'
require 'time'

require 'rdf/version'

module RDF
  # RDF mixins
  autoload :Countable,   'rdf/mixin/countable'
  autoload :Durable,     'rdf/mixin/durable'
  autoload :Enumerable,  'rdf/mixin/enumerable'
  autoload :Indexable,   'rdf/mixin/indexable'
  autoload :Inferable,   'rdf/mixin/inferable'
  autoload :Mutable,     'rdf/mixin/mutable'
  autoload :Queryable,   'rdf/mixin/queryable'
  autoload :Readable,    'rdf/mixin/readable'
  autoload :TypeCheck,   'rdf/mixin/type_check'
  autoload :Writable,    'rdf/mixin/writable'

  # RDF objects
  autoload :Graph,       'rdf/model/graph'
  autoload :IRI,         'rdf/model/uri'
  autoload :Literal,     'rdf/model/literal'
  autoload :Node,        'rdf/model/node'
  autoload :Resource,    'rdf/model/resource'
  autoload :Statement,   'rdf/model/statement'
  autoload :URI,         'rdf/model/uri'
  autoload :Value,       'rdf/model/value'
  autoload :Term,        'rdf/model/term'

  # RDF collections
  autoload :List,        'rdf/model/list'

  # RDF serialization
  autoload :Format,      'rdf/format'
  autoload :Reader,      'rdf/reader'
  autoload :ReaderError, 'rdf/reader'
  autoload :Writer,      'rdf/writer'
  autoload :WriterError, 'rdf/writer'

  # RDF serialization formats
  autoload :NTriples,    'rdf/ntriples'
  autoload :NQuads,      'rdf/nquads'

  # RDF storage
  autoload :Dataset,     'rdf/model/dataset'
  autoload :Repository,  'rdf/repository'
  autoload :Transaction, 'rdf/transaction'

  # RDF querying
  autoload :Query,       'rdf/query'

  # RDF vocabularies
  autoload :Vocabulary,  'rdf/vocab'
  VOCABS = Dir.glob(File.join(File.dirname(__FILE__), 'rdf', 'vocab', '*.rb')).map { |f| File.basename(f)[0...-(File.extname(f).size)].to_sym } rescue []
  VOCABS.each { |v| autoload v.to_s.upcase.to_sym, "rdf/vocab/#{v}" unless v == :rdf }

  # Utilities
  autoload :Util,        'rdf/util'

  ##
  # Alias for `RDF::Resource.new`.
  #
  # @param (see RDF::Resource#initialize)
  # @return [RDF::Resource]
  def self.Resource(*args, &block)
    Resource.new(*args, &block)
  end

  ##
  # Alias for `RDF::Node.new`.
  #
  # @param (see RDF::Node#initialize)
  # @return [RDF::Node]
  def self.Node(*args, &block)
    Node.new(*args, &block)
  end

  ##
  # Alias for `RDF::URI.new`.
  #
  # @param (see RDF::URI#initialize)
  # @return [RDF::URI]
  def self.URI(*args, &block)
    case uri = args.first
      when RDF::URI then uri
      else case
        when uri.respond_to?(:to_uri) then uri.to_uri
        else URI.new(*args, &block)
      end
    end
  end

  ##
  # Alias for `RDF::Literal.new`.
  #
  # @param (see RDF::Literal#initialize)
  # @return [RDF::Literal]
  def self.Literal(*args, &block)
    case literal = args.first
      when RDF::Literal then literal
      else Literal.new(*args, &block)
    end
  end

  ##
  # Alias for `RDF::Graph.new`.
  #
  # @param (see RDF::Graph#initialize)
  # @return [RDF::Graph]
  def self.Graph(*args, &block)
    Graph.new(*args, &block)
  end

  ##
  # Alias for `RDF::Statement.new`.
  #
  # @param (see RDF::Statement#initialize)
  # @return [RDF::Statement]
  def self.Statement(*args, &block)
    Statement.new(*args, &block)
  end

  ##
  # Alias for `RDF::Vocabulary.create`.
  #
  # @param (see RDF::Vocabulary#initialize)
  # @return [Class]
  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end

  ##
  # @return [URI]
  def self.value
    self[:value]
  end

  ##
  # @return [#to_s] property
  # @return [URI]
  def self.[](property)
    RDF::URI.intern([to_uri.to_s, property.to_s].join)
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
    RDF::URI.intern("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  end

  # RDF Vocabulary terms
  %w(
    Alt
    Bag
    first
    HTML
    langString
    List
    nil
    object
    predicate
    Property
    rest
    Seq
    Statement
    subject
    type
    value
    XMLLiteral
  ).each do |term|
    term_uri = self[term.to_sym]
    define_method(term) {term_uri}
    module_function term.to_sym
  end

  class << self
    # For compatibility with `RDF::Vocabulary.__name__`:
    alias_method :__name__, :name
    
    # For IRI compatibility
    alias_method :to_iri, :to_uri
  end
end
