# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/nquads'
require 'rdf/spec/format'
require 'rdf/spec/reader'
require 'rdf/spec/writer'

describe RDF::NQuads::Format do
  # @see lib/rdf/spec/format.rb in rdf-spec
  it_behaves_like 'an RDF::Format' do
    let(:format_class) { described_class }
  end

  subject { described_class }

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {file_name:      'etc/doap.nq'},
      {file_extension: 'nq'},
      {content_type:   'application/n-quads'},
      {content_type:   'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Format.for(arg)).to eq subject
      end
    end

    {
      nquads: "<a> <b> <c> <d> . ",
      literal: '<a> <b> "literal" <d> .',
      bnode: %(<a> <b> "literal" _:d .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.detect(str)).to be_truthy
      end
    end

    {
      ntriples: "<a> <b> <c> .",
      nt_literal: '<a> <b> "literal" .',
      nt_multi_line: %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "does not detect #{sym}" do
        expect(subject.for {str}).not_to eq subject
      end
    end
  end

  describe "#to_sym" do
    specify {expect(subject.to_sym).to eq :nquads}
  end

  describe "#name" do
    specify {expect(subject.name).to eq "N-Quads"}
  end

  describe ".detect" do
    {
      nquads: "<a> <b> <c> <d> . ",
      literal: '<a> <b> "literal" <d> .',
      bnode: '<a> <b> "literal" _:graph .',
      multi_line: %(<a>\n  <b>\n  "literal"\n <d> .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.detect(str)).to be_truthy
      end
    end

    {
      ntriples:  "<a> <b> <c> .",
      turtle:    "@prefix foo: <bar> .\n foo:a foo:b <c> .",
      trig:      "{<a> <b> <c> .}",
      rdfxml:    '<rdf:RDF about="foo"></rdf:RDF>',
      n3:        '@prefix foo: <bar> .\nfoo:bar = {<a> <b> <c>} .',
      jsonld:    '{"@context" => "foo"}',
      rdfa:      '<div about="foo"></div>',
      microdata: '<div itemref="bar"></div>',
    }.each do |sym, str|
      it "does not detect #{sym}" do
        expect(subject.detect(str)).to be_falsey
      end
    end
  end
end

describe RDF::NQuads::Reader do
  let(:logger) {RDF::Spec.logger}

  let(:testfile) {fixture_path('test.nq')}
  let!(:test_count) {File.open(testfile).each_line.to_a.reject {|l| l.sub(/#.*$/, '').strip.empty?}.length}

  # @see lib/rdf/spec/reader.rb in rdf-spec
  it_behaves_like 'an RDF::Reader' do
    let(:reader) { RDF::NQuads::Reader.new }
    let(:reader_input) { File.read(testfile) }
    let(:reader_count) { test_count }
  end

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {file_name:      'etc/doap.nq'},
      {file_extension: 'nq'},
      {content_type:   'application/n-quads'},
      {content_type:   'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Reader.for(arg)).to eq RDF::NQuads::Reader
      end
    end
  end

  context "when created" do
    it "should accept files" do
      expect { described_class.new(File.open(testfile)) }.to_not raise_error
    end

    it "should accept IO streams" do
      expect { described_class.new(StringIO.new('')) }.to_not raise_error
    end

    it "should accept strings" do
      expect { described_class.new('') }.to_not raise_error
    end
  end

  context "#initialize" do
    before :all do
      @testfile = fixture_path('test.nt')
    end

    it "should accept files" do
      expect { described_class.new(File.open(@testfile)) }.to_not raise_error
    end

    it "should accept IO streams" do
      expect { described_class.new(StringIO.new('')) }.to_not raise_error
    end

    it "should accept strings" do
      expect { described_class.new('') }.to_not raise_error
    end
  end

  context "with simple triples" do
    [
      ['<a> <b> <c> .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"))],
      ['<a> <b> _:c .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::Node.new("c"))],
      ['<a> <b> "c" .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::Literal("c"))],
      ['_:a <b> <c> .', RDF::Statement(RDF::Node.new("a"), RDF::URI("b"), RDF::URI("c"))],
    ].each do |(str, statement)|
      it "parses #{str.inspect}" do
        graph = RDF::Graph.new << described_class.new(str)
        expect(graph.size).to eq 1
        expect(graph.statements.first).to eq statement
      end
    end
  end

  context "with simple quads" do
    [
      ['<a> <b> <c> <d> .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), graph_name: RDF::URI("d"))],
      ['<a> <b> <c> _:d .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), graph_name: RDF::Node.new("d"))],
      ['<a> <b> <c> "d" .', RDF::Statement(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), graph_name: RDF::Literal("d"))],
    ].each do |(str, statement)|
      it "parses #{str.inspect}" do
        graph = RDF::Graph.new << described_class.new(str)
        expect(graph.size).to eq 1
        expect(graph.statements.first).to eq statement
      end

      it "serializes #{statement.inspect}" do
        expect(RDF::NQuads.serialize(statement).chomp).to eq str
      end

      it "unserializes #{str.inspect}" do
        expect(RDF::NQuads.unserialize(str)).to eq statement
      end
    end
  end

  it "should parse W3C's test data" do
    expect(described_class.new(File.open(testfile)).to_a.size).to eq 19
  end
end

describe RDF::NQuads::Writer do
  let(:logger) {RDF::Spec.logger}
  subject { RDF::NQuads::Writer.new }

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {file_name:      'etc/doap.nq'},
      {file_extension: 'nq'},
      {content_type:   'application/n-quads'},
     {content_type:   'text/x-nquads'},
     ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Writer.for(arg)).to eq RDF::NQuads::Writer
      end
    end
  end

  # @see lib/rdf/spec/writer.rb in rdf-spec
  it_behaves_like 'an RDF::Writer' do
    let(:writer) { RDF::NQuads::Writer.new }
  end

  context "#initialize" do
    describe "writing statements" do
      context "with simple triples" do
        [
          ['<http://example/a> <http://example/b> <http://example/c> .', RDF::Statement(RDF::URI("http://example/a"), RDF::URI("http://example/b"), RDF::URI("http://example/c"))],
          ['<http://example/a> <http://example/b> _:c .', RDF::Statement(RDF::URI("http://example/a"), RDF::URI("http://example/b"), RDF::Node.new("c"))],
          ['<http://example/a> <http://example/b> "c" .', RDF::Statement(RDF::URI("http://example/a"), RDF::URI("http://example/b"), RDF::Literal("c"))],
          ['_:a <http://example/b> <http://example/c> .', RDF::Statement(RDF::Node("a"), RDF::URI("http://example/b"), RDF::URI("http://example/c"))],
        ].each do |(str, statement)|
          it "writes #{str.inspect}" do
            expect(described_class.buffer {|w| w << statement}).to eq "#{str}\n"
          end
        end
      end

      context "with simple quads" do
        [
          ['<http://example/a> <http://example/b> <http://example/c> <http://example/d> .', RDF::Statement(RDF::URI("http://example/a"), RDF::URI("http://example/b"), RDF::URI("http://example/c"), graph_name: RDF::URI("http://example/d"))],
          ['<http://example/a> <http://example/b> <http://example/c> _:d .', RDF::Statement(RDF::URI("http://example/a"), RDF::URI("http://example/b"), RDF::URI("http://example/c"), graph_name: RDF::Node.new("d"))],
        ].each do |(str, statement)|
          it "writes #{str.inspect}" do
            expect(described_class.buffer {|w| w << statement}).to eq "#{str}\n"
          end
        end
      end
    end
  end

  context "Writing a Graph" do
    let(:graph) {
      g = RDF::Graph.new
      g << [RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o1')]
      g << [RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o2'), RDF::URI('http://example/c')]
      g
    }
    it "#insert" do
      expect { described_class.new.insert(graph) }
        .to write_each("<http://example/s> <http://example/p> <http://example/o1> .\n",
                       "<http://example/s> <http://example/p> <http://example/o2> .\n")
    end
  end

  context "Writing a Statements" do
    let(:statements) {[
      RDF::Statement(RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o1')),
      RDF::Statement(RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o2'))
    ]}
    it "#insert" do
      expect { described_class.new.insert(*statements) }
        .to write_each("<http://example/s> <http://example/p> <http://example/o1> .\n",
                       "<http://example/s> <http://example/p> <http://example/o2> .\n")
    end
  end

  context "Nodes" do
    let(:statement) {RDF::Statement(RDF::Node("a"), RDF.type, RDF::Node("b"), graph_name: RDF::Node("c"))}
    it "uses node lables by default" do
      expect(described_class.buffer {|w| w << statement}).to match %r(_:a <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> _:b _:c \.)
    end

    it "uses unique labels if :unique_bnodes is true" do
      expect(described_class.buffer(unique_bnodes:true) {|w| w << statement}).to match %r(_:g\w+ <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> _:g\w+ _:g\w+ \.)
    end
  end

  context "validataion" do
    it "defaults validation to be true" do
      expect(subject).to be_validate
    end

    shared_examples "validation" do |statement, valid|
      context "given #{statement}" do
        subject {RDF::NTriples::Writer.buffer(validate: true, logger: logger) {|w| w << statement}}
        if valid
          specify {expect {subject}.not_to raise_error}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end

    {
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => true,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF::Node("node")) => true,
      RDF::Statement(RDF::Node("node"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => true,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Node("node"), graph_name: RDF.to_uri) => true,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal"), graph_name: RDF.to_uri) => true,
      RDF::Statement(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(nil, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil, graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF::Literal("literal")) => false,
      RDF::Statement(RDF::URI('scheme://auth/\\u0000'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI('scheme://auth/^'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI('scheme://auth/`'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
      RDF::Statement(RDF::URI('scheme://auth/\\'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self"), graph_name: RDF.to_uri) => false,
    }.each do |st, valid|
      include_examples "validation", st, valid
    end
  end

  # Fixme, these should go in rdf/spec/writer.rb
  context "c14n" do
    shared_examples "c14n" do |statement, result|
      context "given #{statement}" do
        subject {RDF::NTriples::Writer.buffer(validate: true, canonicalize: true, logger: logger) {|w| w << statement}}
        if result
          specify {expect(subject).to eq "#{result}\n"}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end

    {
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::Literal("literal")) =>
        RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::Literal("literal")),
      RDF::Statement(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement(RDF::URI('file:///path/to/file%20with%20spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement(nil, RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator").dup, nil) => nil,
      RDF::Statement(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => nil,
    }.each do |st, result|
      include_examples "c14n", st, result
    end
  end

  context "Examples" do
    it "Obtaining an NQuads format class" do
      [
        :nquads,
        "etc/doap.nq",
        {file_name: "etc/doap.nq"},
        {file_extension: "nq"},
        {content_type: "application/n-quads"}
      ].each do |arg|
        expect(RDF::Format.for(arg)).to eql RDF::NQuads::Format
      end
    end
  end
end
