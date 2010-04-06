require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/statement'

describe RDF::Statement do

  before :each do
    @n3   = "<http://rubygems.org/gems/rdf> <http://purl.org/dc/elements/1.1/creator> <http://ar.to/#self> ."
    @s    = RDF::URI.parse("http://rubygems.org/gems/rdf")
    @p    = RDF::URI.parse("http://purl.org/dc/elements/1.1/creator")
    @o    = RDF::URI.parse("http://ar.to/#self")
    @stmt = RDF::Statement.new(@s, @p, @o)
  end

  it_should_behave_like RDF_Statement
end
