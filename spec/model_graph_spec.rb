require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/graph'

describe RDF::Graph do
  before :each do
    def new(*args, &block)
      RDF::Graph.new(*args, &block)
    end
    @new = method(:new)
  end

  # @see lib/rdf/spec/graph.rb in rdf-spec
  it_should_behave_like RDF_Graph

  it "should maintain arbitrary options" do
    @graph = RDF::Graph.new(nil, :foo => :bar)
    @graph.options.should have_key(:foo)
    @graph.options[:foo].should == :bar
  end
end
