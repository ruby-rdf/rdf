require 'rexml/document'

module RDF::Writers

  # See <http://swdev.nokia.com/trix/trix.html>
  class TriX < RDF::Writer
    include REXML

    content_type 'application/trix', :extension => :xml
    content_encoding 'utf-8'

    XMLNS = 'http://www.w3.org/2004/03/trix/trix-1/'

    def write_prologue
      @xml = Document.new
      @xml << XMLDecl.new(XMLDecl::DEFAULT_VERSION, XMLDecl::DEFAULT_ENCODING)
      @trix = @xml.add_element('TriX', 'xmlns' => XMLNS)
      @graph = @trix.add_element('graph')
    end

    def write_comment(text)
      @graph << Comment.new(text)
    end

    def write_triple(subject, predicate, object)
      triple = @graph.add_element('triple')

      # FIXME: add proper anonymous node handling
      triple.add_element('uri').add_text(uri_for(subject))

      triple.add_element('uri').add_text(uri_for(predicate))

      case object
        when RDF::URIRef
          # FIXME: add proper anonymous node handling
          triple.add_element('uri').add_text(uri_for(object))
        when RDF::Literal
          if object.typed?
            literal = triple.add_element('typedLiteral')
            literal.add_attribute('datatype', uri_for(object.type))
          else
            literal = triple.add_element('plainLiteral')
            literal.add_attribute('xml:lang', object.language.to_s) if object.language
          end
          literal.add_text(object.value)
        else
          triple.add_element('plainLiteral').add_text(object.to_s)
      end
    end

    def write_epilogue
      @xml.write(@output, 0)
      puts # add a line break after the last line
    end

  end
end
