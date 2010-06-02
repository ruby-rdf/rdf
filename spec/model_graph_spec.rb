require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rdf/spec/graph'

describe RDF::Graph do

  before :each do
    @new = Proc.new { |*args| RDF::Graph.new(*args) }
  end

  it_should_behave_like RDF_Graph

  it "should maintain metadata options" do
    @graph = RDF::Graph.new(nil, :test => "Test metadata")
    @graph.options[:test].should == "Test metadata"
  end

end
