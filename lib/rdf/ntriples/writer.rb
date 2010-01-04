module RDF::NTriples
  ##
  # N-Triples serializer.
  #
  # @see http://www.w3.org/TR/rdf-testcases/#ntriples
  class Writer < RDF::Writer
    format RDF::NTriples::Format

    ##
    # @param  [String] text
    # @return [void]
    def write_comment(text)
      puts "# #{text}"
    end

    ##
    # @param  [Resource] subject
    # @param  [URI]      predicate
    # @param  [Value]    object
    # @return [void]
    def write_triple(subject, predicate, object)
      puts "%s %s %s ." % [subject, predicate, object].map { |value| format_value(value) }
    end

    ##
    # @param  [URI]                    value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_uri(value, options = {})
      "<%s>" % uri_for(value)
    end

    ##
    # @param  [Node]                   value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_node(value, options = {})
      "_:%s" % node.id
    end

    ##
    # @param  [Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    def format_literal(value, options = {})
      case value
        when RDF::Literal
          text = quoted(escaped(value.value))
          text << "@#{value.language}" if value.language
          text << "^^<#{uri_for(value.datatype)}>" if value.datatype
          text
        else
          quoted(escaped(value.to_s))
      end
    end
  end
end
