require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/indexable'

describe RDF::Indexable do
  # @see lib/rdf/spec/indexable.rb in rdf-spec
  it_behaves_like 'an RDF::Indexable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a double will do fine as well:
    let(:indexable) do
      d = double("Indexable").extend(RDF::Indexable)
      allow(d).to receive(:index!) {d}
      d
    end
  end
end
