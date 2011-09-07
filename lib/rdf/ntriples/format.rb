module RDF::NTriples
  ##
  # N-Triples format specification.
  #
  # Note: Latest standards activities treat N-Triples as a subset
  # of Turtle. This includes text/ntriples+turtle mime type and a
  # new default encoding of utf-8.
  #
  # @example Obtaining an NTriples format class
  #   RDF::Format.for(:ntriples)     #=> RDF::NTriples::Format
  #   RDF::Format.for("etc/doap.nt")
  #   RDF::Format.for(:file_name      => "etc/doap.nt")
  #   RDF::Format.for(:file_extension => "nt")
  #   RDF::Format.for(:content_type   => "text/plain")
  #   RDF::Format.for(:content_type   => "text/ntriples+turtle")
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Format < RDF::Format
    content_type     'text/plain', :extension => :nt
    content_type     'text/ntriples+turtle', :extension => :nt
    content_encoding 'utf-8'

    reader { RDF::NTriples::Reader }
    writer { RDF::NTriples::Writer }
    
    # No format detection, as N-Triples can be parsed by N-Quads
  end
end
