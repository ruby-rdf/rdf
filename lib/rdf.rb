require 'rdf/version'

module RDF
  autoload :Statement,  'rdf/statement'
  autoload :URI,        'rdf/uri'
  autoload :Vocabulary, 'rdf/vocabulary'

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
