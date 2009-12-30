module RDF
  ##
  # An RDF serialization format.
  #
  # @example Iterating over known RDF serialization formats
  #   RDF::Format.each { |klass| puts klass.name }
  #
  # @example Getting a serialization format class and instance
  #   RDF::Format.for(:ntriples)     #=> RDF::NTriples::Format
  #   RDF::Format.for(:ntriples).new #=> #<RDF::NTriples::Format:0x101792820>
  #
  # @example Obtaining serialization format MIME types
  #   RDF::Format.content_types      #=> {"text/plain" => [RDF::NTriples::Format]}
  #
  # @example Obtaining serialization format file extension mappings
  #   RDF::Format.file_extensions    #=> {:nt => "text/plain"}
  #
  # @example Defining a new RDF serialization format class
  #   class RDF::NTriples::Format < RDF::Format
  #     content_type     'text/plain', :extension => :nt
  #     content_encoding 'ascii'
  #     
  #     reader RDF::NTriples::Reader
  #     writer RDF::NTriples::Format
  #   end
  #
  # @see http://en.wikipedia.org/wiki/Resource_Description_Framework#Serialization_formats
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
