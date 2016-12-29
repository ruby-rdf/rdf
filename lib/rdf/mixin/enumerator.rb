module RDF
  ##
  # Enumerators for different mixins. These are defined in a separate module, so that they are bound when used, allowing other mixins inheriting behavior to be included.
  module Enumerable
    # Extends Enumerator with {Queryable} and {Enumerable}, which is used by {Enumerable#each_statement} and {Queryable#enum_for}
    class Enumerator < ::Enumerator
      include Queryable
      include Enumerable

      ##
      # @return [Array]
      # @note Make sure returned arrays are also queryable
      def to_a
        return super.to_a.extend(RDF::Queryable, RDF::Enumerable)
      end

      protected

      ##
      # @overload #to_ary
      #   @see #to_a
      #   @deprecated use {#to_a} instead
      def method_missing(name, *args)
        if name == :to_ary
          warn "[DEPRECATION] #{self.class}#to_ary is deprecated, use " \
               "#{self.class}#to_a instead. Called from " \
               "#{Gem.location_of_caller.join(':')}"
          to_a
        else
          super
        end
      end
    end
  end

  module Countable
    # Extends Enumerator with {Countable}, which is used by {Countable#enum_for}
    class Enumerator < ::Enumerator
      include Countable
    end
  end

  module Queryable
    # Extends Enumerator with {Queryable} and {Enumerable}, which is used by {Enumerable#each_statement} and {Queryable#enum_for}
    class Enumerator < ::Enumerator
      include Queryable
      include Enumerable

      ##
      # @return [Array]
      # @note Make sure returned arrays are also queryable
      def to_a
        return super.to_a.extend(RDF::Queryable, RDF::Enumerable)
      end

      protected

      ##
      # @overload #to_ary
      #   @see #to_a
      #   @deprecated use {#to_a} instead
      def method_missing(name, *args)
        if name == :to_ary
          warn "[DEPRECATION] #{self.class}#to_ary is deprecated, use " \
               "#{self.class}#to_a instead. Called from " \
               "#{Gem.location_of_caller.join(':')}"
          self.to_a
        else
          super
        end
      end
    end
  end
end
