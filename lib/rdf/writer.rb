module RDF
  class Writer

    def self.format(format)
      case format.to_sym
        when :ntriples then RDF::Writers::NTriples
        when :turtle then RDF::Writers::Turtle
        when :n3 then RDF::Writers::N3
        when :rdfxml, :"rdfxml-abbrev" then RDF::Writers::XML
        when :trix then RDF::Writers::TriX
      end
    end

    def initialize(stream = $stdout, &block)
      @stream = stream
      @nodes = {}
      @node_id = 0
      block.call(self) if block_given?
    end

    def node_id
      "_:n#{@node_id += 1}"
    end

    def register!(resource)
      return false if @nodes[resource] # already seen it
      @nodes[resource] = resource.uri || node_id
    end

    def <<(resource)
      register!(resource) && write_node(resource)
    end

    def escaped(string)
      string.gsub("\\", "\\\\").gsub("\t", "\\\t").
        gsub("\n", "\\\n").gsub("\r", "\\\r").gsub("\"", "\\\"")
    end

    def quoted(string)
      "\"#{string}\""
    end

    def write_node(resource)
      nodes = []

      s = resource.anonymous? ? @nodes[resource] : "<#{resource.uri}>"
      resource.data.each do |predicate, objects|
        p = "<#{predicate}>"

        [objects].flatten.each do |object|
          case object # FIXME: should use duck typing
            when RDF::Resource
              nodes << object if register!(object)
              o = object.anonymous? ? @nodes[object] : "<#{object.uri}>"
            when RDF::Literal
              o = quoted(escaped(object.value))
              o << "@#{language}" if object.language
              o << "^^<#{object.type.uri}>" if object.type
            else
              o = quoted(escaped(object.to_s))
          end

          write_triple s, p, o
        end
      end

      nodes.each { |node| write_node node }
    end

    def write_triple(s, p, o)
      @stream.puts "%s %s %s ." % [s, p, o]
    end

  end

  module Writers
    class NTriples < Writer; end
    class Turtle < NTriples; end
    class N3 < Turtle; end
    class XML < Writer; end
    class TriX < Writer; end
  end
end
