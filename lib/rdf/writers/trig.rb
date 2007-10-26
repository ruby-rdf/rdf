require 'rdf/writers/turtle'

module RDF::Writers

  # See <http://sites.wiwiss.fu-berlin.de/suhl/bizer/TriG/>
  class TriG < Turtle

    content_type 'application/x-trig', :extension => :trig
    content_encoding 'utf-8'

    # TODO

  end
end
