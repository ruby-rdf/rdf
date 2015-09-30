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
  #   RDF::Format.for(:content_type => "application/n-triples")
  #
  # @example Obtaining serialization format MIME types
  #   RDF::Format.content_types      #=> {"application/n-triples" => [RDF::NTriples::Format]}
  #
  # @example Obtaining serialization format file extension mappings
  #   RDF::Format.file_extensions    #=> {:nt => [RDF::NTriples::Format]}
  #
  # @example Defining a new RDF serialization format class
  #   class RDF::NTriples::Format < RDF::Format
  #     content_type     'application/n-triples', :extension => :nt
  #     content_encoding 'utf-8'
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
    #     Note that content_type will be taken from a URL opened using {RDF::Util::File.open_file}.
    #   @option options [Boolean]   :has_reader   (false)
    #     Only return a format having a reader.
    #   @option options [Boolean]   :has_writer   (false)
    #     Only return a format having a writer.
    #   @option options [String]          :sample (nil)
    #     A sample of input used for performing format detection.
    #     If we find no formats, or we find more than one, and we have a sample, we can
    #     perform format detection to find a specific format to use, in which case
    #     we pick the first one we find
    #   @return [Class]
    #   @yieldreturn [String] another way to provide a sample, allows lazy for retrieving the sample.
    #
    # @return [Class]
    def self.for(options = {})
      format = case options
        when String
          # Find a format based on the file name
          self.for(:file_name => options) { yield if block_given? }

        when Hash
          case
            # Find a format based on the MIME content type:
            when mime_type = options[:content_type]
              # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17
              # @see http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7
              mime_type = mime_type.to_s
              mime_type = mime_type.split(';').first # remove any media type parameters

              # Ignore text/plain, a historical encoding for N-Triples, which is
              # problematic in format detection, as many web servers will serve
              # content by default text/plain.
              content_types[mime_type] unless mime_type == 'text/plain' && (options[:sample] || block_given?)
            # Find a format based on the file name:
            when file_name = options[:file_name]
              self.for(:file_extension => File.extname(file_name.to_s)[1..-1]) { yield if block_given? }
            # Find a format based on the file extension:
            when file_ext  = options[:file_extension]
              file_extensions[file_ext.to_sym]
          end

        when Symbol
          # Try to find a match based on the full class name
          # We want this to work even if autoloading fails
          format = options
          @@subclasses.detect { |klass| klass.to_sym == format } ||
          case format
          when :ntriples
            RDF::NTriples::Format
          when :nquads
            RDF::NQuads::Format
          end
      end

      if format.is_a?(Array)
        format = format.select {|f| f.reader} if options[:has_reader]
        format = format.select {|f| f.writer} if options[:has_writer]
        
        return format.first if format.uniq.length == 1
      elsif !format.nil?
        return format
      end

      # If we have a sample, use that for format detection
      if sample = (options[:sample] if options.is_a?(Hash)) || (yield if block_given?)
        sample = sample.dup.to_s
        sample.force_encoding(Encoding::ASCII_8BIT) if sample.respond_to?(:force_encoding)
        # Given a sample, perform format detection across the appropriate formats, choosing
        # the first that matches
        format ||= @@subclasses

        # Return first format that has a positive detection
        format.detect {|f| f.detect(sample)} || format.first
      elsif format.is_a?(Array)
        # Otherwise, just return the first matching format
        format.first
      else
        nil
      end
    end

    ##
    # Returns MIME content types for known RDF serialization formats.
    #
    # @example retrieving a list of supported Mime types
    #
    #     RDF::Format.content_types.keys
    #
    # @return [Hash{String => Array<Class>}]
    def self.content_types
      @@content_types
    end

    ##
    # Returns file extensions for known RDF serialization formats.
    #
    # @example retrieving a list of supported file extensions
    #
    #     RDF::Format.file_extensions.keys
    #
    # @return [Hash{Symbol => Array<Class>}]
    def self.file_extensions
      @@file_extensions
    end

    ##
    # Returns the set of format symbols for available RDF::Reader subclasses.
    #
    # @example
    #
    #     symbols = RDF::Format.reader_symbols
    #     format = RDF::Format.for(symbols.first)
    #
    # @return [Array<Symbol>]
    def self.reader_symbols
      @@readers.keys.compact.map(&:to_sym).uniq
    end

    ##
    # Returns the set of content types for available RDF::Reader subclasses.
    #
    # @example
    #
    #     content_types = RDF::Format.reader_types
    #     format = RDF::Format.for(:content_type => content_types.first)
    #
    # @return [Array<String>]
    def self.reader_types
      reader_symbols.flat_map {|s| RDF::Format.for(s).content_type}.uniq
    end

    ##
    # Returns the set of format symbols for available RDF::Writer subclasses.
    #
    # @example
    #
    #     symbols = RDF::Format.writer_symbols
    #     format = RDF::Format.for(symbols.first)
    #
    # @return [Array<Symbol>]
    def self.writer_symbols
      @@writers.keys.compact.map(&:to_sym).uniq
    end

    ##
    # Returns the set of content types for available RDF::Writer subclasses.
    #
    # @example
    #
    #     content_types = RDF::Format.writer_types
    #     format = RDF::Format.for(:content_type => content_types.first)
    #
    # @return [Array<String>]
    def self.writer_types
      writer_symbols.flat_map {|s| RDF::Format.for(s).content_type}.uniq
    end

    ##
    # Returns a symbol appropriate to use with RDF::Format.for()
    # @return [Symbol]
    def self.to_sym
      elements = self.to_s.split("::")
      sym = elements.pop
      sym = elements.pop if sym == 'Format'
      sym.downcase.to_s.to_sym if sym.is_a?(String)
    end

    ##
    # Returns a human-readable name for the format.
    # Subclasses should override this to use something
    # difererent than the Class name.
    #
    # @example
    #
    #     RDF::NTriples::Format.name => "N-Triples"
    #
    # @return [Symbol]
    def self.name
      elements = self.to_s.split("::")
      name = elements.pop
      name = elements.pop if name == 'Format'
      name.to_s
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


    ##
    # Use a text sample to detect the format of an input file. Sub-classes implement
    # a matcher sufficient to detect probably format matches, including disambiguating
    # between other similar formats.
    #
    # Used to determine format class from loaded formats by {RDF::Format.for} when a
    # match cannot be unambigiously found otherwise.
    #
    # @example
    #     RDF::NTriples::Format.detect("<a> <b> <c> .") #=> true
    #
    # @param [String] sample Beginning several bytes (~ 1K) of input.
    # @return [Boolean]
    def self.detect(sample)
      false
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
        @@content_types[type] ||= []
        @@content_types[type] << self unless @@content_types[type].include?(self)

        if extensions = (options[:extension] || options[:extensions])
          extensions = Array(extensions).map(&:to_sym)
          extensions.each do |ext|
            @@file_extensions[ext] ||= []
            @@file_extensions[ext] << self unless @@file_extensions[ext].include?(self)
          end
        end
        if aliases = (options[:alias] || options[:aliases])
          aliases = Array(aliases).each do |a|
            @@content_types[a] ||= []
            @@content_types[a] << self unless @@content_types[a].include?(self)
          end
        end
      end
    end

    ##
    # Retrieves or defines file extensions for this RDF serialization format.
    #
    # The return is an array where the first element is the cannonical
    # file extension for the format and following elements are alias file extensions.
    #
    # @return [Array<String>]
    def self.file_extension
      @@file_extensions.map {|ext, formats| ext if formats.include?(self)}.compact
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
    # When called without an encoding, it returns the currently defined
    # content encoding for this format
    #
    # @param  [#to_sym] encoding
    # @return [void]
    def self.content_encoding(encoding = nil)
      @@content_encoding[self] = encoding.to_sym if encoding
      @@content_encoding[self] || "utf-8"
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
      @@subclasses << child if child
      super
    end
  end # Format

  ##
  # The base class for RDF serialization format errors.
  class FormatError < IOError
  end # FormatError
end # RDF
