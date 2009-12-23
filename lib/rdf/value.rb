module RDF
  ##
  # An RDF value.
  #
  # @abstract
  class Value
    # Prevent instantiation of this class.
    private_class_method :new

    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, to_s)
    end

    private

      def self.inherited(child) #:nodoc:
        # Enable instantiation of subclasses.
        child.send(:public_class_method, :new)
        super
      end

  end
end
