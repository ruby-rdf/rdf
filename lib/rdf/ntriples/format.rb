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
    content_type     'text/plain', :extension => :nt, :alias => 'text/ntriples+turtle'
    content_encoding 'utf-8'

    reader { RDF::NTriples::Reader }
    writer { RDF::NTriples::Writer }
    
    ##
    # Sample detection to see if it matches N-Triples
    #
    # Use a text sample to detect the format of an input file. Sub-classes implement
    # a matcher sufficient to detect probably format matches, including disambiguating
    # between other similar formats.
    #
    # @param [String] sample Beginning several bytes (about 1K) of input.
    # @return [Boolean]
    def self.detect(sample)
      !!sample.match(%r(
        (?:(?:<[^>]*>) | (?:_:\w+))                             # Subject
        \s*
        (?:<[^>]*>)                                             # Predicate
        \s*
        (?:(?:<[^>]*>) | (?:_:\w+) | (?:"[^"\n]*"(?:^^|@\S+)?)) # Object
        \s*\.
      )mx) && !(
        sample.match(%r(@(base|prefix|keywords)|\{)) ||         # Not Turtle/N3/TriG
        sample.match(%r(<(html|rdf))i)                          # Not HTML or XML
      ) && !RDF::NQuads::Format.detect(sample)
    end
  end
end
