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
    # If the reader class has a defined format, use that.
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
    #   @option options [String]          :sample (nil)
    #     A sample of input used for performing format detection.
    #     If we find no formats, or we find more than one, and we have a sample, we can
    #     perform format detection to find a specific format to use, in which case
    #     we pick the first one we find
    #   @return [Class]
    #   @yieldreturn [String] another way to provide a sample, allows lazy for retrieving the sample.
    #
    # @return [Class]
    def self.for(options = {}, &block)
      options = options.merge(:has_reader => true) if options.is_a?(Hash)
      if format = self.format || Format.for(options, &block)
        format.reader
      end
    end

    ##
    # Retrieves the RDF serialization format class for this reader class.
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
    # @note A reader returned via this method may not be readable depending on the processing model of the specific reader, as the file is only open during the scope of `open`. The reader is intended to be accessed through a block.
    #
    # @example Parsing RDF statements from a file
    #   RDF::Reader.open("etc/doap.nt") do |reader|
    #     reader.each_statement do |statement|
    #       puts statement.inspect
    #     end
    #   end
    #
    # @param  [String, #to_s] filename
    # @param  [Hash{Symbol => Object}] options
    #   any additional options (see {RDF::Util::File.open_file}, {RDF::Reader#initialize} and {RDF::Format.for})
    # @option options [Symbol] :format (:ntriples)
    # @yield  [reader]
    # @yieldparam  [RDF::Reader] reader
    # @yieldreturn [void] ignored
    # @raise  [RDF::FormatError] if no reader found for the specified format
    def self.open(filename, options = {}, &block)
      Util::File.open_file(filename, options) do |file|
        format_options = options.dup
        format_options[:content_type] ||= file.content_type if file.respond_to?(:content_type)
        format_options[:file_name] ||= filename
        options[:encoding] ||= file.encoding if file.respond_to?(:encoding)
        reader = self.for(format_options[:format] || format_options) do
          # Return a sample from the input file
          sample = file.read(1000)
          file.rewind
          sample
        end
        if reader
          reader.new(file, options, &block)
        else
          raise FormatError, "unknown RDF format: #{format_options.inspect}\nThis may be resolved with a require of the 'linkeddata' gem."
        end
      end
    end

    ##
    # Returns a symbol appropriate to use with RDF::Reader.for()
    # @return [Symbol]
    def self.to_sym
      self.format.to_sym
    end

    ##
    # Returns a symbol appropriate to use with RDF::Reader.for()
    # @return [Symbol]
    def to_sym
      self.class.to_sym
    end
    
    ##
    # Initializes the reader.
    #
    # @param  [IO, File, String] input
    #   the input stream to read
    # @param  [Hash{Symbol => Object}] options
    #   any additional options
    # @option options [Encoding] :encoding     (Encoding::UTF_8)
    #   the encoding of the input stream
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
      @options[:base_uri]     ||= input.base_uri if input.respond_to?(:base_uri)

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
    # Returns the base URI determined by this reader.
    #
    # @example
    #   reader.prefixes[:dc]  #=> RDF::URI('http://purl.org/dc/terms/')
    #
    # @return [RDF::URI]
    # @since  0.3.0
    def base_uri
      RDF::URI(@options[:base_uri]) if @options[:base_uri]
    end

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
      name = name.to_s.empty? ? nil : (name.respond_to?(:to_sym) ? name.to_sym : name.to_s.to_sym)
      uri.nil? ? prefixes[name] : prefixes[name] = uri
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

    ##
    # Current line number being processed. For formats that can associate generated {Statement} with a particular line number from input, this value reflects that line number.
    # @return [Integer]
    def lineno
      @input.lineno
    end

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
      raise RDF::ReaderError.new("ERROR [line #{lineno}] Expected subject (found: #{current_line.inspect})",
                                 lineno: lineno)
    end

    ##
    # Raises an "expected predicate" parsing error on the current line.
    #
    # @return [void]
    # @raise  [RDF::ReaderError]
    def fail_predicate
      raise RDF::ReaderError.new("ERROR [line #{lineno}] Expected predicate (found: #{current_line.inspect})",
                                 lineno: lineno)
    end

    ##
    # Raises an "expected object" parsing error on the current line.
    #
    # @return [void]
    # @raise  [RDF::ReaderError]
    def fail_object
      raise RDF::ReaderError.new("ERROR [line #{lineno}] Expected object (found: #{current_line.inspect})",
                                 lineno: lineno)
    end

  public
    ##
    # Returns the encoding of the input stream.
    #
    # @return [Encoding]
    def encoding
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
    # @private
    # @return [String] The most recently read line of the input
    def current_line
      @line
    end

    ##
    # @return [String]
    def readline
      @line = @line_rest || @input.readline
      @line, @line_rest = @line.split("\r", 2)
      @line = @line.to_s.chomp
      begin
        @line.encode!(encoding)
      rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError, Encoding::ConverterNotFoundError
        # It is likely the persisted line was not encoded on initial write
        # (i.e. persisted via RDF <= 1.0.9 and read via RDF >= 1.0.10)
        #
        # Encoding::UndefinedConversionError is raised by MRI.
        # Encoding::InvalidByteSequenceError is raised by jruby >= 1.7.5
        # Encoding::ConverterNotFoundError is raised by jruby < 1.7.5
        @line = RDF::NTriples::Reader.unescape(@line).encode(encoding)
      end
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
    ##
    # The invalid token which triggered the error.
    #
    # @return [String]
    attr_reader :token

    ##
    # The line number where the error occurred.
    #
    # @return [Integer]
    attr_reader :lineno

    ##
    # Initializes a new lexer error instance.
    #
    # @param  [String, #to_s]          message
    # @param  [Hash{Symbol => Object}] options
    # @option options [String]         :token  (nil)
    # @option options [Integer]        :lineno (nil)
    def initialize(message, options = {})
      @token      = options[:token]
      @lineno     = options[:lineno] || (@token.lineno if @token.respond_to?(:lineno))
      super(message.to_s)
    end
  end # ReaderError
end # RDF
