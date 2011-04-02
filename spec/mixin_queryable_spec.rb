require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    @queryable = RDF::Repository.new
  end

  # @see lib/rdf/spec/queryable.rb in rdf-spec
  it_should_behave_like RDF_Queryable
end
