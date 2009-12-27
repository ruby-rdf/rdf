module RDF
  ##
  # An RDF basic graph pattern query.
  class Query
    ##
    # @yield  [query]
    # @yieldparam [Query]
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
