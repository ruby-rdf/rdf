module RDF
  module VERSION
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    EXTRA = nil

    STRING = [MAJOR, MINOR, TINY].join('.')
    STRING << "-#{EXTRA}" if EXTRA

    def self.to_s()   STRING end
    def self.to_str() STRING end
  end
end
