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
      lambda { @new.call }.should_not raise_error
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
      lambda { @new.call }.should_not raise_error
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

  context "when counting statements" do
    require 'rdf/spec/countable'

    before :each do
      @countable = @new.call
    end

    it_should_behave_like RDF_Countable
  end

  context "when enumerating statements" do
    require 'rdf/spec/enumerable'

    before :each do
      @enumerable = @new.call
    end

    it_should_behave_like RDF_Enumerable
  end

  context "when querying statements" do
    require 'rdf/spec/queryable'

    before :each do
      @queryable = @new.call
      @subject   = RDF::URI.new('http://rubygems.org/gems/rdf')
    end

    it_should_behave_like RDF_Queryable
  end

  context "when updating" do
    require 'rdf/spec/mutable'

    before :each do
      @mutable = @new.call
      @subject = RDF::URI.new('http://rubygems.org/gems/rdf')
      @context = RDF::URI.new('http://example.org/context')
    end

    it_should_behave_like RDF_Mutable
  end

  context "as a durable repository" do
    require 'rdf/spec/durable'

    before :each do
      @load_durable ||= lambda { @new.call }
    end

    it_should_behave_like RDF_Durable
  end
end
