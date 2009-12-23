module RDF
  ##
  # An RDF literal.
  class Literal < Value
    attr_accessor :value
    attr_accessor :language
    attr_accessor :datatype

    def initialize(value, options = {})
      @value = value
      @language = options[:language] ? options[:language].to_s.downcase.to_sym : nil

      # TODO
    end

    def to_s
      value # TODO
    end
  end
end
