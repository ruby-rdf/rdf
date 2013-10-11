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
      expect(graph).to be_unnamed
      expect(graph).not_to be_named
    end

    it "should not have a context" do
      graph = @new.call
      expect(graph.context).to be_nil
      expect(graph.contexts.size).to eq 0
    end
  end

  context "named graphs" do
    it "should be instantiable" do
      expect { @new.call }.not_to raise_error
    end

    it "should be named" do
      graph = @new.call("http://rdf.rubyforge.org/")
      expect(graph).not_to be_unnamed
      expect(graph).to be_named
    end

    it "should have a context" do
      graph = @new.call("http://rdf.rubyforge.org/")
      expect(graph.context).not_to be_nil
      expect(graph.contexts.size).to eq 1
    end

    it "should be #anonymous? with a Node context" do
      graph = @new.call(RDF::Node.new)
      expect(graph).to be_anonymous
    end

    it "should not be #anonymous? with a URI context" do
      graph = @new.call("http://rdf.rubyforge.org/")
      expect(graph).not_to be_anonymous
    end
  end

  it "should maintain arbitrary options" do
    graph = RDF::Graph.new(nil, :foo => :bar)
    expect(graph.options).to include(:foo => :bar)
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
      expect(RDF::Util::File).to receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = @new.call("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
      graph.load!
      expect(graph).not_to be_empty
    end

    it "Loading graph data from a URL (2)" do
      expect(RDF::Util::File).to receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = RDF::Graph.load("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
      expect(graph).not_to be_empty
    end
  end
end
