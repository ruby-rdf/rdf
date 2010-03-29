require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Enumerable do
  before :each do
    @statements = RDF::NTriples::Reader.new(File.open(etc_file("doap.nt"))).to_a
    @queryable  = @statements.extend(RDF::Queryable)
    @subject    = RDF::URI.new("http://rubygems.org/gems/rdf")
  end

  it_should_behave_like RDF_Queryable
end
