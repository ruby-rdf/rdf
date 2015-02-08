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
      @module_name = "RDF"
      @output = $stdout
      @output_class_file = true
      @uri = nil
      @strict = true
      @extra = []
    end
    attr_accessor :class_name, :module_name, :output, :output_class_file
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
      opti.banner = "Usage: #{File.basename($0)} [options] [uri]\nFetch an RDFS file and produce an RDF::StrictVocabulary with it.\n\n"

      opti.on("--uri URI", "The URI for the fetched RDF vocabulary") do |uri|
        self.uri = uri
      end

      opti.on("--source SOURCE", "The source URI or file for the vocabulary") do |uri|
        self.source = uri
      end

      opti.on("--class-name NAME", "The class name for the output StrictVocabulary subclass") do |name|
        self.class_name = name
      end

      opti.on("--module-name NAME", "The module name for the output StrictVocabulary subclass") do |name|
        self.module_name = name
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

      uri ||= others.first
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
        next if key == :vocab
        value = Array(attributes[key])
        component = key.is_a?(Symbol) ? "#{key}: " : "#{key.inspect} => "
        value = value.first if value.length == 1
        component << if value.is_a?(Array)
          '[' + value.map {|v| serialize_value(v, key)}.join(", ") + "]"
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
        module #{module_name}
          class #{class_name} < RDF::#{"Strict" if @strict}Vocabulary("#{uri}")
        ).gsub(/^        /, '') if @output_class_file

      # Extract statements with subjects that have the vocabulary prefix and organize into a hash of properties and values
      vocab = RDF::Vocabulary.load(uri, location: source, extra: @extra)

      # Split nodes into Class/Property/Datatype/Other
      term_nodes = {
        class: {},
        property: {},
        datatype: {},
        other: {}
      }

      vocab.each.to_a.sort.each do |term|
        name = term.to_s[uri.length..-1].to_sym
        kind = begin
          case term.type.to_s
          when /Class/    then :class
          when /Property/ then :property
          when /Datatype/ then :datatype
          else                 :other
          end
        rescue KeyError
          # This can try to resolve referenced terms against the previous version of this vocabulary, which may be strict, and fail if the referenced term hasn't been created yet.
          :other
        end
        term_nodes[kind][name] = term.attributes
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
