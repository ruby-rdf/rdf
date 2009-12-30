module RDF
  module VERSION
    MAJOR = 0
    MINOR = 0
    TINY  = 6
    EXTRA = nil

    STRING = [MAJOR, MINOR, TINY].join('.')
    STRING << "-#{EXTRA}" if EXTRA

    ##
    # @return [String]
    def self.to_s()   STRING end

    ##
    # @return [String]
    def self.to_str() STRING end
  end
end
