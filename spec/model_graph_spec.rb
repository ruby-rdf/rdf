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
    graph = @new.call(nil, :foo => :bar)
    graph.options.should have_key(:foo)
    graph.options[:foo].should == :bar
  end
  
  it "should not override context on statements without context" do
    graph = @new.call
    graph << RDF::Statement.new("s", "p", "o")
    graph.first.context.should be_nil
  end
  
  context "unnamed graphs" do
    it "should not clear context on statements with context" do
      graph = @new.call
      graph << RDF::Statement.new("s", "p", "o", :context => "c")
      graph.first.context.should == "c"
    end
    
    it "should enumerate statements without context" do
      graph = @new.call
      graph << RDF::Statement.new("s", "p", "o")
      graph.first.should_not be_nil
    end
    
    it "should enumerate statements with context" do
      graph = @new.call
      graph << RDF::Statement.new("s", "p", "o", :context => "c")
      graph.first.should_not be_nil
    end
  end
  
  context "named graphs" do
    it "should override context on statements without context"  do
      graph = @new.call("g")
      graph << RDF::Statement.new("s", "p", "o")
      graph.first.context.should == "g"
    end
    
    it "should not override context on statements with context" do
      graph = @new.call("g")
      graph << RDF::Statement.new("s", "p", "o", :context => "c")
      graph.first.context.should == "c"
    end
    
    it "should enumerate statements without context" do
      graph = @new.call("g")
      graph << RDF::Statement.new("s", "p", "o")
      graph.first.should_not be_nil
    end

    it "should enumerate statements with context" do
      graph = @new.call("g")
      graph << RDF::Statement.new("s", "p", "o", :context => "c")
      graph.first.should_not be_nil
    end
  end
end
