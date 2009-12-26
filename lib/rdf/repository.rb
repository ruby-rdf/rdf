module RDF
  ##
  # An RDF repository.
  class Repository
    include Enumerable

    ##
    # @yield  [repository]
    # @yieldparam [Repository]
    def initialize(options = {}, &block)
      @data, @options = [], options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    # TODO
  end
end
