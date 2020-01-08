# -*- coding: utf-8 -*-
module RDF
  module Util
    module Coercions
      # This is a provisional module intended to house input
      # coercions. Currently the only coercion is a statement
      # preprocessor that is used in e.g. {RDF::Writable#insert} and
      # {RDF::Mutable#delete}.

      protected

      ##
      # Coerce an array of arguments into {RDF::Statement}, or
      # {RDF::Enumerable} and then yield to a block. Note that this
      # code was amalgamated from that which was sandwiched around
      # both {RDF::Writable#insert_statements} and
      # {RDF::Mutable#delete_statements}. The parameters `query` and
      # `constant` are therefore present to handle the conditions
      # where the statements contain wildcards and what to do about
      # them.
      # 
      # @example
      #  coerce_statements(statements) { |value| do_something(value) }
      #
      # @param statements [#map] The arbitrary-ish input to be manipulated
      # @param query [false, true] Whether to call `query` before the block
      #  (as expected by {Mutable#delete_statements})
      # @param constant [false, true] Whether to test if the statements
      #  are constant (as expected by {Mutable#delete_statements})
      # @yield [RDF::Statement, RDF::Enumerable] 
      # @return statements
      def coerce_statements(statements, query: false, constant: false, &block)
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
            block.call(self.query(value))
            nil
          else
            raise ArgumentError, "Not a valid statement: #{value.inspect}"
          end
        end.compact

        block.call(statements) unless statements.empty?

        # eh might as well return these
        statements
      end

    end
  end
end
