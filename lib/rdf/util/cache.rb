module RDF; module Util
  ##
  # A `Hash`-like cache that holds only weak references to the values it
  # caches, meaning that values contained in the cache can be garbage
  # collected. This allows the cache to dynamically adjust to changing
  # memory conditions, caching more objects when memory is plentiful, but
  # evicting most objects if memory pressure increases to the point of
  # scarcity.
  #
  # While this cache is something of an internal implementation detail of
  # RDF.rb, some external libraries do currently make use of it as well,
  # including [SPARQL::Algebra](http://sparql.rubyforge.org/algebra/) and
  # [Spira](http://spira.rubyforge.org/). Do be sure to include any changes
  # here in the RDF.rb changelog.
  #
  # @see   RDF::URI.intern
  # @see   http://en.wikipedia.org/wiki/Weak_reference
  # @since 0.2.0
  class Cache
    ##
    # @private
    def self.new(*args)
      # JRuby doesn't support `ObjectSpace#_id2ref` unless the `-X+O`
      # startup option is given, so on that platform we'll default to using
      # the WeakRef-based cache:
      klass = case RUBY_PLATFORM
        when /java/ then WeakRefCache
        else ObjectSpaceCache
      end
      cache = klass.allocate
      cache.send(:initialize, *args)
      cache
    end

    ##
    # @param  [Integer] capacity
    def initialize(capacity = -1)
      @capacity = capacity
      @cache  ||= {}
      @index  ||= {}
    end

    ##
    # @return [Integer]
    def size
      @cache.size
    end

    ##
    # @return [Boolean]
    def has_capacity?
      @capacity.equal?(-1) || @capacity > @cache.size
    end

    ##
    # @param  [Object] value
    # @return [void]
    def define_finalizer!(value)
      ObjectSpace.define_finalizer(value, finalizer)
    end

    ##
    # @return [Proc]
    def finalizer
      lambda { |object_id| @cache.delete(@index.delete(object_id)) }
    end

    ##
    # This implementation relies on `ObjectSpace#_id2ref` and performs
    # optimally on Ruby 1.8.x and 1.9.x; however, it does not work on JRuby
    # by default since much `ObjectSpace` functionality on that platform is
    # disabled unless the `-X+O` startup option is given.
    #
    # @see http://ruby-doc.org/ruby-1.9/classes/ObjectSpace.html
    # @see http://eigenclass.org/hiki/weakhash+and+weakref
    class ObjectSpaceCache < Cache
      ##
      # @param  [Object] key
      # @return [Object]
      def [](key)
        if value_id = @cache[key]
          value = ObjectSpace._id2ref(value_id) rescue nil
        end
      end

      ##
      # @param  [Object] key
      # @param  [Object] value
      # @return [Object]
      def []=(key, value)
        if has_capacity?
          @cache[key] = value.__id__
          @index[value.__id__] = key
          define_finalizer!(value)
        end
        value
      end
    end # class ObjectSpaceCache

    ##
    # This implementation uses the `WeakRef` class from Ruby's standard
    # library, and provides adequate performance on JRuby and on Ruby 1.9.x;
    # however, it performs very suboptimally on Ruby 1.8.x.
    #
    # @see http://ruby-doc.org/ruby-1.9/classes/WeakRef.html
    class WeakRefCache < Cache
      ##
      # @param  [Integer] capacity
      def initialize(capacity = -1)
        require 'weakref' unless defined?(::WeakRef)
        super
      end

      ##
      # @param  [Object] key
      # @return [Object]
      def [](key)
        if (ref = @cache[key]) && ref.weakref_alive?
          value = ref.__getobj__ rescue nil
        end
      end

      ##
      # @param  [Object] key
      # @param  [Object] value
      # @return [Object]
      def []=(key, value)
        if has_capacity?
          @cache[key] = WeakRef.new(value)
          @index[value.__id__] = key
          define_finalizer!(value)
        end
        value
      end
    end # class WeakRefCache
  end # class Cache
end; end # module RDF::Util
