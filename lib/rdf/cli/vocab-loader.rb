require 'rdf'
require 'optparse'
require 'erb'

module RDF
  class VocabularyLoader
    def initialize(argv)
      @argv = argv
      @output = $stdout
      @output_class_file = true
      @format = :ntriples
      @prefix = nil
      @url = nil
      @required_files = []
      @format_pairs = {}
    end
    attr_accessor :format, :required_files, :class_name
    attr_reader :prefix, :source

    def prefix=(uri)
      @prefix = uri
      @source ||= uri
    end

    def source=(uri)
      @source = uri
      @prefix ||= uri
    end

    def parse_options
      opti = OptionParser.new
      opti.banner = "Usage: #{File.basename($0)} [options] [prefix [outfile]]"

      opti.on("--output-format FORMAT") do |format|
        @format = format.intern
      end

      opti.on("--prefix URI") do |uri|
        self.prefix = uri
      end

      opti.on("--source URI") do |uri|
        self.source = uri
      end

      opti.on("--class-name NAME") do |name|
        self.class_name = name
      end

      opti.on("--raw") do
        @output_class_file = false
      end

      opti.on("--help") do
        $stdout.puts opti
        exit 1
      end

      others = opti.parse(@argv)

      if @class_name.nil?
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

    def graph
      RDF::Graph.load(source)
    end

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

    def require_formats
      RDF::Format.reader_symbols.each do |sym|
        @format_pairs[sym] = nil
      end

      %w{rdf/rdfa rdf/turtle rdf/rdfxml rdf/n3 json/ld rdf/trig rdf/trix}.each do |format_file|
        begin
          require format_file
          (RDF::Format.reader_symbols - @format_pairs.keys).each do |sym|
            @format_pairs[sym] = format_file
          end
        rescue LoadError
        end
      end
    end

    def go
      parse_options
      require_formats

      @required_files << @format_pairs[format]
      @required_files.compact!
      @required_files.uniq!

      template = ERB.new(output_template)
      @output.print(template.result(binding))

      if @output != $stdout
        @output.close
      end
    end

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
      <%= vocabulary_graph.gsub(/^/, "        ") %>
      endofgraph
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
