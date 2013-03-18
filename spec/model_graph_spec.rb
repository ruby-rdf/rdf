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
    subject {
      @new.call("http://ruby-rdf.github.com/rdf/etc/doap.nt", :data => RDF::Repository.new)
    }
    it "should be instantiable" do
      lambda { subject }.should_not raise_error
    end

    it "should not be instantiable by default" do
      lambda { @new.call("http://rdf.rubyforge.org/") }.should raise_error
    end

    its(:named?) {should be_true}
    its(:unnamed?) {should be_false}
    its(:name) {should_not be_nil}
    its(:context) {should_not be_nil}
    its(:context) {subject.contexts.size.should == 1}
    it {should_not be_anonymous}

    context "with anonymous context" do
      subject {@new.call(RDF::Node.new, :data => RDF::Repository.new)}
      it {should be_anonymous}
    end
  end

  context "with Repository as data" do
    let(:repo) {
      r = RDF::Repository.new
      r << [RDF::URI('s'), RDF::URI('p'), RDF::URI('o1')]
      r << [RDF::URI('s'), RDF::URI('p'), RDF::URI('o2'), RDF::URI('c')]
      r
    }
    it "should access default graph" do
      graph = @new.call(nil, :data => repo)
      graph.count.should == 1
      graph.statements.first.object.should == RDF::URI('o1')
    end

    it "should access named graph" do
      graph = @new.call(RDF::URI('c'), :data => repo)
      graph.count.should == 1
      graph.statements.first.object.should == RDF::URI('o2')
    end

    it "should not load! default graph" do
      graph = @new.call(nil, :data => repo)
      lambda {graph.load!}.should raise_error(ArgumentError)
    end

    it "should reload named graph" do
      graph = @new.call(RDF::URI("http://example/doc.nt"), :data => repo)
      graph.should_receive(:load).with("http://example/doc.nt", :base_uri => "http://example/doc.nt")
      graph.load!
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

    include RDF_Countable
  end

  context "when enumerating statements" do
    require 'rdf/spec/enumerable'

    before :each do
      @enumerable = @new.call
    end

    include RDF_Enumerable
  end

  context "when querying statements" do
    require 'rdf/spec/queryable'

    before :each do
      @queryable = @new.call
      @subject   = RDF::URI.new('http://rubygems.org/gems/rdf')
    end

    include RDF_Queryable
  end

  context "when updating" do
    require 'rdf/spec/mutable'

    before :each do
      @mutable = @new.call
      @subject = RDF::URI.new('http://rubygems.org/gems/rdf')
      @context = RDF::URI.new('http://example.org/context')
    end

    include RDF_Mutable
  end

  context "as a durable repository" do
    require 'rdf/spec/durable'

    before :each do
      @load_durable ||= lambda { @new.call }
    end

    include RDF_Durable
  end
end
