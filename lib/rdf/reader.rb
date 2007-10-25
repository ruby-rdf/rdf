module RDF
  class Reader
    def initialize(stream = $stdin, &block)
      @stream = stream
      block.call(self) if block_given?
    end
  end

  module Readers; end
end
