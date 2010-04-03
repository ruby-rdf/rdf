require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/mutable'

describe RDF::Mutable do
  before :each do
    @filename   = etc_file("doap.nt")
    # Possible reference implementations are RDF::Repository and RDF::Graph.
    @repository = RDF::Repository.new
    @subject    = RDF::URI.new("http://rubygems.org/gems/rdf")
    @context    = RDF::URI.new("http://example.org/context")
  end

  it_should_behave_like RDF_Mutable
end
