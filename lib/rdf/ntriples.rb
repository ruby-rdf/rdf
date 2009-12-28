module RDF
  ##
  # N-Triples serialization format.
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  # @see http://en.wikipedia.org/wiki/N-Triples
  module NTriples
    autoload :Format, 'rdf/ntriples/format'
    autoload :Reader, 'rdf/ntriples/reader'
    autoload :Writer, 'rdf/ntriples/writer'
  end
end
