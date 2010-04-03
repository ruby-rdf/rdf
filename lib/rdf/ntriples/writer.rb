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

    ##
    # Returns the serialized N-Triples representation of the given RDF
    # value.
    #
    # @param  [RDF::Value] value
    # @return [String]
    def self.serialize(value)
      writer = self.new
      case value
        when nil then nil
        when RDF::Statement
          writer.format_statement(value) + "\n"
        else
          writer.format_value(value)
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
    # @param  [RDF::Value]    object
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
    # @param  [RDF::Value]    object
    # @return [String]
    def format_triple(subject, predicate, object)
      "%s %s %s ." % [subject, predicate, object].map { |value| format_value(value) }
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
      "<%s>" % uri_for(uri)
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
  end
end
