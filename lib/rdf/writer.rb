module RDF
  class Writer

    @@subclasses = []
    @@file_extensions = {}
    @@content_types = {}
    @@content_encoding = {}

    def self.format(format)
      require "rdf/writers/#{format}"

      case format.to_sym
        when :ntriples  then RDF::Writers::NTriples
        when :turtle    then RDF::Writers::Turtle
        when :notation3 then RDF::Writers::Notation3
        when :rdfxml    then RDF::Writers::RDFXML
        when :trix      then RDF::Writers::TriX
      end
    end

    def self.each(&block)
      !block_given? ? @@subclasses : @@subclasses.each { |klass| yield klass }
    end

    def self.content_types
      @@content_types
    end

    def self.file_extensions
      @@file_extensions
    end

    def initialize(stream = $stdout, &block)
      @stream = stream
      @nodes = {}
      @node_id = 0
      block.call(self) if block_given?
    end

    def <<(resource)
      register!(resource) && write_node(resource)
    end

    protected

      def self.inherited(child) #:nodoc:
        @@subclasses << child
        super
      end

      def self.content_type(type, options = {})
        @@content_types[type] ||= []
        @@content_types[type] << self

        if options[:extension]
          extensions = [options[:extension]].flatten.map { |ext| ext.to_sym }
          extensions.each { |ext| @@file_extensions[ext] = type }
        end
      end

      def self.content_encoding(encoding)
        @@content_encoding[self] = encoding.to_sym
      end

      def puts(*args)
        @stream.puts(*args)
      end

      def node_id
        "_:n#{@node_id += 1}"
      end

      def register!(resource)
        return false if @nodes[resource] # already seen it
        @nodes[resource] = resource.uri || node_id
      end

      def escaped(string)
        string.gsub("\\", "\\\\").gsub("\t", "\\\t").
          gsub("\n", "\\\n").gsub("\r", "\\\r").gsub("\"", "\\\"")
      end

      def quoted(string)
        "\"#{string}\""
      end

  end

  module Writers; end
end
