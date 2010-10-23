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
    LITERAL_WITH_LANGUAGE = /^"((?:\\"|[^"])*)"@([a-z]+[\-A-Za-z0-9]*)/.freeze
    LITERAL_WITH_DATATYPE = /^"((?:\\"|[^"])*)"\^\^<([^>]+)>/.freeze
    LANGUAGE_TAG          = /^@([a-z]+[\-A-Za-z0-9]*)/.freeze
    DATATYPE_URI          = /^\^\^<([^>]+)>/.freeze
    LITERAL               = Regexp.union(LITERAL_WITH_LANGUAGE, LITERAL_WITH_DATATYPE, LITERAL_PLAIN).freeze
    SUBJECT               = Regexp.union(URIREF, NODEID).freeze
    PREDICATE             = Regexp.union(URIREF).freeze
    OBJECT                = Regexp.union(URIREF, NODEID, LITERAL).freeze

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    ESCAPE_CHARS          = ["\t", "\n", "\r", "\"", "\\"].freeze
    ESCAPE_CHAR4          = /\\u([0-9A-Fa-f]{4,4})/.freeze
    ESCAPE_CHAR8          = /\\U([0-9A-Fa-f]{8,8})/.freeze
    ESCAPE_CHAR           = Regexp.union(ESCAPE_CHAR4, ESCAPE_CHAR8).freeze
    ESCAPE_SURROGATE      = /\\u([0-9A-Fa-f]{4,4})\\u([0-9A-Fa-f]{4,4})/.freeze
    ESCAPE_SURROGATE1     = (0xD800..0xDBFF).freeze
    ESCAPE_SURROGATE2     = (0xDC00..0xDFFF).freeze

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
      parse_uri(input, :intern => true)
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
    def self.parse_uri(input, options = {})
      if input =~ URIREF
        RDF::URI.send(options[:intern] ? :intern : :new, $1)
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
    # @see    http://blog.grayproductions.net/articles/understanding_m17n
    # @see    http://yehudakatz.com/2010/05/17/encodings-unabridged/
    def self.unescape(string)
      string.force_encoding(Encoding::ASCII_8BIT) if string.respond_to?(:force_encoding)

      # Decode \t|\n|\r|\"|\\ character escapes:
      ESCAPE_CHARS.each { |escape| string.gsub!(escape.inspect[1...-1], escape) }

      # Decode \uXXXX\uXXXX surrogate pairs:
      while
        (string.sub!(ESCAPE_SURROGATE) do
          if ESCAPE_SURROGATE1.include?($1.hex) && ESCAPE_SURROGATE2.include?($2.hex)
            s = [$1, $2].pack('H*H*')
            s = s.respond_to?(:force_encoding) ?
              s.force_encoding(Encoding::UTF_16BE).encode!(Encoding::UTF_8) : # for Ruby 1.9+
              Iconv.conv('UTF-8', 'UTF-16BE', s)                              # for Ruby 1.8.x
          else
            s = [$1.hex].pack('U*') << '\u' << $2
          end
          s.respond_to?(:force_encoding) ? s.force_encoding(Encoding::ASCII_8BIT) : s
        end)
      end

      # Decode \uXXXX and \UXXXXXXXX code points:
      string.gsub!(ESCAPE_CHAR) do
        s = [($1 || $2).hex].pack('U*')
        s.respond_to?(:force_encoding) ? s.force_encoding(Encoding::ASCII_8BIT) : s
      end

      string.force_encoding(Encoding::UTF_8) if string.respond_to?(:force_encoding)
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
            predicate = read_uriref(:intern => true) || fail_predicate
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
    def read_uriref(options = {})
      if uri = match(URIREF)
        uri = self.class.unescape(uri)
        RDF::URI.send(options[:intern] ? :intern : :new, uri)
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
