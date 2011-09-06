require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'fileutils'

describe 'README' do
  before :each do
    @stdout, $stdout = $stdout, StringIO.new
    @olddir, @tmpdir = Dir.pwd, File.join(File.dirname(__FILE__), '..', 'tmp')
    FileUtils.mkdir_p(@tmpdir)
    Dir.chdir(@tmpdir)
  end

  after :each do
    $stdout = @stdout
    Dir.chdir(@olddir)
  end

  context "the 'Writing RDF data using the N-Triples format' example" do
    after(:each) { File.delete('hello.nt') }

    def example1
      require 'rdf/ntriples'

      RDF::Writer.open("hello.nt") do |writer|
        writer << RDF::Graph.new do |graph|
          graph << [:hello, RDF::DC.title, "Hello, world!"]
        end
      end
    end

    it "should not raise errors" do
      lambda { example1 }.should_not raise_error
    end

    before(:each) { example1 }

    it "should not have output" do
      $stdout.string.lines.to_a.should be_empty
    end

    it "should produce a hello.nt file" do
      File.should exist('hello.nt')
      File.stat('hello.nt').should be_file
    end

    it "should produce the expected data" do
      File.read('hello.nt').should == %Q(_:hello <http://purl.org/dc/terms/title> "Hello, world!" .\n)
    end
  end

  context "the 'Reading RDF data in the N-Triples format' example" do
    def example2
      require 'rdf/ntriples'

      RDF::NTriples::Reader.open("http://rdf.rubyforge.org/doap.nt") do |reader|
        reader.each_statement do |statement|
          puts statement.inspect
        end
      end
    end

    it "should not raise errors" do
      lambda { example2 }.should_not raise_error
    end

    before(:each) { example2 }

    it "should have output" do
      $stdout.string.lines.to_a.should_not be_empty
    end

    it "should output inspected statements" do
      $stdout.string.each_line do |line|
        line.should match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
      end
    end
  end

  context "the 'Writing RDF data using the N-Quads format' example" do
    after(:each) { File.delete('hello.nq') }

    def example3
      require 'rdf/nquads'

      RDF::Writer.open("hello.nq") do |writer|
        writer << RDF::Repository.new do |repo|
          repo << RDF::Statement.new(:hello, RDF::DC.title, "Hello, world!", :context => RDF::URI("context"))
        end
      end
    end

    it "should not raise errors" do
      lambda { example3 }.should_not raise_error
    end

    before(:each) { example3 }

    it "should not have output" do
      $stdout.string.lines.to_a.should be_empty
    end

    it "should produce a hello.nq file" do
      File.should exist('hello.nq')
      File.stat('hello.nq').should be_file
    end

    it "should produce the expected data" do
      File.read('hello.nq').should == %Q(_:hello <http://purl.org/dc/terms/title> "Hello, world!" <context> .\n)
    end
  end

  context "the 'Reading RDF data in the N-Quads format' example" do
    def example4
      require 'rdf/nquads'

      # FIXME: replace with "http://rdf.rubyforge.org/doap.nq"
      RDF::NQuads::Reader.open(File.join(File.dirname(__FILE__), "..", "etc", "doap.nq")) do |reader|
        reader.each_statement do |statement|
          puts statement.inspect
        end
      end
    end

    it "should not raise errors" do
      lambda { example4 }.should_not raise_error
    end

    before(:each) { example4 }

    it "should have output" do
      $stdout.string.lines.to_a.should_not be_empty
    end

    it "should output inspected statements" do
      $stdout.string.each_line do |line|
        line.should match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
      end
    end
  end

  context "the 'Using pre-defined RDF vocabularies' example" do
    include RDF

    def example3
      DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
      FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
      RDF.type      #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
      RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
      RSS.title     #=> RDF::URI("http://purl.org/rss/1.0/title")
      OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
      XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
    end

    it "should not raise errors" do
      lambda { example3 }.should_not raise_error
    end

    before(:each) { example3 }

    # TODO
  end

  context "the 'Using ad-hoc RDF vocabularies' example" do
    def example4
      foaf = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
      foaf.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
      foaf[:name]   #=> RDF::URI("http://xmlns.com/foaf/0.1/name")
      foaf['mbox']  #=> RDF::URI("http://xmlns.com/foaf/0.1/mbox")
    end

    it "should not raise errors" do
      lambda { example4 }.should_not raise_error
    end

    before(:each) { example4 }

    # TODO
  end
end
