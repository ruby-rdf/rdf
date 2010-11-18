module RDF
  ##
  # The base class for RDF serialization formats.
  #
  # @example Loading an RDF serialization format implementation
  #   require 'rdf/ntriples'
  #
  # @example Iterating over known RDF serialization formats
  #   RDF::Format.each { |klass| puts klass.name }
  #
  # @example Getting a serialization format class
  #   RDF::Format.for(:ntriples)     #=> RDF::NTriples::Format
  #   RDF::Format.for("etc/doap.nt")
  #   RDF::Format.for(:file_name => "etc/doap.nt")
  #   RDF::Format.for(:file_extension => "nt")
  #   RDF::Format.for(:content_type => "text/plain")
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
  #     writer RDF::NTriples::Writer
  #   end
  #
  # @example Instantiating an RDF reader or writer class (1)
  #   RDF::Format.for(:ntriples).reader.new($stdin)  { |reader| ... }
  #   RDF::Format.for(:ntriples).writer.new($stdout) { |writer| ... }
  #
  # @example Instantiating an RDF reader or writer class (2)
  #   RDF::Reader.for(:ntriples).new($stdin)  { |reader| ... }
  #   RDF::Writer.for(:ntriples).new($stdout) { |writer| ... }
  #
  # @abstract
  # @see RDF::Reader
  # @see RDF::Writer
  # @see http://en.wikipedia.org/wiki/Resource_Description_Framework#Serialization_formats
  class Format
    extend ::Enumerable

    ##
    # Enumerates known RDF serialization format classes.
    #
    # @yield  [klass]
    # @yieldparam [Class]
    # @return [Enumerator]
    def self.each(&block)
      @@subclasses.each(&block)
    end

    ##
    # Finds an RDF serialization format class based on the given criteria.
    #
    # @overload for(format)
    #   Finds an RDF serialization format class based on a symbolic name.
    #
    #   @param  [Symbol] format
    #   @return [Class]
    #
    # @overload for(filename)
    #   Finds an RDF serialization format class based on a file name.
    #
    #   @param  [String] filename
    #   @return [Class]
    #
    # @overload for(options = {})
    #   Finds an RDF serialization format class based on various options.
    #
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [String, #to_s]   :file_name      (nil)
    #   @option options [Symbol, #to_sym] :file_extension (nil)
    #   @option options [String, #to_s]   :content_type   (nil)
    #   @return [Class]
    #
    # @return [Class]
    def self.for(options = {})
      case options
        when String
          # Find a format based on the file name
          self.for(:file_name => options)

        when Hash
          case
            # Find a format based on the MIME content type
            when mime_type = options[:content_type]
              if content_types.has_key?(mime_type = mime_type.to_s)
                content_types[mime_type].first
              end
            # Find a format based on the file name
            when file_name = options[:file_name]
              self.for(:file_extension => File.extname(file_name.to_s)[1..-1])
            # Find a format based on the file extension
            when file_ext  = options[:file_extension]
              if file_extensions.has_key?(file_ext = file_ext.to_sym)
                self.for(:content_type => file_extensions[file_ext])
              end
          end

        when Symbol
          case format = options
            # Special case, since we want this to work despite autoloading
            when :ntriples
              RDF::NTriples::Format
            # For anything else, find a match based on the full class name
            else
              format = format.to_s.downcase
              @@subclasses.each do |klass|
                if klass.name.to_s.split('::').map(&:downcase).include?(format)
                  return klass
                end
              end
              nil # not found
          end
      end
    end

    ##
    # Returns MIME content types for known RDF serialization formats.
    #
    # @return [Hash{String => Array<Class>}]
    def self.content_types
      @@content_types
    end

    ##
    # Returns file extensions for known RDF serialization formats.
    #
    # @return [Hash{Symbol => String}]
    def self.file_extensions
      @@file_extensions
    end

    ##
    # Retrieves or defines the reader class for this RDF serialization
    # format.
    #
    # @overload reader(klass)
    #   Defines the reader class for this RDF serialization format.
    #   
    #   The class should be a subclass of {RDF::Reader}, or implement the
    #   same interface.
    #   
    #   @param  [Class] klass
    #   @return [void]
    #
    # @overload reader
    #   Defines the reader class for this RDF serialization format.
    #   
    #   The block should return a subclass of {RDF::Reader}, or a class that
    #   implements the same interface. The block won't be invoked until the
    #   reader class is first needed.
    #   
    #   @yield
    #   @yieldreturn [Class] klass
    #   @return [void]
    #
    # @overload reader
    #   Retrieves the reader class for this RDF serialization format.
    #   
    #   @return [Class]
    #
    # @return [void]
    def self.reader(klass = nil, &block)
      case
        when klass
          @@readers[self] = klass
        when block_given?
          @@readers[self] = block
        else
          klass = @@readers[self]
          klass = @@readers[self] = klass.call if klass.is_a?(Proc)
          klass
      end
    end

    ##
    # Retrieves or defines the writer class for this RDF serialization
    # format.
    #
    # @overload writer(klass)
    #   Defines the writer class for this RDF serialization format.
    #   
    #   The class should be a subclass of {RDF::Writer}, or implement the
    #   same interface.
    #   
    #   @param  [Class] klass
    #   @return [void]
    #
    # @overload writer
    #   Defines the writer class for this RDF serialization format.
    #   
    #   The block should return a subclass of {RDF::Writer}, or a class that
    #   implements the same interface. The block won't be invoked until the
    #   writer class is first needed.
    #   
    #   @yield
    #   @yieldreturn [Class] klass
    #   @return [void]
    #
    # @overload writer
    #   Retrieves the writer class for this RDF serialization format.
    #   
    #   @return [Class]
    #
    # @return [void]
    def self.writer(klass = nil, &block)
      case
        when klass
          @@writers[self] = klass
        when block_given?
          @@writers[self] = block
        else
          klass = @@writers[self]
          klass = @@writers[self] = klass.call if klass.is_a?(Proc)
          klass
      end
    end

    class << self
      alias_method :reader_class, :reader
      alias_method :writer_class, :writer
    end

    ##
    # Retrieves or defines MIME content types for this RDF serialization format.
    #
    # @overload content_type(type, options)
    #   Retrieves or defines the MIME content type for this RDF serialization format.
    #
    #   Optionally also defines alias MIME content types for this RDF serialization format.
    #
    #   Optionally also defines a file extension, or a list of file
    #   extensions, that should be mapped to the given MIME type and handled
    #   by this class.
    #
    #   @param  [String]                 type
    #   @param  [Hash{Symbol => Object}] options
    #   @option options [String]         :alias   (nil)
    #   @option options [Array<String>]  :aliases (nil)
    #   @option options [Symbol]         :extension  (nil)
    #   @option options [Array<Symbol>]  :extensions (nil)
    #   @return [void]
    #
    # @overload content_type
    #   Retrieves the MIME content types for this RDF serialization format.
    #
    #   The return is an array where the first element is the cannonical
    #   MIME type for the format and following elements are alias MIME types.
    #
    #   @return [Array<String>]
    def self.content_type(type = nil, options = {})
      if type.nil?
        [@@content_type[self], @@content_types.map {
          |ct, cl| (cl.include?(self) && ct != @@content_type[self]) ?  ct : nil }].flatten.compact
      else
        @@content_type[self] = type
        (@@content_types[type] ||= []) << self

        if extensions = (options[:extension] || options[:extensions])
          extensions = [extensions].flatten.map(&:to_sym)
          extensions.each { |ext| @@file_extensions[ext] = type }
        end
        if aliases = (options[:alias] || options[:aliases])
          aliases = [aliases].flatten.each { |a| (@@content_types[a] ||= []) << self }
        end
      end
    end

  protected

    ##
    # Defines a required Ruby library for this RDF serialization format.
    #
    # The given library will be required lazily, i.e. only when it is
    # actually first needed, such as when instantiating a reader or parser
    # instance for this format.
    #
    # @param  [String, #to_s] library
    # @return [void]
    def self.require(library)
      (@@requires[self] ||= []) << library.to_s
    end

    ##
    # Defines the content encoding for this RDF serialization format.
    #
    # @param  [#to_sym] encoding
    # @return [void]
    def self.content_encoding(encoding)
      @@content_encoding[self] = encoding.to_sym
    end

  private

    private_class_method :new

    @@requires         = {} # @private
    @@file_extensions  = {} # @private
    @@content_type     = {} # @private
    @@content_types    = {} # @private
    @@content_encoding = {} # @private
    @@readers          = {} # @private
    @@writers          = {} # @private
    @@subclasses       = [] # @private

    ##
    # @private
    # @return [void]
    def self.inherited(child)
      @@subclasses << child
      super
    end
  end # Format

  ##
  # The base class for RDF serialization format errors.
  class FormatError < IOError
  end # FormatError
end # RDF
