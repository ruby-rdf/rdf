# -*- encoding: utf-8 -*-
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
  # @see http://www.w3.org/TR/n-triples/
  class Reader < RDF::Reader
    format RDF::NTriples::Format

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    ESCAPE_CHARS          = ["\b", "\f", "\t", "\n", "\r", "\"", "\\"].freeze
    ESCAPE_CHAR4          = /\\u([0-9A-Fa-f]{4,4})/.freeze
    ESCAPE_CHAR8          = /\\U([0-9A-Fa-f]{8,8})/.freeze
    ESCAPE_CHAR           = Regexp.union(ESCAPE_CHAR4, ESCAPE_CHAR8).freeze
    ESCAPE_SURROGATE      = /\\u([0-9A-Fa-f]{4,4})\\u([0-9A-Fa-f]{4,4})/.freeze
    ESCAPE_SURROGATE1     = (0xD800..0xDBFF).freeze
    ESCAPE_SURROGATE2     = (0xDC00..0xDFFF).freeze


    # Terminals from rdf-turtle.
    #
    # @see http://www.w3.org/TR/n-triples/
    # @see http://www.w3.org/TR/turtle/
    ##
    # Unicode regular expressions.
    U_CHARS1         = Regexp.compile(<<-EOS.gsub(/\s+/, ''))
                         [\\u00C0-\\u00D6]|[\\u00D8-\\u00F6]|[\\u00F8-\\u02FF]|
                         [\\u0370-\\u037D]|[\\u037F-\\u1FFF]|[\\u200C-\\u200D]|
                         [\\u2070-\\u218F]|[\\u2C00-\\u2FEF]|[\\u3001-\\uD7FF]|
                         [\\uF900-\\uFDCF]|[\\uFDF0-\\uFFFD]|[\\u{10000}-\\u{EFFFF}]
                       EOS
    U_CHARS2         = Regexp.compile("\\u00B7|[\\u0300-\\u036F]|[\\u203F-\\u2040]").freeze
    IRI_RANGE        = Regexp.compile("[[^<>\"{}|^`\\\\]&&[^\\x00-\\x20]]").freeze

    # 163s
    PN_CHARS_BASE        = /[A-Z]|[a-z]|#{U_CHARS1}/.freeze
    # 164s
    PN_CHARS_U           = /_|#{PN_CHARS_BASE}/.freeze
    # 166s
    PN_CHARS             = /-|[0-9]|#{PN_CHARS_U}|#{U_CHARS2}/.freeze
    # 159s
    ECHAR                = /\\[tbnrf\\"]/.freeze
    # 18
    IRIREF               = /<((?:#{IRI_RANGE}|#{ESCAPE_CHAR})*)>/.freeze
    # 141s
    BLANK_NODE_LABEL     = /_:((?:[0-9]|#{PN_CHARS_U})(?:(?:#{PN_CHARS}|\.)*#{PN_CHARS})?)/.freeze
    # 144s
    LANGTAG              = /@([a-zA-Z]+(?:-[a-zA-Z0-9]+)*)/.freeze
    # 22
    STRING_LITERAL_QUOTE = /"((?:[^\"\\\n\r]|#{ECHAR}|#{ESCAPE_CHAR})*)"/.freeze

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar
    COMMENT               = /^#\s*(.*)$/.freeze
    NODEID                = /^#{BLANK_NODE_LABEL}/.freeze
    URIREF                = /^#{IRIREF}/.freeze
    LITERAL_PLAIN         = /^#{STRING_LITERAL_QUOTE}/.freeze
    LITERAL_WITH_LANGUAGE = /^#{STRING_LITERAL_QUOTE}#{LANGTAG}/.freeze
    LITERAL_WITH_DATATYPE = /^#{STRING_LITERAL_QUOTE}\^\^#{IRIREF}/.freeze
    DATATYPE_URI          = /^\^\^#{IRIREF}/.freeze
    LITERAL               = Regexp.union(LITERAL_WITH_LANGUAGE, LITERAL_WITH_DATATYPE, LITERAL_PLAIN).freeze
    SUBJECT               = Regexp.union(URIREF, NODEID).freeze
    PREDICATE             = Regexp.union(URIREF).freeze
    OBJECT                = Regexp.union(URIREF, NODEID, LITERAL).freeze
    END_OF_STATEMENT      = /^\s*\.\s*(?:#.*)?$/.freeze

    ##
    # Reconstructs an RDF value from its serialized N-Triples
    # representation.
    #
    # @param  [String] input
    # @return [RDF::Term]
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
    # @return [RDF::Term]
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
      string = string.dup.force_encoding(Encoding::UTF_8)

      # Decode \t|\n|\r|\"|\\ character escapes:
      ESCAPE_CHARS.each { |escape| string.gsub!(escape.inspect[1...-1], escape) }

      # Decode \uXXXX\uXXXX surrogate pairs:
      # XXX: This block should be removed in RDF.rb 2.0
      while
        (string.sub!(ESCAPE_SURROGATE) do
          if ESCAPE_SURROGATE1.include?($1.hex) && ESCAPE_SURROGATE2.include?($2.hex)
            warn "[DEPRECATION] Surrogate pairs support deprecated. Support will be removed in a future release."
            s = [$1, $2].pack('H*H*')
            s.force_encoding(Encoding::UTF_16BE).encode!(Encoding::UTF_8)
          else
            [$1.hex].pack('U*') << '\u' << $2
          end
        end)
      end

      # Decode \uXXXX and \UXXXXXXXX code points:
      string.gsub!(ESCAPE_CHAR) do
        [($1 || $2).hex].pack('U*')
      end

      string
    end

    ##
    # @return [RDF::Term]
    def read_value
      begin
        read_statement
      rescue RDF::ReaderError
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

            if validate? && !read_eos
              raise RDF::ReaderError.new("ERROR [line #{lineno}] Expected end of statement (found: #{current_line.inspect})",
                                         lineno: lineno)
            end
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
      if uri_str = match(URIREF)
        uri_str = self.class.unescape(uri_str)
        uri = RDF::URI.send(intern? && options[:intern] ? :intern : :new, uri_str)
        uri.validate!     if validate?
        uri.canonicalize! if canonicalize?
        uri
      end
    rescue ArgumentError => e
      raise RDF::ReaderError.new("ERROR [line #{lineno}] Invalid URI (found: \"<#{uri_str}>\")", lineno: lineno, token: "<#{uri_str}>")
    end

    ##
    # @return [RDF::Node]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (nodeID)
    def read_node
       if node_id = match(NODEID)
        @nodes ||= {}
        @nodes[node_id] ||= RDF::Node.new(node_id)
      end
    end

    ##
    # @return [RDF::Literal]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (literal)
    def read_literal
      if literal_str = match(LITERAL_PLAIN)
        literal_str = self.class.unescape(literal_str)
        literal = case
          when language = match(LANGTAG)
            RDF::Literal.new(literal_str, :language => language)
          when datatype = match(/^(\^\^)/) # FIXME
            RDF::Literal.new(literal_str, :datatype => read_uriref || fail_object)
          else
            RDF::Literal.new(literal_str) # plain string literal
        end
        literal.validate!     if validate?
        literal.canonicalize! if canonicalize?
        literal
      end
    end

    ##
    # @return [Boolean]
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (triple)
    def read_eos
      match(END_OF_STATEMENT)
    end
  end # Reader
end # RDF::NTriples
