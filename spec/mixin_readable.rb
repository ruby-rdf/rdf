require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/readable'

describe RDF::Readable do
  before :each do
    @readable = mock("Readable")
    @readable.extend(RDF::Readable)
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  it_should_behave_like RDF_Readable
end
