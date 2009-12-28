module RDF
  ##
  # An RDF serialization format.
  class Format
    include Enumerable

    ##
    # Enumerates known RDF format classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
    def self.each(&block)
      !block_given? ? @@subclasses : @@subclasses.each { |klass| yield klass } # FIXME: Enumerator
    end

    ##
    # Returns the list of known MIME content types.
    #
    # @return [Hash{String => Array<Class>}]
    def self.content_types
      @@content_types
    end

    ##
    # Returns the list of known file extensions.
    #
    # @return [Hash{Symbol => String}]
    def self.file_extensions
      @@file_extensions
    end

    ##
    # @param  [Symbol] format
    # @return [Class]
    def self.for(format)
      klass = case format.to_s.downcase.to_sym
        when :ntriples then RDF::NTriples::Format
        else nil # FIXME
      end
    end

    ##
    # @yield  [format]
    # @yieldparam [Format]
    def initialize(options = {}, &block)
      @options = options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    protected

      @@subclasses       = [] # @private
      @@file_extensions  = {} # @private
      @@content_types    = {} # @private
      @@content_encoding = {} # @private

      def self.inherited(child) # @private
        @@subclasses << child
        super
      end

      def self.require(library)
        # TODO
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

      def self.reader(klass)
        # TODO
      end

      def self.writer(klass)
        # TODO
      end

  end
end
