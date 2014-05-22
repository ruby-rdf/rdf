# -*- encoding: utf-8 -*-
module RDF
  ##
  # **`RDF::NQuads`** provides support for the N-Quads serialization format.
  #
  # This has not yet been implemented as of RDF.rb 0.3.x.
  module NQuads
    include RDF::NTriples

    ##
    # N-Quads format specification.
    #
    # @example Obtaining an NQuads format class
    #   RDF::Format.for(:nquads)     #=> RDF::NQuads::Format
    #   RDF::Format.for("etc/doap.nq")
    #   RDF::Format.for(:file_name      => "etc/doap.nq")
    #   RDF::Format.for(:file_extension => "nq")
    #   RDF::Format.for(:content_type   => "application/n-quads")
    #   RDF::Format.for(:content_type   => "text/x-nquads")
    #
    # @see http://www.w3.org/TR/n-quads/
    # @since  0.4.0
    class Format < RDF::Format
      content_type     'application/n-quads', :extension => :nq, :alias => ['text/x-nquads']
      content_encoding 'utf-8'

      reader { RDF::NQuads::Reader }
      writer { RDF::NQuads::Writer }
    
      ##
      # Sample detection to see if it matches N-Quads (or N-Triples)
      #
      # Use a text sample to detect the format of an input file. Sub-classes implement
      # a matcher sufficient to detect probably format matches, including disambiguating
      # between other similar formats.
      #
      # @param [String] sample Beginning several bytes (about 1K) of input.
      # @return [Boolean]
      def self.detect(sample)
        !!sample.match(%r(
          (?:\s*(?:<[^>]*>) | (?:_:\w+))                          # Subject
          \s*
          (?:\s*<[^>]*>)                                          # Predicate
          \s*
          (?:(?:<[^>]*>) | (?:_:\w+) | (?:"[^"\n]*"(?:^^|@\S+)?)) # Object
          \s*
          (?:\s*(?:<[^>]*>) | (?:_:\w+))                          # Context
          \s*\.
        )x) && !(
          sample.match(%r(@(base|prefix|keywords)|\{)) ||         # Not Turtle/N3/TriG
          sample.match(%r(<(html|rdf))i)                          # Not HTML or XML
        )
      end

      # Human readable name for this format
      def self.name; "N-Quads"; end
    end

    class Reader < NTriples::Reader
      ##
      # @param  [String] input
      # @return [RDF::Term]
      # @since  0.4.0
      def self.parse_context(input)
        parse_uri(input) || parse_node(input) || parse_literal(input)
      end

      ##
      # Read a Quad, where the context is optional
      #
      # @return [Array]
      # @see    http://sw.deri.org/2008/07/n-quads/#grammar
      # @since  0.4.0
      def read_triple
        loop do
          readline.strip! # EOFError thrown on end of input
          line = @line    # for backtracking input in case of parse error

          begin
            unless blank? || read_comment
              subject   = read_uriref || read_node || fail_subject
              predicate = read_uriref(:intern => true) || fail_predicate
              object    = read_uriref || read_node || read_literal || fail_object
              context    = read_uriref || read_node
              if validate? && !read_eos
                raise RDF::ReaderError.new("ERROR [line #{lineno}] Expected end of statement (found: #{current_line.inspect})")
              end
              return [subject, predicate, object, {:context => context}]
            end
          rescue RDF::ReaderError => e
            @line = line  # this allows #read_value to work
            raise e
          end
        end
      end

    end # Reader

    class Writer < NTriples::Writer
      ##
      # @param  [RDF::Statement] statement
      # @return [void] `self`
      def write_statement(statement)
        write_quad(*statement.to_quad)
        self
      end
      alias_method :insert_statement, :write_statement # support the RDF::Writable interface

      ##
      # Outputs the N-Quads representation of a statement.
      #
      # @param  [RDF::Resource] subject
      # @param  [RDF::URI]      predicate
      # @param  [RDF::Term]     object
      # @return [void]
      def write_quad(subject, predicate, object, context)
        puts format_quad(subject, predicate, object, context, @options)
      end

      ##
      # Returns the N-Quads representation of a statement.
      #
      # @param  [RDF::Statement] statement
      # @param  [Hash{Symbol => Object}] options = ({})
      # @return [String]
      # @since  0.4.0
      def format_statement(statement, options = {})
        format_quad(*statement.to_quad, options)
      end

      ##
      # Returns the N-Triples representation of a triple.
      #
      # @param  [RDF::Resource] subject
      # @param  [RDF::URI]      predicate
      # @param  [RDF::Term]     object
      # @param  [RDF::Term]     context
      # @param  [Hash{Symbol => Object}] options = ({})
      # @return [String]
      def format_quad(subject, predicate, object, context, options = {})
        s = "%s %s %s " % [subject, predicate, object].map { |value| format_term(value, options) }
        s += format_term(context, options) + " " if context
        s + "."
      end
    end # Writer

    ##
    # Reconstructs an RDF value from its serialized N-Triples
    # representation.
    #
    # @param  [String] data
    # @return [RDF::Value]
    # @see    RDF::NTriples::Reader.unserialize
    # @since  0.1.5
    def self.unserialize(data)
      Reader.unserialize(data)
    end

    ##
    # Returns the serialized N-Triples representation of the given RDF
    # value.
    #
    # @param  [RDF::Value] value
    # @return [String]
    # @see    RDF::NTriples::Writer.serialize
    # @since  0.1.5
    def self.serialize(value)
      Writer.serialize(value)
    end
  end # NQuads


  ##
  # Extensions for `RDF::Value`.
  module Value
    ##
    # Returns the N-Quads representation of this value.
    #
    # This method is only available when the 'rdf/nquads' serializer has
    # been explicitly required.
    #
    # @return [String]
    # @since  0.4.0
    def to_nquads
      RDF::NQuads.serialize(self)
    end
  end # Value
end # RDF
