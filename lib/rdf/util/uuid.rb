module RDF; module Util
  ##
  # Utilities for UUID handling.
  #
  # @see http://en.wikipedia.org/wiki/Universally_unique_identifier
  module UUID
    ##
    # Generates a UUID string.
    #
    # This will make use of either the [UUID][] gem or the [UUIDTools][]
    # gem, whichever of the two happens to be available.
    #
    # [UUID]:      https://rubygems.org/gems/uuid
    # [UUIDTools]: https://rubygems.org/gems/uuidtools
    #
    # @param  [:default, :compact, :urn] format (:default)
    # @return [String] a UUID string
    # @raise  [LoadError] if no UUID library is available
    # @see    https://rubygems.org/gems/uuid
    # @see    https://rubygems.org/gems/uuidtools
    def self.generate(format: :default)
      begin
        require 'uuid'
        ::UUID.generate(format)
      rescue LoadError
        begin
          require 'uuidtools'
          ::UUIDTools::UUID.random_create.hexdigest
        rescue LoadError
          raise LoadError.new("no such file to load -- uuid or uuidtools")
        end
      end
    end
  end # UUID
end; end # RDF::Util
