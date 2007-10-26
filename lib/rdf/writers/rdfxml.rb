module RDF::Writers

  # See <http://www.w3.org/TR/rdf-syntax-grammar/>
  class RDFXML < RDF::Writer

    content_type 'application/rdf+xml', :extension => :rdf
    content_encoding 'utf-8'

    # TODO

  end
end
