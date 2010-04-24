require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'

describe RDF::NTriples do
  before :all do
    @testfile = fixture 'test.nt'
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
      lambda { @reader.new(StringIO.new('')) }.should_not raise_error
    end

    it "should accept strings" do
      lambda { @reader.new('') }.should_not raise_error
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

    it "should parse terms" do
      bnode = @reader.unserialize('_:foobar')
      bnode.should_not be_nil
      bnode.should be_a_node
      bnode.id.should == 'foobar'

      uri = @reader.unserialize('<http://ar.to/#self>')
      uri.should_not be_nil
      uri.should be_a_uri
      uri.to_s.should == 'http://ar.to/#self'

      hello = @reader.unserialize('"Hello"')
      hello.should_not be_nil
      hello.should be_a_literal
      hello.value.should == 'Hello'

      stmt = @reader.unserialize("<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .")
      stmt.should_not be_nil
      stmt.should be_a_statement
    end
  end

  context "when writing" do
    before :all do
      s = RDF::URI.parse("http://rubygems.org/gems/rdf")
      p = RDF::DC.creator
      o = RDF::URI.parse("http://ar.to/#self")
      @stmt = RDF::Statement.new(s, p, o)
      @stmt_string = "<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."
      @graph = RDF::Graph.new
      @graph << @stmt
    end

    it "should correctly format statements" do
      @writer.new.format_statement(@stmt).should == @stmt_string
    end

    it "should correctly format blank nodes" do
      @writer.new.format_node(RDF::Node.new('foobar')).should == '_:foobar'
    end

    it "should correctly format URI references" do
      @writer.new.format_uri(RDF::URI.new('http://rdf.rubyforge.org/')).should == '<http://rdf.rubyforge.org/>'
    end

    it "should correctly format plain literals" do
      @writer.new.format_literal(RDF::Literal.new('Hello, world!')).should == '"Hello, world!"'
    end

    it "should correctly format language-tagged literals" do
      @writer.new.format_literal(RDF::Literal.new('Hello, world!', :language => :en)).should == '"Hello, world!"@en'
    end

    it "should correctly format datatyped literals" do
      @writer.new.format_literal(RDF::Literal.new(3.1415)).should == '"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>'
    end

    it "should output statements to a string buffer" do
      output = @writer.buffer { |writer| writer << @stmt }
      output.should == "#{@stmt_string}\n"
    end

    it "should dump statements to a string buffer" do
      output = StringIO.new
      @writer.dump(@graph, output)
      output.string.should == "#{@stmt_string}\n"
    end

    it "should dump arrays of statements to a string buffer" do
      output = StringIO.new
      @writer.dump(@graph.to_a, output)
      output.string.should == "#{@stmt_string}\n"
    end

    it "should dump statements to a file" do
      require 'tmpdir' # for Dir.tmpdir
      @writer.dump(@graph, filename = File.join(Dir.tmpdir, "test.nt"))
      File.read(filename).should == "#{@stmt_string}\n"
      File.unlink(filename)
    end
  end
end
