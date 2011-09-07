require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/format'
require 'rdf/ntriples'
require 'rdf/nquads'

describe RDF::Format do
  before(:each) do
    @format_class = RDF::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  it_should_behave_like RDF_Format
end
