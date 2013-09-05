# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/nquads'
require 'rdf/spec/format'
require 'rdf/spec/reader'
require 'rdf/spec/writer'

describe RDF::NQuads::Format do
  before(:each) do
    @format_class = RDF::NQuads::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  include RDF_Format

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {:file_name      => 'etc/doap.nq'},
      {:file_extension => 'nq'},
      {:content_type   => 'application/n-quads'},
      {:content_type   => 'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Format.for(arg).should == @format_class
      end
    end

    {
      :nquads => "<a> <b> <c> <d> . ",
      :literal => '<a> <b> "literal" <d> .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n <d>\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.for {str}.should == @format_class
      end
    end

    {
      :ntriples => "<a> <b> <c> .",
      :nt_literal => '<a> <b> "literal" .',
      :nt_multi_line => %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "does not detect #{sym}" do
        @format_class.for {str}.should_not == @format_class
      end
    end
  end

  describe "#to_sym" do
    specify {@format_class.to_sym.should == :nquads}
  end

  describe "#name" do
    specify {@format_class.name.should == "N-Quads"}
  end

  describe ".detect" do
    {
      :nquads => "<a> <b> <c> <d> . ",
      :literal => '<a> <b> "literal" <d> .',
      :bnode => '<a> <b> "literal" _:graph .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n <d> .),
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.detect(str).should be_true
      end
    end

    {
      :ntriples  => "<a> <b> <c> .",
      :turtle    => "@prefix foo: <bar> .\n foo:a foo:b <c> .",
      :trig      => "{<a> <b> <c> .}",
      :rdfxml    => '<rdf:RDF about="foo"></rdf:RDF>',
      :n3        => '@prefix foo: <bar> .\nfoo:bar = {<a> <b> <c>} .',
      :jsonld    => '{"@context" => "foo"}',
      :rdfa      => '<div about="foo"></div>',
      :microdata => '<div itemref="bar"></div>',
    }.each do |sym, str|
      it "does not detect #{sym}" do
        @format_class.detect(str).should be_false
      end
    end
  end
end

describe RDF::NQuads::Reader do
  let(:testfile) {fixture_path('test.nq')}

  before(:each) do
    @reader_class = RDF::NQuads::Reader
    @reader = RDF::NQuads::Reader.new
  end
  
  # @see lib/rdf/spec/reader.rb in rdf-spec
  include RDF_Reader

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {:file_name      => 'etc/doap.nq'},
      {:file_extension => 'nq'},
      {:content_type   => 'application/n-quads'},
      {:content_type   => 'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Reader.for(arg).should == RDF::NQuads::Reader
      end
    end
  end

  context "when created" do
    it "should accept files" do
      expect { @reader_class.new(File.open(testfile)) }.to_not raise_error
    end

    it "should accept IO streams" do
      expect { @reader_class.new(StringIO.new('')) }.to_not raise_error
    end

    it "should accept strings" do
      expect { @reader_class.new('') }.to_not raise_error
    end
  end

  context "#initialize" do
    before :all do
      @testfile = fixture_path('test.nt')
    end

    it "should accept files" do
      expect { @reader_class.new(File.open(@testfile)) }.to_not raise_error
    end

    it "should accept IO streams" do
      expect { @reader_class.new(StringIO.new('')) }.to_not raise_error
    end

    it "should accept strings" do
      expect { @reader_class.new('') }.to_not raise_error
    end
  end

  context "with simple triples" do
    [
      ['<a> <b> <c> .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"))],
      ['<a> <b> _:c .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::Node.new("c"))],
      ['<a> <b> "c" .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::Literal("c"))],
      ['_:a <b> <c> .', RDF::Statement.new(RDF::Node.new("a"), RDF::URI("b"), RDF::URI("c"))],
    ].each do |(str, statement)|
      it "parses #{str.inspect}" do
        graph = RDF::Graph.new << @reader_class.new(str)
        graph.size.should == 1
        graph.statements.first.should == statement
      end
    end
  end
  
  context "with simple quads" do
    [
      ['<a> <b> <c> <d> .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::URI("d"))],
      ['<a> <b> <c> _:d .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::Node.new("d"))],
      ['<a> <b> <c> "d" .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::Literal("d"))],
    ].each do |(str, statement)|
      it "parses #{str.inspect}" do
        graph = RDF::Graph.new << @reader_class.new(str)
        graph.size.should == 1
        graph.statements.first.should == statement
      end
      
      it "serializes #{statement.inspect}" do
        RDF::NQuads.serialize(statement).chomp.should == str
      end
      
      it "unserializes #{str.inspect}" do
        RDF::NQuads.unserialize(str).should == statement
      end
    end
  end

  it "should parse W3C's test data" do
    @reader_class.new(File.open(testfile)).to_a.size.should == 10
  end
end

describe RDF::NQuads::Writer do
  before(:each) do
    @writer_class = RDF::NQuads::Writer
    @writer = RDF::NQuads::Writer.new
  end

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {:file_name      => 'etc/doap.nq'},
      {:file_extension => 'nq'},
      {:content_type   => 'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Writer.for(arg).should == RDF::NQuads::Writer
      end
    end
  end
  
  # @see lib/rdf/spec/writer.rb in rdf-spec
  include RDF_Writer
  
  context "#initialize" do
    describe "writing statements" do
      context "with simple triples" do
        [
          ['<a> <b> <c> .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"))],
          ['<a> <b> _:c .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::Node.new("c"))],
          ['<a> <b> "c" .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::Literal("c"))],
          ['_:a <b> <c> .', RDF::Statement.new(RDF::Node.new("a"), RDF::URI("b"), RDF::URI("c"))],
        ].each do |(str, statement)|
          it "writes #{str.inspect}" do
            @writer_class.buffer {|w| w << statement}.should == "#{str}\n"
          end
        end
      end

      context "with simple quads" do
        [
          ['<a> <b> <c> <d> .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::URI("d"))],
          ['<a> <b> <c> _:d .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::Node.new("d"))],
          ['<a> <b> <c> "d" .', RDF::Statement.new(RDF::URI("a"), RDF::URI("b"), RDF::URI("c"), :context => RDF::Literal("d"))],
        ].each do |(str, statement)|
          it "writes #{str.inspect}" do
            @writer_class.buffer {|w| w << statement}.should == "#{str}\n"
          end
        end
      end
    end
  end


  context "validataion" do
    it "defaults validation to true" do
      expect(subject).to be_validate
    end

    shared_examples "validation" do |statement, valid|
      context "given #{statement}" do
        let(:graph) {RDF::Repository.new << statement}
        subject {RDF::NTriples::Writer.buffer(:validate => true) {|w| w << graph}}
        if valid
          specify {expect {subject}.not_to raise_error}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end
    {
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF::Node("node")) => true,
      RDF::Statement.new(RDF::Node("node"), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Node("node"), :context => RDF.to_uri) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Literal("literal"), :context => RDF.to_uri) => true,
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(nil, RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, nil, :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self"), :context => RDF.to_uri) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self"), :context => RDF::Literal("literal")) => false,
    }.each do |st, valid|
      include_examples "validation", st, valid
    end
  end

  # Fixme, these should go in rdf/spec/writer.rb
  context "c14n" do
    shared_examples "c14n" do |statement, result|
      context "given #{statement}" do
        let(:graph) {RDF::Graph.new << statement}
        subject {RDF::NTriples::Writer.buffer(:validate => false, :canonicalize => true) {|w| w << graph}}
        if result
          specify {expect(subject).to eq "#{result}\n"}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end
    {
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::Literal("literal")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::Literal("literal")),
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI('file:///path/to/file%20with%20spaces.txt'), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(nil, RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, nil) => nil,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => nil,
    }.each do |st, result|
      include_examples "c14n", st, result
    end
  end

  context "Examples" do
    it "needs specs for documentation examples"
  end
end
