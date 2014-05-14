require 'rdf'
require 'linkeddata'
require 'optparse'

module RDF
  # Utility class to load RDF vocabularies from files or their canonical
  # definitions and emit either a class file for RDF::StrictVocabulary,
  # RDF::Vocabulary or the raw RDF vocabulary
  class VocabularyLoader
    def initialize(class_name = nil)
      @class_name = class_name
      @output = $stdout
      @output_class_file = true
      @uri = nil
      @strict = true
      @extra = []
    end
    attr_accessor :class_name, :output, :output_class_file
    attr_reader :uri, :source

    # Set the URI for the loaded RDF file - by default, sets the source as
    # well
    def uri=(uri)
      @uri = uri
      @source ||= uri
    end

    # Set the source for the loaded RDF - by default, sets the URI as well
    def source=(uri)
      @source = uri
      @uri ||= uri
    end

    # Set output
    def output=(out)
      @output = out
    end

    # Extra properties to define
    def extra=(extra)
      @extra = extra
    end

    # Use StrictVocabulary or Vocabulary
    def strict=(strict)
      @strict = strict
    end

    # Parses arguments, for use in a command line tool
    def parse_options(argv)
      opti = OptionParser.new
      opti.banner = "Usage: #{File.basename($0)} [options] [uri [outfile]]\nFetch an RDFS file and produce an RDF::StrictVocabulary with it.\n\n"

      opti.on("--uri URI", "The URI for the fetched RDF vocabulary") do |uri|
        self.uri = uri
      end

      opti.on("--source SOURCE", "The source URI or file for the vocabulary") do |uri|
        self.source = uri
      end

      opti.on("--class-name NAME", "The class name for the output StrictVocabulary subclass") do |name|
        self.class_name = name
      end

      opti.on("--raw", "Don't output an output file - just the RDF") do
        @output_class_file = false
      end

      opti.on_tail("--help", "This help text") do
        $stdout.puts opti
        exit 1
      end

      others = opti.parse(argv)

      if @class_name.nil? and @output_class_file
        raise "Class name (--class-name) is required!"
      end

      if uri.nil?
        self.uri, outfile, extra = *others
      else
        outfile, extra = *others
      end

      unless outfile.nil?
        @output = File.open(outfile, "w")
      end

      unless extra.nil?
        $stderr.puts "Too many arguments!"
        $stderr.puts opti
        exit 1
      end
    end

    # Loads the graph
    def graph
      @graph ||= RDF::Graph.load(source)
    end

    # Parse command line arguments and run the load-and-emit process
    def go(argv)
      parse_options(argv)
      run

      if @output != $stdout
        @output.close
      end
    end

    ##
    # Turn a node definition into a property/term expression
    def from_node(name, attributes, term_type)
      op = term_type == :property ? "property" : "term"

      components = ["    #{op} #{name.to_sym.inspect}"]
      attributes.keys.sort_by(&:to_s).each do |key|
        value = attributes[key]
        component = key.is_a?(Symbol) ? "#{key}: " : "#{key.inspect} => "
        value = value.first if value.length == 1
        component << if value.is_a?(Array)
          '[' + value.map {|v| serialize_value(v, key)}.join("], [") + "]"
        else
          serialize_value(value, key)
        end
        components << component
      end
      @output.puts components.join(",\n      ")
    end

    def serialize_value(value, key)
      case key
      when :comment, String
        "%(#{value.gsub('(', '\(').gsub(')', '\)')}).freeze"
      else
        "#{value.inspect}.freeze"
      end
    end

    # Actually executes the load-and-emit process - useful when using this
    # class outside of a command line - instantiate, set attributes manually,
    # then call #run
    def run
      @output.print %(# -*- encoding: utf-8 -*-
        # This file generated automatically using vocab-fetch from #{source}
        require 'rdf'
        module RDF
          class #{class_name} < #{"Strict" if @strict}Vocabulary("#{uri}")
        ).gsub(/^        /, '') if @output_class_file

      # Extract statements with subjects that have the vocabulary prefix and organize into a hash of properties and values
      term_defs = {}
      graph.each do |statement|
        next unless statement.subject.uri? && statement.subject.start_with?(uri)
        term = (term_defs[statement.subject] ||= {})
        (term[statement.predicate] ||= []) << statement.object
      end
      
      # Split nodes into Class/Property/Datatype/Other
      term_nodes = {
        class: {},
        property: {},
        datatype: {},
        other: {}
      }
      term_defs.keys.sort.each do |subject|
        node = term_defs[subject]
        node_classification = case node[RDF.type].to_s
        when /Class/    then :class
        when /Property/ then :property
        when /Datatype/ then :datatype
        else                 :other
        end

        name = subject.to_s[uri.to_s.length..-1]
        term_nodes[node_classification][name] = attributes = {}

        node.each do |key, values|
          prop = case key
          when RDF.type                then :type
          when RDF::RDFS.subClassOf    then :subClassOf
          when RDF::RDFS.subPropertyOf then :subPropertyOf
          when RDF::RDFS.range         then :range
          when RDF::RDFS.domain        then :domain
          when RDF::RDFS.comment       then :comment
          when RDF::RDFS.label         then :label
          else                         RDF::URI(key).pname
          end

          values = values.map do |v|
            if v.uri?
              v.pname
            elsif v.literal? && (v.language || :en) == :en
              v.to_s
            end
          end.compact
          next if values.empty?
          attributes[prop] = values.length > 1 ? values.first : values
        end
      end

      # Add extra definitions
      case @extra
      when Array
        @extra.each do |extra|
          term_nodes[:other][extra.to_sym] = {label: extra.to_s}
        end
      when Hash
        @extra.each do |n, opts|
          term_nodes[:other][n] = {label: n.to_s}.merge(opts)
        end
      end

      {
        class: "Class definitions",
        property: "Property definitions",
        datatype: "Datatype definitions",
        other: "Extra definitions"
      }.each do |tt, comment|
        next if term_nodes[tt].empty?
        @output.puts "\n    # #{comment}"
        term_nodes[tt].each {|name, attributes| from_node name, attributes, tt}
      end

      # Query the vocabulary to extract property and class definitions
      @output.puts "  end\nend" if @output_class_file
    end
  end
end
