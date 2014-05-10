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

    # @private
    def from_solution(solution)
      uri_match = %r{\A#{@uri}(.*)}
      return if !solution.resource.uri? || (match = uri_match.match(solution.resource.to_s)).nil?
      name = match[1]

      # If there's a label or comment, the must either have no language, or be en
      label = solution[:label]
      comment = solution[:comment]

      return if label && label.has_language? && !label.language.to_s.start_with?("en")
      return if comment && comment.has_language? && !comment.language.to_s.start_with?("en")
      label = label.to_s.
        encode(Encoding::US_ASCII). # also force exception if invalid
        strip.
        gsub(/\s+/m, ' ')
      comment = comment.to_s.
        encode(Encoding::US_ASCII). # also force exception if invalid
        strip.
        gsub(/\s+/m, ' ').
        gsub(/([\(\)])/, '\\\\\\1')

      @output.write "    property #{name.to_sym.inspect}"
      @output.write ", :label => '#{label}'" unless label.empty?
      @output.write ", :comment =>\n      %(#{comment.scan(/\S.{0,60}\S(?=\s|$)|\S+/).join("\n        ")})" unless comment.empty?
      @output.puts
    rescue Encoding::UndefinedConversionError
    end

    # Actually executes the load-and-emit process - useful when using this
    # class outside of a command line - instantiate, set attributes manually,
    # then call #run
    def run
      @output.print %(# This file generated automatically using vocab-fetch from #{source}
        require 'rdf'
        module RDF
          class #{class_name} < #{"Strict" if @strict}Vocabulary("#{uri}")
        ).gsub(/^        /, '') if @output_class_file

      classes = RDF::Query.new do
        pattern [:resource, RDF.type, RDFS.Class]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      owl_classes = RDF::Query.new do
        pattern [:resource, RDF.type, OWL.Class]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      class_defs = graph.query(classes).to_a + graph.query(owl_classes).to_a
      unless class_defs.empty?
        @output.puts "\n    # Class definitions"
        class_defs.sort_by {|s| (s[:label] || s[:resource]).to_s}.each do |klass|
          from_solution(klass)
        end
      end

      properties = RDF::Query.new do
        pattern [:resource, RDF.type, RDF.Property]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      dt_properties = RDF::Query.new do
        pattern [:resource, RDF.type, OWL.DatatypeProperty]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      obj_properties = RDF::Query.new do
        pattern [:resource, RDF.type, OWL.ObjectProperty]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      ann_properties = RDF::Query.new do
        pattern [:resource, RDF.type, OWL.AnnotationProperty]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      ont_properties = RDF::Query.new do
        pattern [:resource, RDF.type, OWL.OntologyProperty]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end
      prop_defs = graph.query(properties).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      prop_defs += graph.query(dt_properties).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      prop_defs += graph.query(obj_properties).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      prop_defs += graph.query(ann_properties).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      prop_defs += graph.query(ont_properties).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      unless prop_defs.empty?
        @output.puts "\n    # Property definitions"
        prop_defs.each do |prop|
          from_solution(prop)
        end
      end


      datatypes = RDF::Query.new do
        pattern [:resource, RDF.type, RDFS.Datatype]
        pattern [:resource, RDFS.label, :label], :optional => true
        pattern [:resource, RDFS.comment, :comment], :optional => true
      end

      dt_defs = graph.query(datatypes).to_a.sort_by {|s| (s[:label] || s[:resource]).to_s}
      unless dt_defs.empty?
        @output.puts "\n    # Datatype definitions"
        dt_defs.each do |dt|
          from_solution(dt)
        end
      end

      unless @extra.empty?
        @output.puts "\n    # Extra definitions"
        case @extra
        when Array
          @extra.each do |extra|
            @output.puts "    property #{extra.to_sym.inspect}"
          end
        when Hash
          @extra.each do |n, opts|
            @output.puts "    property #{n.to_sym.inspect}, #{opts.inspect}"
          end
        end
      end

      # Query the vocabulary to extract property and class definitions
      @output.puts "  end\nend" if @output_class_file
    end
  end
end
