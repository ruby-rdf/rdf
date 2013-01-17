module RDF
  ##
  # The base class for RDF serializers.
  #
  # @example Loading an RDF writer implementation
  #   require 'rdf/ntriples'
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
    extend  RDF::Util::Aliasing::LateBound
    include RDF::Writable

    ##
    # Enumerates known RDF writer classes.
    #
    # @yield  [klass]
    # @yieldparam  [Class] klass
    # @yieldreturn [void] ignored
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
      options = options.merge(:has_writer => true) if options.is_a?(Hash)
      if format = self.format || Format.for(options)
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

    ##
    # @param  [RDF::Enumerable, #each] data
    #   the graph or repository to dump
    # @param  [IO, File] io
    #   the output stream or file to write to
    # @param  [Hash{Symbol => Object}] options
    #   passed to {RDF::Writer#initialize} or {RDF::Writer.buffer}
    # @return [void]
    def self.dump(data, io = nil, options = {})
      io = File.open(io, 'w') if io.is_a?(String)
      method = data.respond_to?(:each_statement) ? :each_statement : :each
      if io
        new(io, options) do |writer|
          data.send(method) do |statement|
            writer << statement
          end
          writer.flush
        end
      else
        buffer(options) do |writer|
          data.send(method) do |statement|
            writer << statement
          end
        end
      end
    end

    ##
    # Buffers output into a string buffer.
    #
    # @yield  [writer]
    # @yieldparam  [RDF::Writer] writer
    # @yieldreturn [void]
    # @return [String]
    # @raise [ArgumentError] if no block is provided
    def self.buffer(*args, &block)
      raise ArgumentError, "block expected" unless block_given?

      StringIO.open do |buffer|
        self.new(buffer, *args) { |writer| block.call(writer) }
        buffer.string
      end
    end

    ##
    # Writes output to the given `filename`.
    #
    # @param  [String, #to_s] filename
    # @param  [Hash{Symbol => Object}] options
    #   any additional options (see {RDF::Writer#initialize} and {RDF::Format.for})
    # @option options [Symbol] :format (nil)
    # @return [RDF::Writer]
    def self.open(filename, options = {}, &block)
      File.open(filename, 'wb') do |file|
        format_options = options.dup
        format_options[:file_name] ||= filename
        self.for(options[:format] || format_options).new(file, options, &block)
      end
    end

    ##
    # Returns a symbol appropriate to use with RDF::Writer.for()
    # @return [Symbol]
    def self.to_sym
      elements = self.to_s.split("::")
      sym = elements.pop
      sym = elements.pop if sym == 'Writer'
      sym.downcase.to_s.to_sym
    end

    ##
    # Returns a symbol appropriate to use with RDF::Writer.for()
    # @return [Symbol]
    def to_sym
      self.class.to_sym
    end
    
    ##
    # Initializes the writer.
    #
    # @param  [IO, File] output
    #   the output stream
    # @param  [Hash{Symbol => Object}] options
    #   any additional options
    # @option options [Encoding, String, Symbol] :encoding
    #   the encoding to use on the output stream (Ruby 1.9+).
    #   Defaults to the format associated with `content_encoding`.
    # @option options [Boolean]  :canonicalize (false)
    #   whether to canonicalize literals when serializing
    # @option options [Hash]     :prefixes     (Hash.new)
    #   the prefix mappings to use (not supported by all writers)
    # @option options [#to_s]    :base_uri     (nil)
    #   the base URI to use when constructing relative URIs (not supported
    #   by all writers)
    # @yield  [writer] `self`
    # @yieldparam  [RDF::Writer] writer
    # @yieldreturn [void]
    def initialize(output = $stdout, options = {}, &block)
      @output, @options = output, options.dup
      @nodes, @node_id  = {}, 0

      if block_given?
        write_prologue
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
        write_epilogue
      end
    end

    ##
    # Any additional options for this writer.
    #
    # @return [Hash]
    # @since  0.2.2
    attr_reader :options

    ##
    # Returns the base URI used for this writer.
    #
    # @example
    #   reader.prefixes[:dc]  #=> RDF::URI('http://purl.org/dc/terms/')
    #
    # @return [Hash{Symbol => RDF::URI}]
    # @since  0.3.4
    def base_uri
      @options[:base_uri]
    end

    ##
    # Returns the URI prefixes currently defined for this writer.
    #
    # @example
    #   writer.prefixes[:dc]  #=> RDF::URI('http://purl.org/dc/terms/')
    #
    # @return [Hash{Symbol => RDF::URI}]
    # @since  0.2.2
    def prefixes
      @options[:prefixes] ||= {}
    end

    ##
    # Defines the given URI prefixes for this writer.
    #
    # @example
    #   writer.prefixes = {
    #     :dc => RDF::URI('http://purl.org/dc/terms/'),
    #   }
    #
    # @param  [Hash{Symbol => RDF::URI}] prefixes
    # @return [Hash{Symbol => RDF::URI}]
    # @since  0.3.0
    def prefixes=(prefixes)
      @options[:prefixes] = prefixes
    end

    ##
    # Defines the given named URI prefix for this writer.
    #
    # @example Defining a URI prefix
    #   writer.prefix :dc, RDF::URI('http://purl.org/dc/terms/')
    #
    # @example Returning a URI prefix
    #   writer.prefix(:dc)    #=> RDF::URI('http://purl.org/dc/terms/')
    #
    # @overload prefix(name, uri)
    #   @param  [Symbol, #to_s]   name
    #   @param  [RDF::URI, #to_s] uri
    #
    # @overload prefix(name)
    #   @param  [Symbol, #to_s]   name
    #
    # @return [RDF::URI]
    def prefix(name, uri = nil)
      name = name.to_s.empty? ? nil : (name.respond_to?(:to_sym) ? name.to_sym : name.to_s.to_sym)
      uri.nil? ? prefixes[name] : prefixes[name] = uri
    end
    alias_method :prefix!, :prefix

    ##
    # Returns the encoding of the output stream.
    #
    # _Note: this method requires Ruby 1.9 or newer._
    #
    # @return [Encoding]
    def encoding
      return nil unless "".respond_to?(:force_encoding)
      case @options[:encoding]
      when String, Symbol
        Encoding.find(@options[:encoding].to_s)
      when Encoding
        @options[:encoding]
      else
        @options[:encoding] ||= Encoding.find(self.class.format.content_encoding.to_s)
      end
    end

    ##
    # Flushes the underlying output buffer.
    #
    # @return [void] `self`
    def flush
      @output.flush if @output.respond_to?(:flush)
      self
    end
    alias_method :flush!, :flush

    ##
    # @return [void] `self`
    # @abstract
    def write_prologue
      self
    end

    ##
    # @return [void] `self`
    # @abstract
    def write_epilogue
      self
    end

    ##
    # @param  [String] text
    # @return [void] `self`
    # @abstract
    def write_comment(text)
      self
    end

    ##
    # @param  [RDF::Graph] graph
    # @return [void] `self`
    # @deprecated replace by `RDF::Writable#insert_graph`
    def write_graph(graph)
      graph.each_triple { |*triple| write_triple(*triple) }
      self
    end

    ##
    # @param  [Array<RDF::Statement>] statements
    # @return [void] `self`
    # @deprecated replace by `RDF::Writable#insert_statements`
    def write_statements(*statements)
      statements.flatten.each { |statement| write_statement(statement) }
      self
    end

    ##
    # @param  [RDF::Statement] statement
    # @return [void] `self`
    def write_statement(statement)
      write_triple(*statement.to_triple)
      self
    end
    alias_method :insert_statement, :write_statement # support the RDF::Writable interface

    ##
    # @param  [Array<Array(RDF::Resource, RDF::URI, RDF::Term)>] triples
    # @return [void] `self`
    def write_triples(*triples)
      triples.each { |triple| write_triple(*triple) }
      self
    end

    ##
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Term]     object
    # @return [void] `self`
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def write_triple(subject, predicate, object)
      raise NotImplementedError.new("#{self.class}#write_triple") # override in subclasses
    end

    ##
    # @param  [RDF::Term] term
    # @return [String]
    # @since  0.3.0
    def format_term(term, options = {})
      case term
        when String       then format_literal(RDF::Literal(term, options), options)
        when RDF::List    then format_list(term, options)
        when RDF::Literal then format_literal(term, options)
        when RDF::URI     then format_uri(term, options)
        when RDF::Node    then format_node(term, options)
        else nil
      end
    end
    alias_method :format_value, :format_term # @deprecated

    ##
    # @param  [RDF::Node] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_node(value, options = {})
      raise NotImplementedError.new("#{self.class}#format_node") # override in subclasses
    end

    ##
    # @param  [RDF::URI] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_uri(value, options = {})
      raise NotImplementedError.new("#{self.class}#format_uri") # override in subclasses
    end

    ##
    # @param  [RDF::Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def format_literal(value, options = {})
      raise NotImplementedError.new("#{self.class}#format_literal") # override in subclasses
    end

    ##
    # @param  [RDF::List] value
    # @param  [Hash{Symbol => Object}] options
    # @return [String]
    # @abstract
    # @since  0.2.3
    def format_list(value, options = {})
      format_term(value.subject, options)
    end

  protected

    ##
    # @return [void]
    def puts(*args)
      @output.puts(*args)
    end

    ##
    # @param  [RDF::Resource] uriref
    # @return [String]
    def uri_for(uriref)
      case
        when uriref.is_a?(RDF::Node)
          @nodes[uriref]
        when uriref.respond_to?(:to_uri)
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

    ##
    # @private
    # @return [void]
    def self.inherited(child)
      @@subclasses << child
      super
    end
  end # Writer

  ##
  # The base class for RDF serialization errors.
  class WriterError < IOError
  end # WriterError
end # RDF
