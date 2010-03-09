require 'addressable/uri'

module RDF
  ##
  # A Uniform Resource Identifier (URI).
  #
  # `RDF::URI` supports all the instance methods of `Addressable::URI`.
  #
  # @example Creating a URI reference (1)
  #   uri = RDF::URI.new("http://rdf.rubyforge.org/")
  #
  # @example Creating a URI reference (2)
  #   uri = RDF::URI.new(:scheme => 'http', :host => 'rdf.rubyforge.org', :path => '/')
  #
  # @example Getting the string representation of a URI
  #   uri.to_s #=> "http://rdf.rubyforge.org/"
  #
  # @see http://en.wikipedia.org/wiki/Uniform_Resource_Identifier
  # @see http://addressable.rubyforge.org/
  class URI < Resource
    ##
    # Creates a new `RDF::URI` instance based on the given `uri` string.
    #
    # This is just an alias for {#initialize RDF::URI.new} for compatibity
    # with `Addressable::URI.parse`.
    #
    # @param  [String] uri
    # @return [URI]
    def self.parse(uri)
      self.new(uri)
    end

    ##
    # @overload URI.new(uri)
    #   @param  [URI, String, #to_s]    uri
    #
    # @overload URI.new(options = {})
    #   @param  [Hash{Symbol => Object} options
    def initialize(uri_or_options)
      case uri_or_options
        when Hash
          @uri = Addressable::URI.new(uri_or_options)
        when Addressable::URI
          @uri = uri_or_options
        else
          @uri = Addressable::URI.parse(uri_or_options.to_s)
      end
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    def uri?
      true
    end

    ##
    # Returns `false`.
    #
    # @return [Boolean]
    def anonymous?
      false
    end

    ##
    # Joins several URIs together.
    #
    # @param  [Array<String, URI, #to_str>] uris
    # @return [URI]
    def join(*uris)
      result = @uri
      uris.each do |uri|
        result.path += '/' unless result.path[-1] == ?/ # '/'
        result = result.join(uri)
      end
      self.class.new(result)
    end

    ##
    # Returns `true` if this URI's path component is equal to `/`.
    #
    # @return [Boolean]
    def root?
      self.path == '/' || self.path.empty?
    end

    ##
    # Returns a copy of this URI with the path component set to `/`.
    #
    # @return [URI]
    def root
      if root?
        self
      else
        uri = self.dup
        uri.path = '/'
        uri
      end
    end

    ##
    # Returns `true` if this URI's path component isn't equal to `/`.
    #
    # @return [Boolean]
    def has_parent?
      !root?
    end

    ##
    # Returns a copy of this URI with the path component ascended to the
    # parent directory, if any.
    #
    # @return [URI]
    def parent
      case
        when root? then nil
        else
          require 'pathname' unless defined?(Pathname)
          if path = Pathname.new(self.path).parent
            uri = self.dup
            uri.path = path.to_s
            uri.path << '/' unless uri.root?
            uri
          end
      end
    end

    ##
    # Returns a qualified name (QName) for this URI, if possible.
    #
    # @return [Array(Symbol, Symbol)]
    def qname
      Vocabulary.each do |vocab|
        if to_s.index(vocab.to_uri.to_s) == 0
          vocab_name = vocab.__name__.split('::').last.downcase
          local_name = to_s[vocab.to_uri.to_s.size..-1]
          unless vocab_name.empty? || local_name.empty?
            return [vocab_name.to_sym, local_name.to_sym]
          end
        end
      end
      nil # no QName found
    end

    ##
    # Returns a duplicate copy of `self`.
    #
    # @return [URI]
    def dup
      self.class.new(@uri.dup)
    end

    ##
    # Checks whether this URI is equal to `other`.
    #
    # @param  [URI] other
    # @return [Boolean]
    def eql?(other)
      other.is_a?(URI) && self == other
    end

    ##
    # Checks whether this URI is equal to `other`.
    #
    # @param  [Object] other
    # @return [Boolean]
    def ==(other)
      case other
        when Addressable::URI
          to_s == other.to_s
        else
          other.respond_to?(:to_uri) && to_s == other.to_uri.to_s
      end
    end

    ##
    # Returns `self`.
    #
    # @return [URI]
    def to_uri
      self
    end

    ##
    # Returns a string representation of this URI.
    #
    # @return [String]
    def to_s
      @uri.to_s
    end

    ##
    # Returns a hash code for this URI.
    #
    # @return [Fixnum]
    def hash
      @uri.hash
    end

    ##
    # Returns `true` if this URI instance supports the `symbol` method.
    #
    # @param  [Symbol, String, #to_s] symbol
    # @return [Boolean]
    def respond_to?(symbol)
      @uri.respond_to?(symbol) || super
    end

    ##
    # @param  [Symbol, String, #to_s] symbol
    # @param  [Array<Object>]         args
    # @yield
    # @private
    def method_missing(symbol, *args, &block)
      if @uri.respond_to?(symbol)
        case result = @uri.send(symbol, *args, &block)
          when Addressable::URI
            self.class.new(result)
          else result
        end
      else
        super
      end
    end

    protected :method_missing
  end
end
