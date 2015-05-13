require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/countable'

describe RDF::Countable do
  # @see lib/rdf/spec/countable.rb in rdf-spec
  it_behaves_like 'an RDF::Countable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    let(:countable) { RDF::Spec.quads.extend(described_class) }
  end
end
