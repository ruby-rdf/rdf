module RDF
  ##
  # An RDF parser.
  #
  # @example Iterating over known RDF reader classes
  #   RDF::Reader.each { |klass| puts klass.name }
  #
  # @example Obtaining an RDF reader class
  #   RDF::Reader.for(:ntriples)     #=> RDF::NTriples::Reader
  #   RDF::Reader.for("spec/data/test.nt")
  #   RDF::Reader.for(:file_name      => "spec/data/test.nt")
  #   RDF::Reader.for(:file_extension => "nt")
  #   RDF::Reader.for(:content_type   => "text/plain")
  #
  # @example Instantiating an RDF reader class
  #   RDF::Reader.for(:ntriples).new($stdin) { |reader| ... }
  #
  # @example Parsing RDF statements from a file
  #   RDF::Reader.open("spec/data/test.nt") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from a string
  #   data = StringIO.new(File.read("spec/data/test.nt"))
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
    include ::Enumerable

    ##
    # Enumerates known RDF reader classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
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
    # @param  [String] filename
    # @option options [Symbol] :format (:ntriples)
    # @yield  [reader]
    # @yieldparam [Reader]
    # @raise  [FormatError] if no reader available for the specified format
    def self.open(filename, options = {}, &block)
      if reader = self.for(options[:format] || filename)
        Kernel.open(filename, 'rb') do |file|
          reader.new(file, options, &block)
        end
      else
        raise FormatError.new("unknown RDF format: #{options[:format] || filename}")
      end
    end

    ##
    # @param  [IO, File, String] input
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      @options = options
      @nodes   = {}
      @input   = case input
        when String then StringIO.new(input)
        else input
      end
      block.call(self) if block_given?
    end

    ##
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Reader]
    def each(&block)
      each_statement(&block)
    end

    ##
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [Enumerator]
    def each_statement(&block)
      begin
        loop { block.call(read_statement) }
      rescue EOFError => e
      end
    end

    ##
    # @yield  [triple]
    # @yieldparam [Array(Value)]
    # @return [Enumerator]
    def each_triple(&block)
      begin
        loop { block.call(*read_triple) }
      rescue EOFError => e
      end
    end

    protected

      ##
      # @raise [NotImplementedError] unless implemented in subclass
      def read_statement
        Statement.new(*read_triple)
      end

      ##
      # @raise [NotImplementedError] unless implemented in subclass
      def read_triple
        raise NotImplementedError
      end

      ##
      # @raise [ReaderError]
      def fail_subject
        raise RDF::ReaderError, "expected subject in #{@input.inspect} line #{lineno}"
      end

      ##
      # @raise [ReaderError]
      def fail_predicate
        raise RDF::ReaderError, "expected predicate in #{@input.inspect} line #{lineno}"
      end

      ##
      # @raise [ReaderError]
      def fail_object
        raise RDF::ReaderError, "expected object in #{@input.inspect} line #{lineno}"
      end

    private

      @@subclasses = [] # @private

      def self.inherited(child) #:nodoc:
        @@subclasses << child
        super
      end

      def lineno
        @input.lineno
      end

      def readline
        @line = @input.readline.chomp
      end

      def strip!
        @line.strip!
      end

      def blank?
        @line.nil? || @line.empty?
      end

      def match(pattern)
        if @line =~ pattern
          result, @line = $1, $'.lstrip
          result || true
        end
      end

  end

  class ReaderError < IOError; end
end
