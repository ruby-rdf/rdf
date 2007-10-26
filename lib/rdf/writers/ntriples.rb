module RDF::Writers
  class NTriples < RDF::Writer

    content_type 'text/plain', :extension => :nt
    content_encoding 'ascii'

    def write_node(resource)
      nodes = []

      s = resource.anonymous? ? @nodes[resource] : "<#{resource.uri}>"
      resource.data.each do |predicate, objects|
        p = "<#{predicate}>"

        [objects].flatten.each do |object|
          case object # FIXME: should use duck typing
            when RDF::URIRef
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
      puts "%s %s %s ." % [s, p, o]
    end

  end
end
