require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/mutable'

describe RDF::Mutable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`
    @mutable = RDF::Repository.new
  end

  # @see lib/rdf/spec/mutable.rb in rdf-spec
  include RDF_Mutable
end
