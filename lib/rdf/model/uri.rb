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
  # @example Creating an interned URI reference
  #   uri = RDF::URI.intern("http://rdf.rubyforge.org/")
  #
  # @example Getting the string representation of a URI
  #   uri.to_s #=> "http://rdf.rubyforge.org/"
  #
  # @see http://en.wikipedia.org/wiki/Uniform_Resource_Identifier
  # @see http://addressable.rubyforge.org/
  class URI
    include RDF::Resource

    ##
    # Defines the maximum number of interned URI references that can be held
    # cached in memory at any one time.
    CACHE_SIZE = -1 # unlimited by default

    ##
    # @return [RDF::Util::Cache]
    # @private
    def self.cache
      require 'rdf/util/cache' unless defined?(::RDF::Util::Cache)
      @cache ||= RDF::Util::Cache.new(CACHE_SIZE)
    end

    ##
    # Returns an interned `RDF::URI` instance based on the given `uri`
    # string.
    #
    # The maximum number of cached interned URI references is given by the
    # `CACHE_SIZE` constant. This value is unlimited by default, in which
    # case an interned URI object will be purged only when the last strong
    # reference to it is garbage collected (i.e., when its finalizer runs).
    #
    # Excepting special memory-limited circumstances, it should always be
    # safe and preferred to construct new URI references using
    # `RDF::URI.intern` instead of `RDF::URI.new`, since if an interned
    # object can't be returned for some reason, this method will fall back
    # to returning a freshly-allocated one.
    #
    # @param  [String, #to_s] str
    # @return [RDF::URI]
    def self.intern(str)
      cache[str = str.to_s] ||= self.new(str).freeze
    end

    ##
    # Creates a new `RDF::URI` instance based on the given `uri` string.
    #
    # This is just an alias for {#initialize RDF::URI.new} for compatibity
    # with `Addressable::URI.parse`.
    #
    # @param  [String, #to_s] str
    # @return [RDF::URI]
    def self.parse(str)
      self.new(str)
    end

    ##
    # @overload URI.new(uri)
    #   @param  [RDF::URI, String, #to_s] uri
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
    # Returns `false`.
    #
    # @return [Boolean]
    def anonymous?
      false
    end

    ##
    # Returns `true`.
    #
    # @return [Boolean]
    # @see    http://en.wikipedia.org/wiki/Uniform_Resource_Identifier
    def uri?
      true
    end

    ##
    # Returns `true` if this URI is a URN.
    #
    # @return [Boolean]
    # @see    http://en.wikipedia.org/wiki/Uniform_Resource_Name
    # @since  0.2.0
    def urn?
      to_s.index('urn:') == 0
    end

    ##
    # Returns `true` if this URI is a URL.
    #
    # @return [Boolean]
    # @see    http://en.wikipedia.org/wiki/Uniform_Resource_Locator
    # @since  0.2.0
    def url?
      !urn?
    end

    ##
    # Validates this URI, raising an error if it is invalid.
    #
    # @return [RDF::URI] `self`
    # @raise  [ArgumentError] if the URI is invalid
    # @since  0.3.0
    def validate!
      # TODO: raise error if the URI fails validation
      self
    end
    alias_method :validate, :validate!

    ##
    # Joins several URIs together.
    #
    # This method conforms to join normalization semantics as per RFC3986,
    # section 5.2.  This method normalizes URIs, removes some duplicate path
    # information, such as double slashes, and other behavior specified in the
    # RFC.
    #
    # Other URI building methods are `#/` and `#+`.
    #
    # For an up-to-date list of edge case behavior, see the shared examples for
    # RDF::URI in the rdf-spec project.
    #
    # @example Joining two URIs
    #     RDF::URI.new('http://example.org/foo/bar').join('/foo')
    #     #=> RDF::URI('http://example.org/foo')
    # @see <http://github.com/bendiken/rdf-spec/blob/master/lib/rdf/spec/uri.rb>
    # @see <http://tools.ietf.org/html/rfc3986#section-5.2>
    # @see RDF::URI#/
    # @see RDF::URI#+
    # @param  [Array<String, RDF::URI, #to_s>] uris
    # @return [RDF::URI]
    def join(*uris)
      result = @uri.dup
      uris.each do |uri|
        result = result.join(uri)
      end
      self.class.new(result)
    end

    ##
    # 'Smart separator' URI builder
    #
    # This method attempts to use some understanding of the most common use
    # cases for URLs and URNs to create a simple method for building new URIs
    # from fragments.  This means that it will always insert a separator of
    # some sort, will remove duplicate seperators, will always assume that a
    # fragment argument represents a relative and not absolute path, and throws
    # an exception when an absolute URI is received for a fragment argument.
    #
    # This is separate from the semantics for `#join`, which are well-defined by
    # RFC3986 section 5.2 as part of the merging and normalization process;
    # this method does not perform any normalization, removal of spurious
    # paths, or removal of parent directory references `(/../)`.
    #
    # See also `#+`, which concatenates the string forms of two URIs without
    # any sort of checking or processing.
    #
    # For an up-to-date list of edge case behavior, see the shared examples for
    # RDF::URI in the rdf-spec project.
    #
    # @param [Any] fragment A URI fragment to be appended to this URI
    # @return [RDF::URI]
    # @see RDF::URI#+
    # @see RDF::URI#join
    # @see <http://tools.ietf.org/html/rfc3986#section-5.2>
    # @see <http://github.com/bendiken/rdf-spec/blob/master/lib/rdf/spec/uri.rb>
    # @example Building a HTTP URL
    #     RDF::URI.new('http://example.org') / 'jhacker' / 'foaf.ttl'
    #     #=> RDF::URI('http://example.org/jhacker/foaf.ttl')
    # @example Building a HTTP URL
    #     RDF::URI.new('http://example.org/') / '/jhacker/' / '/foaf.ttl'
    #     #=> RDF::URI('http://example.org/jhacker/foaf.ttl')
    # @example Using an anchored base URI
    #     RDF::URI.new('http://example.org/users#') / 'jhacker'
    #     #=> RDF::URI('http://example.org/users#jhacker')
    # @example Building a URN
    #     RDF::URI.new('urn:isbn') / 125235111
    #     #=> RDF::URI('urn:isbn:125235111')
    def /(fragment)
      fragment = fragment.respond_to?(:to_uri) ? fragment.to_uri : RDF::URI.intern(fragment.to_s)
      raise ArgumentError, "Non-absolute URI or string required, got #{fragment}" unless fragment.relative?
      if urn?
        RDF::URI.intern(to_s.sub(/:+$/,'') + ':' + fragment.to_s.sub(/^:+/,''))
      else # !urn?
        case to_s[-1].chr
          when '#'
            case fragment.to_s[0].chr
              when '/' then # Base ending with '#', fragment beginning with '/'.  The fragment wins, we use '/'.
              RDF::URI.intern(to_s.sub(/#+$/,'') + '/' + fragment.to_s.sub(/^\/+/,''))
            else
              RDF::URI.intern(to_s.sub(/#+$/,'') + '#' + fragment.to_s.sub(/^#+/,''))
            end
          else # includes '/'.  Results from bases ending in '/' are the same as if there were no trailing slash.
            case fragment.to_s[0].chr
              when '#' then # Base ending with '/', fragment beginning with '#'.  The fragment wins, we use '#'.
                RDF::URI.intern(to_s.sub(/\/+$/,'') + '#' + fragment.to_s.sub(/^#+/,''))
              else
                RDF::URI.intern(to_s.sub(/\/+$/,'') + '/' + fragment.to_s.sub(/^\/+/,''))
              end
          end
      end
    end

    ##
    # Simple concatenation operator.  Returns a URI formed from concatenating
    # the string form of two elements.
    #
    # For building URIs from fragments, you may want to use the smart
    # separator, `#/`.  `#join` implements another set of URI building
    # semantics.
    #
    # @example Concatenating a string to a URI
    #     RDF::URI.new('http://example.org/test') + 'test'
    #     #=> RDF::URI('http://example.org/testtest')
    # @example Concatenating two URIs
    #     RDF::URI.new('http://example.org/test') + RDF::URI.new('test')
    #     #=> RDF::URI('http://example.org/testtest')
    # @see RDF::URI#/
    # @see RDF::URI#join
    # @param [Any]
    # @return [RDF::URI]
    def +(other)
      RDF::URI.intern(self.to_s + other.to_s)
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
    # @return [RDF::URI]
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
    # @return [RDF::URI]
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
    # @return [RDF::URI]
    def dup
      self.class.new(@uri.dup)
    end

    ##
    # @private
    def freeze
      @uri.freeze
      super
    end

    ##
    # Checks whether this URI is equal to `other`.
    #
    # @param  [RDF::URI] other
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
    # @return [RDF::URI]
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

  protected

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
  end # URI
end # RDF
