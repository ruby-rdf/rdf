module RDF
  ##
  # An RDF statement enumeration interface.
  #
  # Classes that include this module must implement an {#each} method that
  # returns {RDF::Statement statements}.
  #
  # @see RDF::Graph
  # @see RDF::Repository
  module Enumerable
    extend ::Enumerable

    # TODO
  end
end
