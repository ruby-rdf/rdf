require 'rdf'
require 'optparse'
require 'erb'

module RDF
  # Utility class to load RDF vocabularies from files or their canonical
  # definitions and emit either a class file for RDF::StrictVocabulary or the
  # raw RDF vocabulary
  class VocabularyLoader
    def initialize
      @output = $stdout
      @output_class_file = true
      @format = :ntriples
      @prefix = nil
      @url = nil
      @required_files = []
      @format_pairs = {}
      @format_files = %w{rdf/rdfa rdf/turtle rdf/rdfxml rdf/n3 json/ld rdf/trig rdf/trix}
    end
    attr_accessor :format, :required_files, :class_name, :output, :output_class_file
    attr_reader :prefix, :source

    # Set the prefix for the loaded RDF file - by default, sets the source as
    # well
    def prefix=(uri)
      @prefix = uri
      @source ||= uri
    end

    # Set the source for the loaded RDF - by default, sets the prefix as well
    def source=(uri)
      @source = uri
      @prefix ||= uri
    end

    # Parses arguments, for use in a command line tool
    def parse_options(argv)
      opti = OptionParser.new
      opti.banner = "Usage: #{File.basename($0)} [options] [prefix [outfile]]\nFetch an RDFS file and produce an RDF::StrictVocabulary with it.\n\n"

      opti.on("--output-format FORMAT", "The RDF format to output in") do |format|
        @format = format.intern
      end

      opti.on("--prefix URI", "The prefix for the fetched RDF vocabulary") do |uri|
        self.prefix = uri
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

      if prefix.nil?
        self.prefix, outfile, extra = *others
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

    # Returns a string that represents the loaded graph in the specified format
    def vocabulary_graph
      writer = Writer.for(format)
      if writer.nil?
        raise "No writer available for #{format}\nAvailable are: #{RDF::Format.writer_symbols.join(", ")}"
      end
      writer.buffer do |writer|
        graph.each_statement do |statement|
          writer << statement
        end
      end
    end

    # Loads format files, as well as caching their sources so that we can
    # reconstruct which files need to be loaded to parse the graph
    def require_formats
      RDF::Format.reader_symbols.each do |sym|
        @format_pairs[sym] = nil
      end

      @format_files.each do |format_file|
        begin
          require format_file
          (RDF::Format.reader_symbols - @format_pairs.keys).each do |sym|
            @format_pairs[sym] = format_file
          end
        rescue LoadError
        end
      end
    end

    # Parse command line arguments and run the load-and-emit process
    def go(argv)
      parse_options(argv)
      run

      if @output != $stdout
        @output.close
      end
    end

    # Actually executes the load-and-emit process - useful when using this
    # class outside of a command line - instantiate, set attributes manually,
    # then call #run
    def run
      require_formats

      @required_files << @format_pairs[format]
      @required_files.compact!
      @required_files.uniq!

      template = ERB.new(output_template)
      @output.print(template.result(binding))
    end

    # Returns an appropriate output template based on whether output_class_file
    # is set i.e. not called with --raw
    def output_template
      if @output_class_file
        <<-EOT
require 'rdf'
<% required_files.each do |required_file| %>require '<%= required_file %>'
<% end %>
module RDF
  class <%= class_name %> < StrictVocabulary("<%= prefix %>")
    graph do |graph|
      data = StringIO.new(<<-endofgraph)
<%= vocabulary_graph.gsub(/^/, "        ")
%>      endofgraph
      RDF::Reader.for(<%= format.inspect %>) do |reader|
        graph.insert(reader)
      end
    end
  end
end
        EOT
      else
        "<%= vocabulary_graph %>"
      end
    end
  end
end
