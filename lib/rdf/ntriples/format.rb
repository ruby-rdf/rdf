module RDF::NTriples
  ##
  # N-Triples format specification.
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Format < RDF::Format
    content_type     'text/plain', :extension => :nt
    content_encoding 'ascii'

    reader RDF::NTriples::Reader
    writer RDF::NTriples::Writer
  end
end
