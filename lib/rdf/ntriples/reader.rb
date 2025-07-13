# -*- encoding: utf-8 -*-

require 'strscan'

module RDF::NTriples
  ##
  # N-Triples parser.
  #
  # @example Obtaining an NTriples reader class
  #   RDF::Reader.for(:ntriples)     #=> RDF::NTriples::Reader
  #   RDF::Reader.for("etc/doap.nt")
  #   RDF::Reader.for(file_name:      "etc/doap.nt")
  #   RDF::Reader.for(file_extension: "nt")
  #   RDF::Reader.for(content_type:   "application/n-triples")
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
  # ** RDF=star
  #
  # Supports statements as resources using `<<(s p o)>>`.
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  # @see http://www.w3.org/TR/n-triples/
  class Reader < RDF::Reader
    include RDF::Util::Logger
    format RDF::NTriples::Format

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    ESCAPE_CHARS    = ["\b", "\f", "\t", "\n", "\r", "\"", "'", "\\"].freeze
    UCHAR4          = /(?<!\\)\\(?!\\)u([0-9A-Fa-f]{4,4})/.freeze
    UCHAR8          = /(?<!\\)\\(?!\\)U([0-9A-Fa-f]{8,8})/.freeze
    UCHAR           = Regexp.union(UCHAR4, UCHAR8).freeze


    # Terminals from rdf-turtle.
    #
    # @see http://www.w3.org/TR/n-triples/
    # @see http://www.w3.org/TR/turtle/
    ##
    # Unicode regular expressions.
    U_CHARS1             = Regexp.compile(<<-EOS.gsub(/\s+/, ''))
                             [\\u00C0-\\u00D6]|[\\u00D8-\\u00F6]|[\\u00F8-\\u02FF]|
                             [\\u0370-\\u037D]|[\\u037F-\\u1FFF]|[\\u200C-\\u200D]|
                             [\\u2070-\\u218F]|[\\u2C00-\\u2FEF]|[\\u3001-\\uD7FF]|
                             [\\uF900-\\uFDCF]|[\\uFDF0-\\uFFFD]|[\\u{10000}-\\u{EFFFF}]
                           EOS
    U_CHARS2             = Regexp.compile("\\u00B7|[\\u0300-\\u036F]|[\\u203F-\\u2040]").freeze
    IRI_RANGE            = Regexp.compile("[[^<>\"{}\|\^`\\\\]&&[^\\x00-\\x20]]").freeze

    PN_CHARS_BASE        = /[A-Z]|[a-z]|#{U_CHARS1}/.freeze
    PN_CHARS_U           = /_|#{PN_CHARS_BASE}/.freeze
    PN_CHARS             = /-|[0-9]|#{PN_CHARS_U}|#{U_CHARS2}/.freeze
    ECHAR                = /\\[tbnrf"'\\]/.freeze

    IRIREF               = /<((?:#{IRI_RANGE}|#{UCHAR})*)>/.freeze
    BLANK_NODE_LABEL     = /_:((?:[0-9]|#{PN_CHARS_U})(?:(?:#{PN_CHARS}|\.)*#{PN_CHARS})?)/.freeze
    LANG_DIR             = /@([a-zA-Z]+(?:-[a-zA-Z0-9]+)*(?:--[a-zA-Z]+)?)/.freeze
    STRING_LITERAL_QUOTE = /"((?:[^\"\\\n\r]|#{ECHAR}|#{UCHAR})*)"/.freeze

    TT_START              = /^<<\(/.freeze
    TT_END                = /^\s*\)>>/.freeze

    QT_START              = /^<</.freeze      # DEPRECATED
    QT_END                = /^\s*>>/.freeze   # DEPRECATED

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_grammar
    COMMENT               = /^#\s*(.*)$/.freeze
    NODEID                = /^#{BLANK_NODE_LABEL}/.freeze
    URIREF                = /^#{IRIREF}/.freeze
    LITERAL_PLAIN         = /^#{STRING_LITERAL_QUOTE}/.freeze
    LITERAL_WITH_LANGUAGE = /^#{STRING_LITERAL_QUOTE}#{LANG_DIR}/.freeze
    LITERAL_WITH_DATATYPE = /^#{STRING_LITERAL_QUOTE}\^\^#{IRIREF}/.freeze
    DATATYPE_URI          = /^\^\^#{IRIREF}/.freeze
    LITERAL               = Regexp.union(LITERAL_WITH_LANGUAGE, LITERAL_WITH_DATATYPE, LITERAL_PLAIN).freeze
    SUBJECT               = Regexp.union(URIREF, NODEID).freeze
    PREDICATE             = Regexp.union(URIREF).freeze
    OBJECT                = Regexp.union(URIREF, NODEID, LITERAL).freeze
    END_OF_STATEMENT      = /^\s*\.\s*(?:#.*)?$/.freeze

    # LANGTAG is deprecated
    LANGTAG               = LANG_DIR
    RDF_VERSION          = /VERSION/.freeze

    ##
    # Reconstructs an RDF value from its serialized N-Triples
    # representation.
    #
    # @param  [String] input
    # @param [{Symbol => Object}] options
    #   From {RDF::Reader#initialize}
    # @option options  [RDF::Util::Logger] :logger ([])
    # @return [RDF::Term]
    def self.unserialize(input, **options)
      case input
        when nil then nil
        else self.new(input, logger: [], **options).read_value
      end
    end

    ##
    # (see unserialize)
    # @return [RDF::Resource]
    def self.parse_subject(input, **options)
      parse_uri(input, **options) || parse_node(input, **options)
    end

    ##
    # (see unserialize)
    # @return [RDF::URI]
    def self.parse_predicate(input, **options)
      parse_uri(input, intern: true)
    end

    ##
    # (see unserialize)
    def self.parse_object(input, **options)
      parse_uri(input, **options) || parse_node(input, **options) || parse_literal(input, **options)
    end

    ##
    # (see unserialize)
    # @return [RDF::Node]
    def self.parse_node(input, **options)
      if input =~ NODEID
        RDF::Node.new($1)
      end
    end

    ##
    # (see unserialize)
    # @param [Boolean] intern (false) Use Interned URI
    # @return [RDF::URI]
    def self.parse_uri(input, intern: false, **options)
      if input =~ URIREF
        RDF::URI.send(intern ? :intern : :new, unescape($1))
      end
    end

    ##
    # (see unserialize)
    # @return [RDF::Literal]
    def self.parse_literal(input, **options)
      case input
        when LITERAL_WITH_LANGUAGE
          language, direction = $4.split('--')
          RDF::Literal.new(unescape($1), language: language, direction: direction)
        when LITERAL_WITH_DATATYPE
          RDF::Literal.new(unescape($1), datatype: $4)
        when LITERAL_PLAIN
          RDF::Literal.new(unescape($1))
      end
    end

    # cache constants to optimize escaping the escape chars in self.unescape
    ESCAPE_CHARS_ESCAPED = {
      "\\b"   =>  "\b",
      "\\f"   =>  "\f",
      "\\t"   =>  "\t",
      "\\n"   =>  "\n",
      "\\r"   =>  "\r",
      "\\\""  =>  "\"",
      "\\'"   =>  "'",
      "\\\\"  =>  "\\"
    } .freeze
    ESCAPE_CHARS_ESCAPED_REGEXP = Regexp.union(
      ESCAPE_CHARS_ESCAPED.keys
    ).freeze

    ##
    # @param  [String] string
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    # @see    http://blog.grayproductions.net/articles/understanding_m17n
    # @see    http://yehudakatz.com/2010/05/17/encodings-unabridged/
    def self.unescape(string)
      # Note: avoiding copying the input string when no escaping is needed
      # greatly reduces the number of allocations and the processing time.
      string = string.dup.force_encoding(Encoding::UTF_8) unless string.encoding == Encoding::UTF_8

      string
        .gsub(UCHAR) do
          [($1 || $2).hex].pack('U*')
        end
        .gsub(ESCAPE_CHARS_ESCAPED_REGEXP, ESCAPE_CHARS_ESCAPED)
    end

    ##
    # @return [RDF::Term]
    def read_value
      begin
        read_statement
      rescue RDF::ReaderError
        value = read_uriref || read_node || read_literal || read_tripleTerm
        log_recover
        value
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
          if blank? || read_comment
            # No-op
          elsif version = read_version
            @options[:version] = version
          else
            subject   = read_uriref || read_node || fail_subject
            predicate = read_uriref(intern: true) || fail_predicate
            object    = read_uriref || read_node || read_literal || read_tripleTerm || fail_object

            if validate? && !read_eos
              log_error("Expected end of statement (found: #{current_line.inspect})", lineno: lineno, exception: RDF::ReaderError)
            end
            spo = [subject, predicate, object]
            # Only return valid triples if validating
            return spo if !validate? || spo.all?(&:valid?)
          end
        rescue RDF::ReaderError => e
          @line = line  # this allows #read_value to work
          raise e
        end
      end
    end

    ##
    # @return [RDF::Statement]
    def read_tripleTerm
      if @options[:rdfstar] && match(TT_START)
        if version && version != "1.2"
          log_warn("Triple term used with version #{version}")
        end
        subject   = read_uriref || read_node || fail_subject
        predicate = read_uriref(intern: true) || fail_predicate
        object    = read_uriref || read_node || read_literal || read_tripleTerm || fail_object
        if !match(TT_END)
          log_error("Expected end of statement (found: #{current_line.inspect})", lineno: lineno, exception: RDF::ReaderError)
        end
        RDF::Statement.new(subject, predicate, object, tripleTerm: true)
      end
    end

    ##
    # @return [Boolean]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (comment)
    def read_comment
      match(COMMENT)
    end

    ##
    # @param [Boolean] intern (false) Use Interned Node
    # @return [RDF::URI]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_grammar (uriref)
    def read_uriref(intern: false, **options)
      if uri_str = match(URIREF)
        uri_str = self.class.unescape(uri_str)
        uri = RDF::URI.send(intern? && intern ? :intern : :new, uri_str, canonicalize: canonicalize?)
        uri.validate!     if validate?
        uri
      end
    rescue ArgumentError
      log_error("Invalid URI (found: \"<#{uri_str}>\")", lineno: lineno, token: "<#{uri_str}>", exception: RDF::ReaderError)
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
          when lang_dir = match(LANG_DIR)
            language, direction = lang_dir.split('--')
            raise ArgumentError if direction && !@options[:rdfstar]
            log_warn("Literal base direction used with version #{version}") if version && version == "1.1"
            RDF::Literal.new(literal_str, language: language, direction: direction)
          when datatype = match(/^(\^\^)/) # FIXME
            RDF::Literal.new(literal_str, datatype: read_uriref || fail_object)
          else
            RDF::Literal.new(literal_str) # plain string literal
        end
        literal.validate!     if validate?
        literal.canonicalize! if canonicalize?
        literal
      end
    rescue ArgumentError
      v = literal_str
      v += "@#{lang_dir}" if lang_dir
      log_error("Invalid Literal (found: \"#{v}\")", lineno: lineno, token: v, exception: RDF::ReaderError)
    end

    ##
    # @return [String]
    def read_version
      if match(RDF_VERSION)
        ver_tok = match(LITERAL_PLAIN)
        unless RDF::Format::VERSIONS.include?(ver_tok)
          log_warn("Expected version to be one of #{RDF::Format::VERSIONS.join(', ')}, was #{ver_tok}")
        end
        ver_tok
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
