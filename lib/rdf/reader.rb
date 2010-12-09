module RDF
  ##
  # The base class for RDF parsers.
  #
  # @example Loading an RDF reader implementation
  #   require 'rdf/ntriples'
  #
  # @example Iterating over known RDF reader classes
  #   RDF::Reader.each { |klass| puts klass.name }
  #
  # @example Obtaining an RDF reader class
  #   RDF::Reader.for(:ntriples)     #=> RDF::NTriples::Reader
  #   RDF::Reader.for("etc/doap.nt")
  #   RDF::Reader.for(:file_name      => "etc/doap.nt")
  #   RDF::Reader.for(:file_extension => "nt")
  #   RDF::Reader.for(:content_type   => "text/plain")
  #
  # @example Instantiating an RDF reader class
  #   RDF::Reader.for(:ntriples).new($stdin) { |reader| ... }
  #
  # @example Parsing RDF statements from a file
  #   RDF::Reader.open("etc/doap.nt") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from a string
  #   data = StringIO.new(File.read("etc/doap.nt"))
  #   RDF::Reader.for(:ntriples).new(data) do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @abstract
  # @see RDF::Format
  # @see RDF::Writer
  class Reader
    extend  ::Enumerable
    extend  RDF::Util::Aliasing::LateBound
    include RDF::Readable
    include RDF::Enumerable # @since 0.3.0

    ##
    # Enumerates known RDF reader classes.
    #
    # @yield  [klass]
    # @yieldparam [Class] klass
    # @return [Enumerator]
    def self.each(&block)
      @@subclasses.each(&block)
    end

    ##
    # Finds an RDF reader class based on the given criteria.
    #
    # @overload for(format)
    #   Finds an RDF reader class based on a symbolic name.
    #
    #   @param  [Symbol] format
    #   @return [Class]
    #
    # @overload for(filename)
    #   Finds an RDF reader class based on a file name.
    #
    #   @param  [String] filename
    #   @return [Class]
    #
    # @overload for(options = {})
    #   Finds an RDF reader class based on various options.
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
        format.reader
      end
    end

    ##
    # Retrieves the RDF serialization format class for this writer class.
    #
    # @return [Class]
    def self.format(klass = nil)
      if klass.nil?
        Format.each do |format|
          if format.reader == self
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
    # Parses input from the given file name or URL.
    #
    # @param  [String, #to_s] filename
    # @param  [Hash{Symbol => Object}] options
    #   any additional options (see {RDF::Reader#initialize})
    # @option options [Symbol] :format (:ntriples)
    # @yield  [reader]
    # @yieldparam  [RDF::Reader] reader
    # @yieldreturn [void] ignored
    # @raise  [RDF::FormatError] if no reader found for the specified format
    def self.open(filename, options = {}, &block)
      Util::File.open_file(filename, options) do |file|
        reader = self.for(options[:format]) if options[:format]
        content_type = file.content_type if file.respond_to?(:content_type)
        reader ||= self.for(options.merge(:file_name => filename, :content_type => content_type))
        if reader
          reader.new(file, options, &block)
        else
          raise FormatError, "unknown RDF format: #{options[:format] || {:file_name => filename, :content_type => content_type}.inspect}"
        end
      end
    end

    ##
    # Initializes the reader.
    #
    # @param  [IO, File, String] input
    #   the input stream to read
    # @param  [Hash{Symbol => Object}] options
    #   any additional options
    # @option options [Encoding] :encoding     (Encoding::UTF_8)
    #   the encoding of the input stream (Ruby 1.9+)
    # @option options [Boolean]  :validate     (false)
    #   whether to validate the parsed statements and values
    # @option options [Boolean]  :canonicalize (false)
    #   whether to canonicalize parsed literals
    # @option options [Boolean]  :intern       (true)
    #   whether to intern all parsed URIs
    # @option options [Hash]     :prefixes     (Hash.new)
    #   the prefix mappings to use (not supported by all readers)
    # @option options [#to_s]    :base_uri     (nil)
    #   the base URI to use when resolving relative URIs (not supported by
    #   all readers)
    # @yield  [reader] `self`
    # @yieldparam  [RDF::Reader] reader
    # @yieldreturn [void] ignored
    def initialize(input = $stdin, options = {}, &block)
      @options = options.dup
      @options[:validate]     ||= false
      @options[:canonicalize] ||= false
      @options[:intern]       ||= true
      @options[:prefixes]     ||= Hash.new

      @input = case input
        when String then StringIO.new(input)
        else input
      end

      if block_given?
        case block.arity
          when 0 then instance_eval(&block)
          else block.call(self)
        end
      end
    end

    ##
    # Any additional options for this reader.
    #
    # @return [Hash]
    # @since  0.3.0
    attr_reader :options

    ##
    # Returns the URI prefixes currently defined for this reader.
    #
    # @example
    #   reader.prefixes[:dc]  #=> RDF::URI('http://purl.org/dc/terms/')
    #
    # @return [Hash{Symbol => RDF::URI}]
    # @since  0.3.0
    def prefixes
      @options[:prefixes] ||= {}
    end

    ##
    # Defines the given URI prefixes for this reader.
    #
    # @example
    #   reader.prefixes = {
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
    # Defines the given named URI prefix for this reader.
    #
    # @example Defining a URI prefix
    #   reader.prefix :dc, RDF::URI('http://purl.org/dc/terms/')
    #
    # @example Returning a URI prefix
    #   reader.prefix(:dc)    #=> RDF::URI('http://purl.org/dc/terms/')
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
      name = name.respond_to?(:to_sym) ? name.to_sym : name.to_s.to_sym
      uri.nil? ? prefixes[name] : prefixes[name] = RDF::URI(uri)
    end
    alias_method :prefix!, :prefix

    ##
    # Iterates the given block for each RDF statement.
    #
    # If no block was given, returns an enumerator.
    #
    # Statements are yielded in the order that they are read from the input
    # stream.
    #
    # @overload each_statement
    #   @yield  [statement]
    #     each statement
    #   @yieldparam  [RDF::Statement] statement
    #   @yieldreturn [void] ignored
    #   @return [void]
    #
    # @overload each_statement
    #   @return [Enumerator]
    #
    # @return [void]
    # @see    RDF::Enumerable#each_statement
    def each_statement(&block)
      if block_given?
        begin
          loop { block.call(read_statement) }
        rescue EOFError => e
          rewind rescue nil
        end
      end
      enum_for(:each_statement)
    end
    alias_method :each, :each_statement

    ##
    # Iterates the given block for each RDF triple.
    #
    # If no block was given, returns an enumerator.
    #
    # Triples are yielded in the order that they are read from the input
    # stream.
    #
    # @overload each_triple
    #   @yield  [subject, predicate, object]
    #     each triple
    #   @yieldparam  [RDF::Resource] subject
    #   @yieldparam  [RDF::URI]      predicate
    #   @yieldparam  [RDF::Term]     object
    #   @yieldreturn [void] ignored
    #   @return [void]
    #
    # @overload each_triple
    #   @return [Enumerator]
    #
    # @return [void]
    # @see    RDF::Enumerable#each_triple
    def each_triple(&block)
      if block_given?
        begin
          loop { block.call(*read_triple) }
        rescue EOFError => e
          rewind rescue nil
        end
      end
      enum_for(:each_triple)
    end

    ##
    # Rewinds the input stream to the beginning of input.
    #
    # @return [void]
    # @since  0.2.3
    # @see    http://ruby-doc.org/core-1.9/classes/IO.html#M001692
    def rewind
      @input.rewind
    end
    alias_method :rewind!, :rewind

    ##
    # Closes the input stream, after which an `IOError` will be raised for
    # further read attempts.
    #
    # If the input stream is already closed, does nothing.
    #
    # @return [void]
    # @since  0.2.2
    # @see    http://ruby-doc.org/core-1.9/classes/IO.html#M001699
    def close
      @input.close unless @input.closed?
    end
    alias_method :close!, :close

  protected

    ##
    # Reads a statement from the input stream.
    #
    # @return [RDF::Statement] a statement
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def read_statement
      Statement.new(*read_triple)
    end

    ##
    # Reads a triple from the input stream.
    #
    # @return [Array(RDF::Term)] a triple
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def read_triple
      raise NotImplementedError, "#{self.class}#read_triple" # override in subclasses
    end

    ##
    # Raises an "expected subject" parsing error on the current line.
    #
    # @return [void]
    # @raise  [RDF::ReaderError]
    def fail_subject
      raise RDF::ReaderError, "expected subject in #{@input.inspect} line #{lineno}"
    end

    ##
    # Raises an "expected predicate" parsing error on the current line.
    #
    # @return [void]
    # @raise  [RDF::ReaderError]
    def fail_predicate
      raise RDF::ReaderError, "expected predicate in #{@input.inspect} line #{lineno}"
    end

    ##
    # Raises an "expected object" parsing error on the current line.
    #
    # @return [void]
    # @raise  [RDF::ReaderError]
    def fail_object
      raise RDF::ReaderError, "expected object in #{@input.inspect} line #{lineno}"
    end

    ##
    # Returns the encoding of the input stream.
    #
    # _Note: this method requires Ruby 1.9 or newer._
    #
    # @return [Encoding]
    def encoding
      @options[:encoding] ||= Encoding::UTF_8
    end

    ##
    # Returns `true` if parsed statements and values should be validated.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def validate?
      @options[:validate]
    end

    ##
    # Returns `true` if parsed values should be canonicalized.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def canonicalize?
      @options[:canonicalize]
    end

    ##
    # Returns `true` if parsed URIs should be interned.
    #
    # @return [Boolean] `true` or `false`
    # @since  0.3.0
    def intern?
      @options[:intern]
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

    ##
    # @return [Integer]
    def lineno
      @input.lineno
    end

    ##
    # @return [String]
    def readline
      @line = @input.readline
      @line.chomp!
      @line.force_encoding(encoding) if @line.respond_to?(:force_encoding) # for Ruby 1.9+
      @line
    end

    ##
    # @return [void]
    def strip!
      @line.strip!
    end

    ##
    # @return [Boolean]
    def blank?
      @line.nil? || @line.empty?
    end

    ##
    # @param  [Regexp] pattern
    # @return [Object]
    def match(pattern)
      if @line =~ pattern
        result, @line = $1, $'.lstrip
        result || true
      end
    end
  end # Reader

  ##
  # The base class for RDF parsing errors.
  class ReaderError < IOError
  end # ReaderError
end # RDF
