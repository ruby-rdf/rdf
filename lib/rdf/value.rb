module RDF
  ##
  # An RDF value.
  #
  # @abstract
  class Value
    # Prevent instantiation of this class.
    private_class_method :new

    ##
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    ##
    # @param  [Object]  other
    # @return [Integer] -1, 0, 1
    def <=>(other)
      self.to_s <=> other.to_s
    end

    private

      def self.inherited(child) #:nodoc:
        # Enable instantiation of subclasses.
        child.send(:public_class_method, :new)
        super
      end

  end
end
