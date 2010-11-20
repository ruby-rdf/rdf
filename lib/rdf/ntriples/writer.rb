module RDF::NTriples
  ##
  # N-Triples serializer.
  #
  # @example Obtaining an NTriples writer class
  #   RDF::Writer.for(:ntriples)     #=> RDF::NTriples::Writer
  #   RDF::Writer.for("etc/test.nt")
  #   RDF::Writer.for(:file_name      => "etc/test.nt")
  #   RDF::Writer.for(:file_extension => "nt")
  #   RDF::Writer.for(:content_type   => "text/plain")
  #
  # @example Serializing RDF statements into an NTriples file
  #   RDF::NTriples::Writer.open("etc/test.nt") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @example Serializing RDF statements into an NTriples string
  #   RDF::NTriples::Writer.buffer do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Writer < RDF::Writer
    format RDF::NTriples::Format

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    ESCAPE_PLAIN = /\A[\x20-\x21\x23-\x5B\x5D-\x7E]*\z/m.freeze
    ESCAPE_ASCII = /\A[\x00-\x7F]*\z/m.freeze

    ##
    # @param  [String] string
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.escape(string)
      case
        when string =~ ESCAPE_PLAIN # a shortcut for the simple case
          string
        when string.respond_to?(:ascii_only?) && string.ascii_only?
          StringIO.open do |buffer|
            string.each_byte { |u| buffer << escape_ascii(u) }
            buffer.string
          end
        when string.respond_to?(:each_codepoint)
          StringIO.open do |buffer|
            string.each_codepoint { |u| buffer << escape_unicode(u) }
            buffer.string
          end
        else # works in Ruby 1.8.x, too
          StringIO.open do |buffer|
            string.scan(/./mu) { |c| buffer << escape_unicode(u = c.unpack('U*').first) }
            buffer.string
          end
      end
    end

    ##
    # @param  [Integer, #ord] u
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.escape_unicode(u)
      case (u = u.ord)
        when (0x00..0x7F)        # ASCII 7-bit
          escape_ascii(u)
        when (0x80..0xFFFF)      # Unicode BMP
          escape_utf16(u)
        when (0x10000..0x10FFFF) # Unicode
          escape_utf32(u)
        else
          raise ArgumentError.new("expected a Unicode codepoint in (0x00..0x10FFFF), but got 0x#{u.to_s(16)}")
      end
    end

    ##
    # @param  [Integer, #ord] u
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.escape_ascii(u)
      case (u = u.ord)
        when (0x00..0x08) then escape_utf16(u)
        when (0x09)       then "\\t"
        when (0x0A)       then "\\n"
        when (0x0B..0x0C) then escape_utf16(u)
        when (0x0D)       then "\\r"
        when (0x0E..0x1F) then escape_utf16(u)
        when (0x22)       then "\\\""
        when (0x5C)       then "\\\\"
        when (0x7F)       then escape_utf16(u)
        when (0x00..0x7F) then u.chr
        else
          raise ArgumentError.new("expected an ASCII character in (0x00..0x7F), but got 0x#{u.to_s(16)}")
      end
    end

    ##
    # @param  [Integer, #ord] u
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.escape_utf16(u)
      sprintf("\\u%04X", u.ord)
    end

    ##
    # @param  [Integer, #ord] u
    # @return [String]
    # @see    http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    def self.escape_utf32(u)
      sprintf("\\U%08X", u.ord)
    end

    ##
    # Returns the serialized N-Triples representation of the given RDF
    # value.
    #
    # @param  [RDF::Value] value
    # @return [String]
    # @raise  [ArgumentError] if `value` is not an `RDF::Statement` or `RDF::Term`
    def self.serialize(value)
      writer = self.new
      case value
        when nil then nil
        when RDF::Statement
          writer.format_statement(value) + "\n"
        when RDF::Term
          writer.format_term(value)
        else
          raise ArgumentError, "expected an RDF::Statement or RDF::Term, but got #{value.inspect}"
      end
    end

    ##
    # Outputs an N-Triples comment line.
    #
    # @param  [String] text
    # @return [void]
    def write_comment(text)
      puts "# #{text.chomp}" # TODO: correctly output multi-line comments
    end

    ##
    # Outputs the N-Triples representation of a triple.
    #
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Term]     object
    # @return [void]
    def write_triple(subject, predicate, object)
      puts format_triple(subject, predicate, object)
    end

    ##
    # Returns the N-Triples representation of a statement.
    #
    # @param  [RDF::Statement] statement
    # @return [String]
    def format_statement(statement)
      format_triple(*statement.to_triple)
    end

    ##
    # Returns the N-Triples representation of a triple.
    #
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Term]     object
    # @return [String]
    def format_triple(subject, predicate, object)
      "%s %s %s ." % [subject, predicate, object].map { |value| format_term(value) }
    end

    ##
    # Returns the N-Triples representation of a blank node.
    #
    # @param  [RDF::Node] node
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_node(node, options = {})
      "_:%s" % node.id
    end

    ##
    # Returns the N-Triples representation of a URI reference.
    #
    # @param  [RDF::URI] literal
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_uri(uri, options = {})
      "<%s>" % escaped(uri_for(uri))
    end

    ##
    # Returns the N-Triples representation of a literal.
    #
    # @param  [RDF::Literal, String, #to_s] literal
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_literal(literal, options = {})
      case literal
        when RDF::Literal
          text = quoted(escaped(literal.value))
          text << "@#{literal.language}" if literal.has_language?
          text << "^^<#{uri_for(literal.datatype)}>" if literal.has_datatype?
          text
        else
          quoted(escaped(literal.to_s))
      end
    end

    ##
    # @private
    def escaped(string)
      self.class.escape(string)
    end
  end
end
