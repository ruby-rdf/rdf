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
  it_should_behave_like RDF_Format

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {:file_name      => 'etc/doap.nq'},
      {:file_extension => 'nq'},
      {:content_type   => 'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Format.for(arg).should == @format_class
      end
    end

    {
      :ntriples => "<a> <b> <c> .",
      :nquads => "<a> <b> <c> <d> . ",
      :literal => '<a> <b> "literal" .',
      :multi_line => '<a>\n  <b>\n  "literal"\n .',
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.for {str}.should == @format_class
      end
    end
  end

  describe "#to_sym" do
    specify {@format_class.to_sym.should == :nquads}
  end

  describe ".detect" do
    {
      :ntriples => "<a> <b> <c> .",
      :nquads => "<a> <b> <c> <d> . ",
      :literal => '<a> <b> "literal" .',
      :multi_line => '<a>\n  <b>\n  "literal"\n .',
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.detect(str).should be_true
      end
    end

    {
      :turtle => "@prefix foo: <bar> .\n foo:a foo:b <c> .",
      :rdfxml => '<rdf:RDF about="foo"></rdf:RDF>',
      :n3 => '@prefix foo: <bar> .\nfoo:bar = {<a> <b> <c>} .',
    }.each do |sym, str|
      it "does not detect #{sym}" do
        @format_class.detect(str).should be_false
      end
    end
  end
end

describe RDF::NQuads::Reader do
  before(:each) do
    @reader_class = RDF::NQuads::Reader
    @reader = RDF::NQuads::Reader.new
  end
  
  # @see lib/rdf/spec/reader.rb in rdf-spec
  it_should_behave_like RDF_Reader

  describe ".for" do
    formats = [
      :nquads,
      'etc/doap.nq',
      {:file_name      => 'etc/doap.nq'},
      {:file_extension => 'nq'},
      {:content_type   => 'text/x-nquads'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Reader.for(arg).should == RDF::NQuads::Reader
      end
    end
  end

  context "#initialize" do
    before :all do
      @testfile = fixture_path('test.nt')
    end

    it "should accept files" do
      lambda { @reader_class.new(File.open(@testfile)) }.should_not raise_error
    end

    it "should accept IO streams" do
      lambda { @reader_class.new(StringIO.new('')) }.should_not raise_error
    end

    it "should accept strings" do
      lambda { @reader_class.new('') }.should_not raise_error
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
    end
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
  it_should_behave_like RDF_Writer
  
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
end
