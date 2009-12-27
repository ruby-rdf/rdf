module RDF
  ##
  # An RDF serialization format.
  class Format
    ##
    # @yield  [format]
    # @yieldparam [Format]
    def initialize(options = {}, &block)
      @options = options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end
  end
end
