require 'rexml/document'

module RDF::Readers

  # See <http://swdev.nokia.com/trix/trix.html>
  class TriX < RDF::Reader
    include REXML

    content_type 'application/trix', :extension => :xml
    content_encoding 'utf-8'

    def initialize(input = $stdin, options = {}, &block)
      super do
        @xml = Document.new(@input, :compress_whitespace => %w{uri})
        block.call(self) if block_given?
      end
    end

    def each_triple(&block)
      @xml.elements.each('TriX/graph/triple') do |parent|
        elements = parent.find_all { |element| element.kind_of?(Element) }[0..2]
        block.call(*elements.map { |element| parse_element(element) })
      end
    end

    protected

      def parse_element(element)
        case element.name.to_sym
          when :uri
            RDF::URIRef.new(element.text.strip)

          when :id
            node_id = element.text.strip
            @nodes[node_id] ||= RDF::Node.new

          when :plainLiteral
            language = element.attributes['xml:lang']
            !language ? element.text : RDF::Literal.new(element.text, :language => language)

          when :typedLiteral
            datatype = element.attributes['datatype']
            RDF::Literal.new(element.text, :type => datatype)
        end
      end

  end
end
