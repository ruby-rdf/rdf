module RDF::Readers

  # See <http://www.w3.org/TR/rdf-syntax-grammar/>
  class RDFXML < RDF::Reader

    content_type 'application/rdf+xml', :extension => :rdf
    content_encoding 'utf-8'

    # TODO

  end
end
