require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rdf/spec/graph'

describe RDF::Graph do

  before :each do
    @new = Proc.new { |*args| RDF::Graph.new(*args) }
  end

  it_should_behave_like RDF_Graph

end
