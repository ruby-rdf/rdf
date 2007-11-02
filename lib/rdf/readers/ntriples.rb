module RDF::Readers

  # See <http://www.w3.org/TR/rdf-testcases/#ntriples>
  class NTriples < RDF::Reader

    content_type 'text/plain', :extension => :nt
    content_encoding 'ascii'

    def read_triple
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_grammar>

      loop do
        readline.strip! # EOFError thrown on end of input

        unless blank? || read_comment
          subject   = read_uriref || read_bnode || fail_subject
          predicate = read_uriref || fail_predicate
          object    = read_uriref || read_bnode || read_literal || fail_object
          return [subject, predicate, object]
        end
      end
    end

    def read_comment
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_grammar> (comment)

      match(/^#\s*(.*)$/)
    end

    def read_uriref
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_grammar> (uriref)

      if uri = match(/^<([^>]+)>/)
        RDF::URIRef.new(uri)
      end
    end

    def read_bnode
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_grammar> (nodeID)

      if node_id = match(/^_:([A-Za-z][A-Za-z0-9]*)/)
        @nodes[node_id] ||= RDF::Node.new
      end
    end

    def read_literal
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_grammar> (literal)

      if literal = match(/^"((?:\\"|[^"])*)"/)
        literal = unescaped(literal)

        if language = match(/^@([a-z]+[\-a-z0-9]*)/)
          RDF::Literal.new(literal, :language => language)
        elsif datatype = match(/^(\^\^)/)
          RDF::Literal.new(literal, :type => read_uriref || fail_object)
        else
          literal # plain string literal
        end
      end
    end

    def unescaped(string)
      # <http://www.w3.org/TR/rdf-testcases/#ntrip_strings>

      ["\t", "\n", "\r", "\"", "\\"].each do |escape|
        string.gsub!(escape.inspect[1...-1], escape)
      end
      string.gsub!(/\\u([0-9A-Fa-f]{4,4})/u) { [$1.hex].pack('U*') }
      string.gsub!(/\\U([0-9A-Fa-f]{8,8})/u) { [$1.hex].pack('U*') }

      string
    end

  end
end
