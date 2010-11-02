require 'enumerator'
require 'open-uri'
require 'stringio'
require 'bigdecimal'
require 'date'
require 'time'

if RUBY_VERSION < '1.8.7'
  # @see http://rubygems.org/gems/backports
  begin
    require 'backports/1.8.7'
  rescue LoadError
    begin
      require 'rubygems'
      require 'backports/1.8.7'
    rescue LoadError
      abort "RDF.rb requires Ruby 1.8.7 or the Backports gem (hint: `gem install backports')."
    end
  end
end

require 'rdf/version'

module RDF
  # For compatibility with both Ruby 1.8.x and Ruby 1.9.x:
  Enumerator = defined?(::Enumerator) ? ::Enumerator : ::Enumerable::Enumerator

  # RDF mixins
  autoload :Countable,   'rdf/mixin/countable'
  autoload :Durable,     'rdf/mixin/durable'
  autoload :Enumerable,  'rdf/mixin/enumerable'
  autoload :Indexable,   'rdf/mixin/indexable'
  autoload :Inferable,   'rdf/mixin/inferable'
  autoload :Mutable,     'rdf/mixin/mutable'
  autoload :Queryable,   'rdf/mixin/queryable'
  autoload :Readable,    'rdf/mixin/readable'
  autoload :Writable,    'rdf/mixin/writable'

  # RDF objects
  autoload :Graph,       'rdf/model/graph'
  autoload :Literal,     'rdf/model/literal'
  autoload :Node,        'rdf/model/node'
  autoload :Resource,    'rdf/model/resource'
  autoload :Statement,   'rdf/model/statement'
  autoload :URI,         'rdf/model/uri'
  autoload :Value,       'rdf/model/value'

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
  # @return [RDF::Resource]
  def self.Resource(*args, &block)
    Resource.new(*args, &block)
  end

  ##
  # Alias for `RDF::Node.new`.
  #
  # @return [RDF::Node]
  def self.Node(*args, &block)
    Node.new(*args, &block)
  end

  ##
  # Alias for `RDF::URI.new`.
  #
  # @overload URI(uri)
  #   @param  [URI, String, #to_s]    uri
  #
  # @overload URI(options = {})
  #   @param  [Hash{Symbol => Object} options
  #
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
  # @return [RDF::Literal]
  def self.Literal(*args, &block)
    Literal.new(*args, &block)
  end

  ##
  # Alias for `RDF::Graph.new`.
  #
  # @return [RDF::Graph]
  def self.Graph(*args, &block)
    Graph.new(*args, &block)
  end

  ##
  # Alias for `RDF::Statement.new`.
  #
  # @return [RDF::Statement]
  def self.Statement(*args, &block)
    Statement.new(*args, &block)
  end

  ##
  # Alias for `RDF::Vocabulary.create`.
  #
  # @param  [String] uri
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

  class << self
    # For compatibility with `RDF::Vocabulary.__name__`:
    alias_method :__name__, :name
  end
end
