module RDF
  ##
  # Resource Description Framework (RDF) vocabulary.
  #
  # @see http://www.w3.org/RDF/
  class RDF < Vocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
    property :first
    property :object
    property :predicate
    property :rest
    property :subject
    property :type
    property :value
  end
end
