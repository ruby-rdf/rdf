require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    @filename   = etc_file("doap.nt")
    @statements = RDF::NTriples::Reader.new(File.open(@filename)).to_a
    @queryable  = @statements.extend(RDF::Queryable)
    @subject    = RDF::URI("http://rubygems.org/gems/rdf")
  end

  # @see lib/rdf/spec/queryable.rb in rdf-spec
  it_should_behave_like RDF_Queryable
end
