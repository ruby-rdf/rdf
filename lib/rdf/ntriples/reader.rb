module RDF::NTriples
  ##
  # N-Triples parser.
  #
  # @example Reading N-Triples data
  #   RDF::NTriples::Reader.open("spec/data/test.nt") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Reader < RDF::Reader
    format RDF::NTriples::Format

    ##
    # @return [Array]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar
    def read_triple
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

    ##
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (comment)
    def read_comment
      match(/^#\s*(.*)$/)
    end

    ##
    # @return [URI, nil]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (uriref)
    def read_uriref
      if uri = match(/^<([^>]+)>/)
        RDF::URI.parse(uri)
      end
    end

    ##
    # @return [Node, nil]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (nodeID)
    def read_bnode
      if node_id = match(/^_:([A-Za-z][A-Za-z0-9]*)/)
        @nodes[node_id] ||= RDF::Node.new(node_id)
      end
    end

    ##
    # @return [String, Literal, nil]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (literal)
    def read_literal
      if literal = match(/^"((?:\\"|[^"])*)"/)
        literal = unescaped(literal)

        if language = match(/^@([a-z]+[\-a-z0-9]*)/)
          RDF::Literal.new(literal, :language => language)
        elsif datatype = match(/^(\^\^)/)
          RDF::Literal.new(literal, :datatype => read_uriref || fail_object)
        else
          RDF::Literal.new(literal) # plain string literal
        end
      end
    end

    ##
    # @param  [String] string
    # @return [String]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def unescaped(string)
      ["\t", "\n", "\r", "\"", "\\"].each do |escape|
        string.gsub!(escape.inspect[1...-1], escape)
      end
      string.gsub!(/\\u([0-9A-Fa-f]{4,4})/u) { [$1.hex].pack('U*') }
      string.gsub!(/\\U([0-9A-Fa-f]{8,8})/u) { [$1.hex].pack('U*') }
      string
    end
  end
end
