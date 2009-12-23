module RDF
  ##
  # An RDF parser.
  #
  # @abstract
  class Reader
    autoload :NTriples, 'rdf/reader/ntriples'

    include Enumerable

    @@subclasses       = []
    @@file_extensions  = {}
    @@content_types    = {}
    @@content_encoding = {}

    ##
    # Enumerates known RDF reader classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
    def self.each(&block)
      !block_given? ? @@subclasses : @@subclasses.each { |klass| yield klass }
    end

    ##
    # @return [{String => Symbol}]
    def self.content_types
      @@content_types
    end

    ##
    # @return [{Symbol => String}]
    def self.file_extensions
      @@file_extensions
    end

    ##
    # @param  [Symbol] format
    # @return [Class]
    def self.for(format)
      klass = case format.to_s.downcase.to_sym
        when :ntriples then RDF::Reader::NTriples
      end
    end

    ##
    # @param  [String] filename
    # @option options [Symbol] :format (:ntriples)
    # @yield  [reader]
    # @yieldparam [Reader]
    def self.open(filename, options = {}, &block)
      options[:format] ||= :ntriples # FIXME

      File.open(filename, 'rb') do |file|
        self.for(options[:format]).new(file, options, &block)
      end
    end

    ##
    # @param  [IO, String] input
    # @yield  [reader]
    # @yieldparam [Reader]
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
    # @return [Reader]
    def each_statement(&block)
      each_triple { |*triple| block.call(Statement.new(*triple)) }
      self
    end

    ##
    # @yield  [triple]
    # @yieldparam [Array]
    # @return [Reader]
    def each_triple(&block)
      begin
        loop { block.call(*read_triple) }
      rescue EOFError => e
      end
      self
    end

    protected

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
