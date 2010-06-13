module RDF ; module Util

  ##
  # If a class includes this module, its alias_method will be overwritten to a
  # new one which points to the current implementation of the aliased method
  # instead of the version implemented at the time alias_method was called, as
  # is the default behavior in Ruby.  RDF.rb mixins alias many methods, such as
  # `RDF::Enumearble#count` being aliased to `#size` and `#length`.  If subclasses
  # re-implement these methods (as is generally the case), the default method
  # alias will still point to the reference implementation defined when the
  # mixins were declared.
  module Aliasing

    ## 
    # Alias :old to the existing method at :new
    #
    # @param [Symbol] new
    # @param [Symbol] old
    # @return [Void]
    #
    # @example aliasing #count to #size
    #     alias_method :size, :count
    def self.alias_method(new, old) 
      self.send(:define_method, new) do | *args , &block|
        send(old, *args, &block)
      end
    end
  end
end ; end
