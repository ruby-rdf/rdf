require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    @file       = etc_file("doap.nt")
    @statements = RDF::NTriples::Reader.new(File.open(@file)).to_a
    @queryable  = @statements.extend(RDF::Queryable)
    @subject    = RDF::URI.new("http://rubygems.org/gems/rdf")
  end

  it_should_behave_like RDF_Queryable
end
