require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do
  before :each do
    @repository = RDF::Repository.new
  end

  it_should_behave_like RDF_Repository
end
