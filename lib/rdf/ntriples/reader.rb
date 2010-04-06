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

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar
    COMMENT               = /^#\s*(.*)$/.freeze
    NODEID                = /^_:([A-Za-z][A-Za-z0-9]*)/.freeze
    URIREF                = /^<([^>]+)>/.freeze
    LITERAL_PLAIN         = /^"((?:\\"|[^"])*)"/.freeze
    LITERAL_WITH_LANGUAGE = /^"((?:\\"|[^"])*)"@([a-z]+[\-a-z0-9]*)/.freeze
    LITERAL_WITH_DATATYPE = /^"((?:\\"|[^"])*)"\^\^<([^>]+)>/.freeze
    LANGUAGE_TAG          = /^@([a-z]+[\-a-z0-9]*)/.freeze
    DATATYPE_URI          = /^\^\^<([^>]+)>/.freeze
    LITERAL               = Regexp.union(LITERAL_WITH_LANGUAGE, LITERAL_WITH_DATATYPE, LITERAL_PLAIN).freeze
    SUBJECT               = Regexp.union(URIREF, NODEID).freeze
    PREDICATE             = Regexp.union(URIREF).freeze
    OBJECT                = Regexp.union(URIREF, NODEID, LITERAL).freeze

    ##
    # Reconstructs an RDF value from its serialized N-Triples
    # representation.
    #
    # @param  [String] input
    # @return [RDF::Value]
    def self.unserialize(input)
      case input
        when nil then nil
        else self.new(input).read_value
      end
    end

    ##
    # @param  [String] input
    # @return [RDF::Resource]
    def self.parse_subject(input)
      parse_uri(input) || parse_node(input)
    end

    ##
    # @param  [String] input
    # @return [RDF::URI]
    def self.parse_predicate(input)
      parse_uri(input)
    end

    ##
    # @param  [String] input
    # @return [RDF::Value]
    def self.parse_object(input)
      parse_uri(input) || parse_node(input) || parse_literal(input)
    end

    ##
    # @param  [String] input
    # @return [RDF::Node]
    def self.parse_node(input)
      if input =~ NODEID
        RDF::Node.new($1)
      end
    end

    ##
    # @param  [String] input
    # @return [RDF::URI]
    def self.parse_uri(input)
      if input =~ URIREF
        RDF::URI.new($1)
      end
    end

    ##
    # @param  [String] input
    # @return [RDF::Literal]
    def self.parse_literal(input)
      case input
        when LITERAL_WITH_LANGUAGE
          RDF::Literal.new(unescape($1), :language => $2)
        when LITERAL_WITH_DATATYPE
          RDF::Literal.new(unescape($1), :datatype => $2)
        when LITERAL_PLAIN
          RDF::Literal.new(unescape($1))
      end
    end

    ##
    # @param  [String] string
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.unescape(string)
      ["\t", "\n", "\r", "\"", "\\"].each do |escape|
        string.gsub!(escape.inspect[1...-1], escape)
      end
      string.gsub!(/\\u([0-9A-Fa-f]{4,4})/u) { [$1.hex].pack('U*') }
      string.gsub!(/\\U([0-9A-Fa-f]{8,8})/u) { [$1.hex].pack('U*') }
      string
    end

    ##
    # @return [RDF::Value]
    def read_value
      begin
        read_statement
      rescue RDF::ReaderError => e
        read_uriref || read_node || read_literal
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
            subject   = read_uriref || read_node || fail_subject
            predicate = read_uriref || fail_predicate
            object    = read_uriref || read_node || read_literal || fail_object
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
      match(COMMENT)
    end

    ##
    # @return [RDF::URI]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (uriref)
    def read_uriref
      if uri = match(URIREF)
        RDF::URI.new(uri)
      end
    end

    ##
    # @return [RDF::Node]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (nodeID)
    def read_node
      if node_id = match(NODEID)
        @nodes[node_id] ||= RDF::Node.new(node_id)
      end
    end

    ##
    # @return [RDF::Literal]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (literal)
    def read_literal
      if literal = match(LITERAL_PLAIN)
        literal = self.class.unescape(literal)

        if language = match(LANGUAGE_TAG)
          RDF::Literal.new(literal, :language => language)
        elsif datatype = match(/^(\^\^)/) # FIXME
          RDF::Literal.new(literal, :datatype => read_uriref || fail_object)
        else
          RDF::Literal.new(literal) # plain string literal
        end
      end
    end
  end
end
