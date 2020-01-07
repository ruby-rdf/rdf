module RDF
  module Util
    module Coercions
      # This is a provisional module intended to house input
      # coercions. Currently the only coercion is a statement
      # preprocessor that is used in e.g. {RDF::Writable#insert} and
      # {RDF::Mutable#delete}.

      ##
      # Coerce a set of arguments into {RDF::Statement} objects and then
      # operate over them with a block.
      # 
      # @example
      #  process_statements(statements) { |value| do_something(value) }
      #
      # @param statements [#map] The arbitrary-ish input to be manipulated
      # @param query [false, true] Whether to call +query+ before the block
      # @param constant [false, true] Whether to test if the statements
      #  are constant
      # @yield [RDF::Statement, RDF::Enumerable] 
      # @return statements
      def process_statements(statements, query: false, constant: false, &block)
        raise ArgumentError, 'expecting a block' unless block_given?

        statements = statements.map do |value|
          case
          when value.respond_to?(:each_statement)
            block.call(value)
            nil
          when (statement = Statement.from(value)) &&
              (!constant || statement.constant?)
            statement
          when query
            # XXX note that this only makes sense when the module is include()d
            block.call(query(value))
            nil
          else
            raise ArgumentError, "Not a valid statement: #{value.inspect}"
          end
        end.compact

        block.call(statements) unless statements.empty?

        # eh might as well return these
        statements
      end

      # so you can include or call
      extend self
    end
  end
end
