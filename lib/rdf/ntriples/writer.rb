module RDF::NTriples
  ##
  # N-Triples serializer.
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Writer < RDF::Writer
    format RDF::NTriples::Format

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
