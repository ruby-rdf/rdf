require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Graph do
  before :each do
    def new(*args, &block)
      RDF::Graph.new(*args, &block)
    end
    @new = method(:new)
  end

  context "unnamed graphs" do
    it "should be instantiable" do
      expect { @new.call }.not_to raise_error
    end

    it "should be unnamed" do
      graph = @new.call
      graph.unnamed?.should be_true
      graph.named?.should be_false
    end

    it "should not have a context" do
      graph = @new.call
      graph.context.should be_nil
      graph.contexts.size.should == 0
    end
  end

  context "named graphs" do
    it "should be instantiable" do
      expect { @new.call }.not_to raise_error
    end

    it "should be named" do
      graph = @new.call("http://rdf.rubyforge.org/")
      graph.unnamed?.should be_false
      graph.named?.should be_true
    end

    it "should have a context" do
      graph = @new.call("http://rdf.rubyforge.org/")
      graph.context.should_not be_nil
      graph.contexts.size.should == 1
    end

    it "should be #anonymous? with a Node context" do
      graph = @new.call(RDF::Node.new)
      graph.should be_anonymous
    end

    it "should not be #anonymous? with a URI context" do
      graph = @new.call("http://rdf.rubyforge.org/")
      graph.should_not be_anonymous
    end
  end

  it "should maintain arbitrary options" do
    @graph = RDF::Graph.new(nil, :foo => :bar)
    @graph.options.should have_key(:foo)
    @graph.options[:foo].should == :bar
  end

  context "as repository" do
    require 'rdf/spec/repository'
    before :each do
      @repository = @new.call
    end

    include RDF_Repository
  end

  context "Examples" do
    require 'rdf/rdfxml'

    let(:graph) {@new.call}

    it "Creating an empty unnamed graph" do
      expect {@new.call}.not_to raise_error
    end

    it "Creating an empty named graph" do
      expect {@new.call("http://rubygems.org/")}.not_to raise_error
    end

    it "Loading graph data from a URL (1)" do
      RDF::Util::File.
        should_receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = @new.call("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
      graph.load!
      graph.should_not be_empty
    end

    it "Loading graph data from a URL (2)" do
      RDF::Util::File.
        should_receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = RDF::Graph.load("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
      graph.should_not be_empty
    end
  end
end
