require 'rdf/writers/turtle'

module RDF::Writers

  # See <http://infomesh.net/2002/notation3/>
  class Notation3 < Turtle

    content_type 'application/n3', :extension => :n3
    content_encoding 'utf-8'

    # TODO

  end
end
