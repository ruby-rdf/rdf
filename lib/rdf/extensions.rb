##
# This file provides compatibility monkeypatches to standard library classes
# Implementation taken from MIT-licensed https://github.com/marcandre/backports
#

# https://github.com/marcandre/backports/blob/master/lib/backports/2.4.0/regexp/match.rb
unless Regexp.method_defined? :match?
  class Regexp
    def match?(*args)
      !match(*args).nil?
    end
  end
end

# https://github.com/marcandre/backports/blob/master/lib/backports/2.4.0/string/match.rb
unless String.method_defined? :match?
  class String
    def match?(*args)
      !match(*args).nil?
    end
  end
end
