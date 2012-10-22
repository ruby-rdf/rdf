module RDF; class Query
  ##
  # An RDF query pattern normalizer.
  class HashPatternNormalizer
    ##
    # A counter that can be incremented and decremented.
    class Counter
      ##
      # The offset (or initial value) for this counter.
      #
      # @return [Fixnum]
      attr_reader :offset
      
      ##
      # The increment for this counter.
      #
      # @return [Fixnum]
      attr_reader :increment
      
      ##
      # @param [Fixnum] offset
      #   the offset (or initial value) for this counter.
      # @param [Fixnum] increment
      #   the increment for this counter.
      def initialize(offset = 0, increment = 1)
        @offset = offset.to_i
        @increment = increment.to_i
        
        @value = @offset
      end

      ##
      # Decrements this counter, and returns the new value. 
      #
      # @return [Fixnum]      
      def decrement!
        @value -= @increment
      end
      
      ##
      # Increments this counter, and returns the new value. 
      #
      # @return [Fixnum]
      def increment!
        @value += @increment
      end
      
      ##
      # Returns an integer representation of this counter.
      #
      # @return [Fixnum]
      def to_i
        @value.to_i
      end
      
      ## Returns a string representation of this counter.
      #
      # @return [String]
      def to_s
        @value.to_s
      end
    end # RDF::Query::HashPatternNormalizer::Counter
    
    class << self
      ##
      # Returns the normalization of the specified `hash_pattern`.
      #
      # @param [Hash{Symbol => Object}] hash_pattern (Hash.new)
      #   the query pattern as a hash.
      # @param [Hash{Symbol => Object}] options (Hash.new)
      #   any additional normalization options.
      # @option options [String] :anonymous_subject_format ("__%s__")
      #   the string format for anonymous subjects.
      # @return [Hash{Symbol => Object}]
      #   the resulting query pattern as a normalized hash.
      def normalize(hash_pattern = {}, options = {})
        raise ArgumentError, "invalid hash pattern: #{hash_pattern.inspect}" unless hash_pattern.is_a?(Hash)
        
        counter = RDF::Query::HashPatternNormalizer::Counter.new
        
        hash_pattern.inject({}) { |acc, pair|
          acc[pair.first] = normalize_hash!(pair.last, acc, counter, options)
          acc
        }
      end
      
      private
      
      ##
      # @private
      def normalize_array!(array, normalized_hash_pattern, counter, options)
        raise ArgumentError, "invalid array pattern: #{array.inspect}" unless array.is_a?(Array)
        
        array.collect { |object| 
          normalize_object!(object, normalized_hash_pattern, counter, options)
        }
      end
      
      ##
      # @private
      def normalize_hash!(hash, normalized_hash_pattern, counter, options)
        raise ArgumentError, "invalid hash pattern: #{hash.inspect}" unless hash.is_a?(Hash)
        
        hash.inject({}) { |acc, pair|
          acc[pair.first] = normalize_object!(pair.last, normalized_hash_pattern, counter, options)
          acc
        }
      end
      
      ##
      # @private
      def normalize_object!(object, normalized_hash_pattern, counter, options)
        case object
          when Array then normalize_array!(object, normalized_hash_pattern, counter, options)
          when Hash  then replace_hash_with_anonymous_subject!(object, normalized_hash_pattern, counter, options)
                     else object
        end
      end
      
      ##
      # @private      
      def replace_hash_with_anonymous_subject!(hash, normalized_hash_pattern, counter, options)
        raise ArgumentError, "invalid hash pattern: #{hash.inspect}" unless hash.is_a?(Hash)
        
        key = ((options[:anonymous_subject_format] || '__%s__').to_s % counter.increment!).to_sym
        
        normalized_hash_pattern[key] = normalize_hash!(hash, normalized_hash_pattern, counter, options)

        return key
      end
    end
    
    ##
    # The options for this hash pattern normalizer.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options
    
    ##
    # @param [Hash{Symbol => Object}] options (Hash.new)
    #   any additional normalization options.
    # @option options [String] :anonymous_subject_format ("__%s__")
    #   the string format for anonymous subjects.
    def initialize(options = {})
      @options = options.dup
    end
    
    ##
    # Equivalent to calling `self.class.normalize(hash_pattern, self.options)`.
    #
    # @param [Hash{Symbol => Object}] hash_pattern
    #   the query pattern as a hash.
    # @return [Hash{Symbol => Object}]
    #   the resulting query pattern as a normalized hash.
    def normalize(hash_pattern = {})
      self.class.normalize(hash_pattern, options)
    end
  end # RDF::Query::HashPatternNormalizer
end; end # RDF::Query
