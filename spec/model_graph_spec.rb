require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Graph do
  describe ".load" do
    it "creates an unnamed graph" do
      expect(described_class).to receive(:new).with(:base_uri => "http://example/")
      described_class.load("http://example/", :base_uri => "http://example/")
    end

    it "loads into an unnamed graph" do
      expect_any_instance_of(described_class).to receive(:load).with("http://example/", :base_uri => "http://example/")
      described_class.load("http://example/", :base_uri => "http://example/")
    end
  end

  context "unnamed graphs" do
    subject {described_class.new}

    it "should be instantiable" do
      expect { subject }.not_to raise_error
    end

    it "should be unnamed" do
      expect(subject).to be_unnamed
      expect(subject).not_to be_named
    end

    it "should not have a context" do
      expect(subject.context).to be_nil
      expect(subject.contexts.size).to eq 0
    end
  end

  context "named graphs" do
    subject {
      described_class.new("http://ruby-rdf.github.com/rdf/etc/doap.nt", :data => RDF::Repository.new)
    }
    it "should be instantiable" do
      expect { subject }.to_not raise_error
    end

    it "should not be instantiable by default" do
      expect { described_class.new("http://rubygems.org/gems/rdf") }.to raise_error(ArgumentError)
    end

    its(:named?) {is_expected.to be_truthy}
    its(:unnamed?) {is_expected.to be_falsey}
    its(:name) {is_expected.not_to be_nil}
    its(:context) {is_expected.not_to be_nil}
    its(:contexts) {expect(subject.contexts.size).to eq 1}
    it {is_expected.not_to be_anonymous}

    context "with anonymous context" do
      subject {described_class.new(RDF::Node.new, :data => RDF::Repository.new)}
      it {is_expected.to be_anonymous}
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
      graph = described_class.new(nil, :data => repo)
      expect(graph.count).to eq 1
      expect(graph.statements.first.object).to eq RDF::URI('o1')
    end

    it "should access named graph" do
      graph = described_class.new(RDF::URI('c'), :data => repo)
      expect(graph.count).to eq 1
      expect(graph.statements.first.object).to eq RDF::URI('o2')
    end

    it "should not load! default graph" do
      graph = described_class.new(nil, :data => repo)
      expect {graph.load!}.to raise_error(ArgumentError)
    end

    it "should reload named graph" do
      graph = described_class.new(RDF::URI("http://example/doc.nt"), :data => repo)
      expect(graph).to receive(:load).with("http://example/doc.nt", :base_uri => "http://example/doc.nt")
      graph.load!
    end
  end

  it "should maintain arbitrary options" do
    graph = described_class.new(nil, :foo => :bar)
    expect(graph.options).to include(:foo => :bar)
  end

  context "as repository" do
    require 'rdf/spec/repository'

    it_behaves_like 'an RDF::Repository' do
      let(:repository) { RDF::Graph.new }
    end
  end

  context "Examples" do
    require 'rdf/rdfxml'

    let(:graph) {described_class.new}

    it "Creating an empty unnamed graph" do
      expect {described_class.new}.not_to raise_error
    end

    it "Creating an empty named graph" do
      expect {described_class.new("http://rubygems.org/", :data => RDF::Repository.new)}.not_to raise_error
    end

    it "Loading graph data from a URL (1)" do
      expect(RDF::Util::File).to receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = described_class.new("http://www.bbc.co.uk/programmes/b0081dq5.rdf", :data => RDF::Repository.new)
      graph.load!
      expect(graph).not_to be_empty
    end

    it "Loading graph data from a URL (2)" do
      expect(RDF::Util::File).to receive(:open_file).
        with("http://www.bbc.co.uk/programmes/b0081dq5.rdf", an_instance_of(Hash)).
        and_yield(File.open(File.expand_path("../data/programmes.rdf", __FILE__)))
      graph = described_class.load("http://www.bbc.co.uk/programmes/b0081dq5.rdf")
      expect(graph).not_to be_empty
    end
  end
end
