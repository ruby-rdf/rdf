module RDF
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

    def initialize(stream = $stdin, &block)
      @stream = stream
      block.call(self) if block_given?
    end

    def each(&block)
      yield read_statement
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

  end

  module Readers; end
end
