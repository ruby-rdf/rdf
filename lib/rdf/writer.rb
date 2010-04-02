module RDF
  ##
  # An RDF serializer.
  #
  # @example Iterating over known RDF writer classes
  #   RDF::Writer.each { |klass| puts klass.name }
  #
  # @example Obtaining an RDF writer class
  #   RDF::Writer.for(:ntriples)     #=> RDF::NTriples::Writer
  #   RDF::Writer.for("spec/data/output.nt")
  #   RDF::Writer.for(:file_name      => "spec/data/output.nt")
  #   RDF::Writer.for(:file_extension => "nt")
  #   RDF::Writer.for(:content_type   => "text/plain")
  #
  # @example Instantiating an RDF writer class
  #   RDF::Writer.for(:ntriples).new($stdout) { |writer| ... }
  #
  # @example Serializing RDF statements into a file
  #   RDF::Writer.open("spec/data/output.nt") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @example Serializing RDF statements into a string
  #   RDF::Writer.for(:ntriples).buffer do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @abstract
  # @see RDF::Format
  # @see RDF::Reader
  class Writer
    extend  ::Enumerable
    include ::Enumerable

    ##
    # Enumerates known RDF writer classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
    # @return [Enumerator]
    def self.each(&block)
      @@subclasses.each(&block)
    end

    ##
    # Finds an RDF writer class based on the given criteria.
    #
    # @overload for(format)
    #   Finds an RDF writer class based on a symbolic name.
    #
    #   @param  [Symbol] format
    #   @return [Class]
    #
    # @overload for(filename)
    #   Finds an RDF writer class based on a file name.
    #
    #   @param  [String] filename
    #   @return [Class]
    #
    # @overload for(options = {})
    #   Finds an RDF writer class based on various options.
    #
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [String, #to_s]   :file_name      (nil)
    #   @option options [Symbol, #to_sym] :file_extension (nil)
    #   @option options [String, #to_s]   :content_type   (nil)
    #   @return [Class]
    #
    # @return [Class]
    def self.for(options = {})
      if format = Format.for(options)
        format.writer
      end
    end

    ##
    # Retrieves the RDF serialization format class for this writer class.
    #
    # @return [Class]
    def self.format(klass = nil)
      if klass.nil?
        Format.each do |format|
          if format.writer == self
            return format
          end
        end
        nil # not found
      end
    end

    class << self
      alias_method :format_class, :format
    end

    def self.dump(data, io = nil, options = {})
      io = File.open(io, 'w') if io.is_a?(String)
      if io
        new(io) do |writer|
          data.each_statement do |statement|
            writer << statement
          end
          writer.flush
        end
      else
        buffer do |writer|
          data.each_statement do |statement|
            writer << statement
          end
        end
      end
    end

    def self.buffer(*args, &block)
      require 'stringio' unless defined?(StringIO)

      StringIO.open do |buffer|
        self.new(buffer, *args) { |writer| block.call(writer) }
        buffer.string
      end
    end

    def self.open(filename, options = {}, &block)
      File.open(filename, 'wb') do |file|
        self.for(options[:format] || filename).new(file, options, &block)
      end
    end

    ##
    # @param  [IO, File]               output
    # @param  [Hash{Symbol => Object}] options
    # @yield  [writer]
    # @yieldparam [RDF::Writer] writer
    def initialize(output = $stdout, options = {}, &block)
      @output, @options = output, options
      @nodes, @node_id = {}, 0

      if block_given?
        write_prologue
        block.call(self)
        write_epilogue
      end
    end

    ##
    # @return [void]
    # @abstract
    def write_prologue() end

    ##
    # @return [void]
    # @abstract
    def write_epilogue() end

    ##
    # @return [void]
    # @abstract
    def write_comment(text) end

    ##
    # @raise [ArgumentError]
    def <<(data)
      case data # TODO
        #when Graph
        #  write_graph(data)
        #when Resource
        #  #register!(resource) && write_node(resource)
        #  write_resource(data)
        when Statement
          write_statement(data)
        else
          if data.respond_to?(:to_a)
            write_triple(*data.to_a)
          else
            raise ArgumentError.new("expected RDF::Statement or RDF::Resource, got #{data.inspect}")
          end
      end
    end

    ##
    # @param  [Graph] graph
    # @return [void]
    def write_graph(graph)
      write_triples(*graph.triples)
    end

    ##
    # @return [void]
    def write_resource(subject) # FIXME
      edge_nodes = []
      subject.each do |predicate, objects|
        [objects].flatten.each do |object|
          edge_nodes << object if register!(object)
          write_triple subject, predicate, object
        end
      end
      edge_nodes.each { |node| write_resource node }
    end

    ##
    # @param  [Array<Statement>] statements
    # @return [void]
    def write_statements(*statements)
      statements.flatten.each { |stmt| write_statement(stmt) }
    end

    ##
    # @param  [Statement] statement
    # @return [void]
    def write_statement(statement)
      write_triple(*statement.to_a)
    end

    ##
    # @param  [Array<Array(Value)>] triples
    # @return [void]
    def write_triples(*triples)
      triples.each { |triple| write_triple(*triple) }
    end

    ##
    # @param  [Resource] subject
    # @param  [URI]      predicate
    # @param  [Value]    object
    # @return [void]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def write_triple(subject, predicate, object)
      raise NotImplementedError # override in subclasses
    end

    ##
    # @param  [Value] value
    # @return [String]
    def format_value(value, options = {})
      case value
        when String       then format_literal(value, options) # FIXME
        when RDF::Literal then format_literal(value, options)
        when RDF::URI     then format_uri(value, options)
        when RDF::Node    then format_node(value, options)
        else nil
      end
    end

    ##
    # @param  [URI]                    value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_uri(value, options = {})
      raise NotImplementedError # override in subclasses
    end

    ##
    # @param  [Node]                   value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_node(value, options = {})
      raise NotImplementedError # override in subclasses
    end

    ##
    # @param  [Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_literal(value, options = {})
      raise NotImplementedError # override in subclasses
    end

    ##
    # Flushes the underlying output buffer.
    #
    # @return [void]
    def flush
      @output.flush if @output.respond_to?(:flush)
    end

    alias_method :flush!, :flush

    protected

      def puts(*args)
        @output.puts(*args)
      end

      ##
      # @param  [Resource] uriref
      # @return [String]
      def uri_for(uriref)
        if uriref.respond_to?(:anonymous?) && uriref.anonymous?
          @nodes[uriref]
        elsif uriref.respond_to?(:to_uri)
          uriref.to_uri.to_s
        else
          uriref.to_s
        end
      end

      ##
      # @return [String]
      def node_id
        "_:n#{@node_id += 1}"
      end

      def register!(resource)
        if resource.kind_of?(RDF::Resource)
          unless @nodes[resource] # have we already seen it?
            @nodes[resource] = resource.uri || node_id
          end
        end
      end

      ##
      # @param  [String] string
      # @return [String]
      def escaped(string)
        string.gsub('\\', '\\\\').gsub("\t", '\\t').
          gsub("\n", '\\n').gsub("\r", '\\r').gsub('"', '\\"')
      end

      ##
      # @param  [String] string
      # @return [String]
      def quoted(string)
        "\"#{string}\""
      end

    private

      @@subclasses = [] # @private

      def self.inherited(child) # @private
        @@subclasses << child
        super
      end

  end

  class WriterError < IOError; end
end
