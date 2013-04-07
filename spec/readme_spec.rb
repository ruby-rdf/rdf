require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'fileutils'

describe 'README' do
  before :each do
    @stdout, $stdout = $stdout, StringIO.new
    @olddir, @tmpdir = Dir.pwd, File.join(File.dirname(__FILE__), '..', 'tmp')
    FileUtils.mkdir_p(@tmpdir)
    Dir.chdir(@tmpdir) # FIXME: chdir causing warnings
  end

  after :each do
    $stdout = @stdout
    Dir.chdir(@olddir) # FIXME: chdir causing warnings
  end

  context "the 'Writing RDF data using the N-Triples format' example" do
    after(:each) { File.delete('hello.nt') }

    {
      :example1 => lambda {
        require 'rdf/ntriples'

        RDF::Writer.open("hello.nt") do |writer|
          writer << RDF::Graph.new do |graph|
            graph << [:hello, RDF::DC.title, "Hello, world!"]
          end
        end
      },
      :example2 => lambda {
        require 'rdf/ntriples'
        graph = RDF::Graph.new << [:hello, RDF::DC.title, "Hello, world!"]
        File.open("hello.nt", "w") {|f| f << graph.dump(:ntriples)}
      }
    }.each do |example, code|
      context example do
        before(:each) {code.call}
        it {lambda {code.call}.should_not raise_error}
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
    end
  end

  context "the 'Reading RDF data in the N-Triples format' example" do
    {
      :example0 => lambda {
        require 'rdf/ntriples'

        RDF::NTriples::Reader.open("http://ruby-rdf.github.com/rdf/etc/doap.nt") do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      },
      :example1 => lambda {
        require 'rdf/ntriples'

        RDF::NTriples::Reader.open(File.expand_path("../../etc/doap.nt", __FILE__)) do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      }
    }.each do |example, code|
      context example do
        before(:each) {code.call}
        it {lambda {code.call}.should_not raise_error}
        it "should have output" do
          $stdout.string.lines.to_a.should_not be_empty
        end
        it "should output inspected statements" do
          $stdout.string.each_line do |line|
            line.should match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
          end
        end
      end
    end
  end

  context "the 'Reading RDF data in other formats' example" do
    {
      :example0 => lambda {
        require 'rdf/nquads'

        graph = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nq", :format => :nquads)
        graph.each_statement do |statement|
          puts statement.inspect
        end
      },
      :example1 => lambda {
        require 'rdf/nquads'

        RDF::NQuads::Reader.open(File.expand_path("../../etc/doap.nq", __FILE__)) do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      }
    }.each do |example, code|
      context example do
        before(:each) {code.call}
        it {lambda {code.call}.should_not raise_error}
        it "should have output" do
          $stdout.string.lines.to_a.should_not be_empty
        end
        it "should output inspected statements" do
          $stdout.string.each_line do |line|
            line.should match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
          end
        end
      end
    end
  end

  context "the 'Writing RDF data using other formats' example" do
    after(:each) { File.delete('hello.nq') }

    {
      :example1 => lambda {
        require 'rdf/nquads'

        RDF::Writer.open("hello.nq") do |writer|
          writer << RDF::Repository.new do |repo|
            repo << RDF::Statement.new(:hello, RDF::DC.title, "Hello, world!", :context => RDF::URI("context"))
          end
        end
      },
      :example2 => lambda {
        require 'rdf/nquads'
        repo = RDF::Repository.new << RDF::Statement.new(:hello, RDF::DC.title, "Hello, world!", :context => RDF::URI("context"))
        File.open("hello.nq", "w") {|f| f << repo.dump(:nquads)}
      },
    }.each do |example, code|
      context example do
        before(:each) {code.call}
        it {lambda {code.call}.should_not raise_error}
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
    end
  end

  context "the 'Using pre-defined RDF vocabularies' example" do
    def example3
      RDF::DC.title      #=> RDF::URI("http://purl.org/dc/terms/title")
      RDF::FOAF.knows    #=> RDF::URI("http://xmlns.com/foaf/0.1/knows")
      RDF.type           #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
      RDF::RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
      RDF::RSS.title     #=> RDF::URI("http://purl.org/rss/1.0/title")
      RDF::OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
      RDF::XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
    end

    it "should not raise errors" do
      lambda { example3 }.should_not raise_error
    end

    before(:each) { example3 }

    # TODO
  end

  context "the 'Querying RDF data using basic graph patterns (BGPs)' example" do
    before(:each) do
      require 'rdf/ntriples'
    
      graph = RDF::Graph.load(File.expand_path("../../etc/doap.nt", __FILE__))
      query = RDF::Query.new({
        :person => {
          RDF.type  => RDF::FOAF.Person,
          RDF::FOAF.name => :name,
          RDF::FOAF.mbox => :email,
        }
      })
    
      query.execute(graph).each do |solution|
        puts "name=#{solution.name} email=#{solution.email}"
      end
    end
    
    subject {$stdout.string}

    it {should =~ /name=Arto Bendiken/}
    it {should =~ /name=Ben Lavender/}
    it {should =~ /name=Gregg Kellogg/}
    it {should =~ /email=/}
  end

  context "the 'Using ad-hoc RDF vocabularies' example" do
    {
      :method => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/").knows},
      :symbol => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")[:knows]},
      :string => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")['knows']}
    }.each do |example, code|
      context example do
        it {lambda {code.call}.should_not raise_error}
        it {code.call.should == RDF::FOAF.knows}
      end
    end
  end
end
