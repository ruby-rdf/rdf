require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/indexable'

describe RDF::Indexable do
  before :each do
    @indexable = mock("Indexable")
    @indexable.extend(RDF::Indexable)
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  it_should_behave_like RDF_Indexable
end
