require 'rdf/writers/ntriples'

module RDF::Writers

  # See <http://www.dajobe.org/2004/01/turtle/>
  class Turtle < NTriples

    content_type 'application/x-turtle', :extension => :ttl
    content_encoding 'utf-8'

    def write_prologue
      @subject = nil
      write_base(@options[:base]) if @options[:base]
      write_prefix(nil, @options[:ns]) if @options[:ns]
      [@options[:prefix] || []].flatten.each do |prefix|
        write_prefix(prefix, RDF::Namespace[prefix])
      end
    end

    def write_base(uriref)
      puts "@base #{format_uri(uriref)} ."
    end

    def write_prefix(prefix, uriref)
      puts "@prefix #{prefix}: #{format_uri(uriref)} ."
    end

    def write_statements(*statements)
      write_triples(*statements.flatten.map { |stmt| stmt.to_a })
    end

    def write_triples(*triples)
      triples.sort! if @options[:sort]

      triples.each do |s, p, o|
        separator = ';'

        if @subject != s
          puts "%s" % [format_uri(s)]
          @subject = s
        end

        o = o.kind_of?(RDF::URIRef) ? format_uri(o) : format_literal(o)
        puts "\t%s %s %s" % [format_uri(p), o, separator]
      end
    end

    def format_uri(node)
      format_qname(node) || super
    end

    def format_qname(node)
      # TODO
    end

  end
end
