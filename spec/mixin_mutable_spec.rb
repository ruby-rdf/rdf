require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/mutable'

describe RDF::Mutable do
  before :each do
    @filename   = etc_file("doap.nt")
    # Possible reference implementations are RDF::Repository and RDF::Graph.
    @repository = RDF::Repository.new
    @subject    = RDF::URI("http://rubygems.org/gems/rdf")
    @context    = RDF::URI("http://example.org/context")
  end

  # @see lib/rdf/spec/mutable.rb in rdf-spec
  it_should_behave_like RDF_Mutable
end
