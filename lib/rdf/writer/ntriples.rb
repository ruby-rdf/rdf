module RDF class Writer
  ##
  # @see <http://www.w3.org/TR/rdf-testcases/#ntriples>
  class NTriples < Writer
    content_type 'text/plain', :extension => :nt
    content_encoding 'ascii'

    def write_comment(text)
      puts "# #{text}"
    end

    def write_triple(subject, predicate, object)
      s = format_uri(subject)
      p = format_uri(predicate)
      o = object.kind_of?(RDF::URI) ? format_uri(object) : format_literal(object)
      puts "%s %s %s ." % [s, p, o]
    end

    def format_uri(node)
      "<%s>" % uri_for(node)
    end

    def format_literal(literal) # TODO
      #if literal.kind_of?(RDF::Literal)
      #  text = quoted(escaped(literal.value))
      #  text << "@#{literal.language}" if literal.language
      #  text << "^^<#{uri_for(literal.type)}>" if literal.type
      #  text
      #else
        quoted(escaped(literal.to_s))
      #end
    end
  end
end end
