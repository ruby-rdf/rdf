module RDF
  ##
  # An RDF parser.
  #
  # @abstract
  class Reader
    autoload :NTriples, 'rdf/reader/ntriples' # @deprecated

    include Enumerable

    ##
    # Enumerates known RDF reader classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
    def self.each(&block)
      !block_given? ? @@subclasses : @@subclasses.each { |klass| yield klass }
    end

    ##
    # @param  [Symbol] format
    # @return [Class]
    def self.for(format)
      klass = case format.to_s.downcase.to_sym
        when :ntriples then RDF::NTriples::Reader
        else nil # FIXME
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
    # @yieldparam [Array(Value)]
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

      @@subclasses = [] # @private

      def self.inherited(child) #:nodoc:
        @@subclasses << child
        super
      end

      def self.format(klass)
        # TODO
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
