require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/mutable'

describe RDF::Mutable do
  # @see lib/rdf/spec/mutable.rb in rdf-spec
  it_behaves_like 'an RDF::Mutable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`
    let(:mutable) { RDF::Repository.new }
  end
end
