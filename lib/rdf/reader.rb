module RDF
  class ReaderError < IOError; end

  class Reader

    include Enumerable

    @@subclasses = []
    @@file_extensions = {}
    @@content_types = {}
    @@content_encoding = {}

    def self.each(&block)
      !block_given? ? @@subclasses : @@subclasses.each { |klass| yield klass }
    end

    def self.content_types
      @@content_types
    end

    def self.file_extensions
      @@file_extensions
    end

    def self.open(filename, options = {}, &block)
      options[:format] ||= :ntriples # FIXME

      File.open(filename, 'rb') do |file|
        self.for(options[:format]).new(file, &block)
      end
    end

    def self.for(format)
      require "rdf/readers/#{format}"

      klass = case format.to_sym
        when :ntriples  then RDF::Readers::NTriples
        when :rdfxml    then RDF::Readers::RDFXML
      end
    end

    def initialize(stream = $stdin, &block)
      @stream = stream
      @nodes = {}
      block.call(self) if block_given?
    end

    def each_triple(&block)
      begin
        loop { block.call(*read_triple) }
      rescue EOFError => e
      end
    end

    protected

      def fail_subject
        raise RDF::ReaderError, "expected subject in #{@stream.inspect} line #{lineno}"
      end

      def fail_predicate
        raise RDF::ReaderError, "expected predicate in #{@stream.inspect} line #{lineno}"
      end

      def fail_object
        raise RDF::ReaderError, "expected object in #{@stream.inspect} line #{lineno}"
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
        @stream.lineno
      end

      def readline
        @line = @stream.readline.chomp
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

  module Readers; end
end
