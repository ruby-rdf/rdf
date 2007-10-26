module RDF::Writers
  # See <http://www.w3.org/TR/rdf-testcases/#ntriples>
  class NTriples < RDF::Writer

    content_type 'text/plain', :extension => :nt
    content_encoding 'ascii'

    def write_comment(text)
      puts "# #{text}"
    end

    def write_triple(subject, predicate, object)
      s = "<#{uri_for(subject)}>"
      p = "<#{uri_for(predicate)}>"

      case object
        when RDF::URIRef
          o = "<#{uri_for(object)}>"
        when RDF::Literal
          o = quoted(escaped(object.value))
          o << "@#{object.language}" if object.language
          o << "^^<#{uri_for(object.type)}>" if object.type
        else
          o = quoted(escaped(object.to_s))
      end

      puts "%s %s %s ." % [s, p, o]
    end

  end
end
