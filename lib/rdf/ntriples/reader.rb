module RDF::NTriples
  ##
  # N-Triples parser.
  #
  # @example Obtaining an NTriples reader class
  #   RDF::Reader.for(:ntriples)     #=> RDF::NTriples::Reader
  #   RDF::Reader.for("etc/doap.nt")
  #   RDF::Reader.for(:file_name      => "etc/doap.nt")
  #   RDF::Reader.for(:file_extension => "nt")
  #   RDF::Reader.for(:content_type   => "text/plain")
  #
  # @example Parsing RDF statements from an NTriples file
  #   RDF::NTriples::Reader.open("etc/doap.nt") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from an NTriples string
  #   data = StringIO.new(File.read("etc/doap.nt"))
  #   RDF::NTriples::Reader.new(data) do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Reader < RDF::Reader
    format RDF::NTriples::Format

    ##
    # Reconstructs an RDF value from its serialized N-Triples
    # representation.
    #
    # @param  [String] data
    # @return [RDF::Value]
    def self.unserialize(data)
      self.new(data).read_value
    end

    ##
    # @return [RDF::Value]
    def read_value
      begin
        read_statement
      rescue RDF::ReaderError => e
        read_uriref || read_bnode || read_literal
      end
    end

    ##
    # @return [Array]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar
    def read_triple
      loop do
        readline.strip! # EOFError thrown on end of input
        line = @line    # for backtracking input in case of parse error

        begin
          unless blank? || read_comment
            subject   = read_uriref || read_bnode || fail_subject
            predicate = read_uriref || fail_predicate
            object    = read_uriref || read_bnode || read_literal || fail_object
            return [subject, predicate, object]
          end
        rescue RDF::ReaderError => e
          @line = line  # this allows #read_value to work
          raise e
        end
      end
    end

    ##
    # @return [Boolean]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (comment)
    def read_comment
      match(/^#\s*(.*)$/)
    end

    ##
    # @return [URI]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (uriref)
    def read_uriref
      if uri = match(/^<([^>]+)>/)
        RDF::URI.new(uri)
      end
    end

    ##
    # @return [Node]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (nodeID)
    def read_bnode
      if node_id = match(/^_:([A-Za-z][A-Za-z0-9]*)/)
        @nodes[node_id] ||= RDF::Node.new(node_id)
      end
    end

    ##
    # @return [Literal]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (literal)
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
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
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
