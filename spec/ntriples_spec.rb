require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'

describe RDF::NTriples do
  before :all do
    @testfile = File.join(File.dirname(__FILE__),"data","test.nt")
  end

  before :each do
    @reader = RDF::NTriples::Reader
    @writer = RDF::NTriples::Writer
  end

  context "when created" do
    it "should accept files" do
      lambda { @reader.new(File.open(@testfile)) }.should_not raise_error
    end

    it "should accept IO streams" do
      lambda { @reader.new(StringIO.new("")) }.should_not raise_error
    end

    it "should accept strings" do
      lambda { @reader.new("") }.should_not raise_error
    end
  end

  context "when reading" do
    it "should parse empty lines" do
      ["\n", "\r\n", "\r"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines" do
      ["#\n", "# \n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines preceded by whitespace" do
      ["\t#\n", " #\n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse W3C's test data" do
      lambda { @reader.new(File.open(@testfile)).to_a.size.should == 30 }.should_not raise_error # FIXME
    end
  end

  context "when writing" do
    before :all do
      s = RDF::URI.parse("http://gemcutter.org/gems/rdf")
      p = RDF::DC.creator
      o = RDF::URI.parse("http://ar.to/#self")
      @stmt = RDF::Statement.new(s, p, o)
      @stmt_string = "<http://gemcutter.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .\n"
    end

    it "should output a statement to a string buffer" do
      output = @writer.buffer do |writer|
        writer << @stmt
      end
      output.should == @stmt_string
    end

  end
end
