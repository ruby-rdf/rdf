require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/readable'

describe RDF::Readable do
  # @see lib/rdf/spec/readable.rb in rdf-spec
  it_behaves_like 'an RDF::Readable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    let(:readable) { double("Readable").extend(RDF::Readable) }
  end
end
