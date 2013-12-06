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
        it {expect {code.call}.not_to raise_error}
        it "should not have output" do
          expect($stdout.string.lines.to_a).to be_empty
        end
        it "should produce a hello.nt file" do
          expect(File).to exist('hello.nt')
          expect(File.stat('hello.nt')).to be_file
        end

        it "should produce the expected data" do
          expect(File.read('hello.nt')).to eq %Q(_:hello <http://purl.org/dc/terms/title> "Hello, world!" .\n)
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
        before(:each) {
          if example == :example0
            expect(RDF::Util::File).to receive(:open_file).
              with("http://ruby-rdf.github.com/rdf/etc/doap.nt", {}).
              at_least(1).
              and_yield(Kernel.open(File.expand_path("../../etc/doap.nt", __FILE__)))
          end
          code.call
        }
        it {expect {code.call}.not_to raise_error}
        it "should have output" do
          expect($stdout.string.lines.to_a).to_not be_empty
        end
        it "should output inspected statements" do
          $stdout.string.each_line do |line|
            expect(line).to match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
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
        before(:each) {
          if example == :example0
            expect(RDF::Util::File).to receive(:open_file).
              with("http://ruby-rdf.github.com/rdf/etc/doap.nq", {:base_uri=>"http://ruby-rdf.github.com/rdf/etc/doap.nq", :format=>:nquads}).
              at_least(1).
              and_yield(Kernel.open(File.expand_path("../../etc/doap.nq", __FILE__)))
          end
          code.call
        }
        it {expect {code.call}.not_to raise_error}
        it "should have output" do
          expect($stdout.string.lines.to_a).to_not be_empty
        end
        it "should output inspected statements" do
          $stdout.string.each_line do |line|
            expect(line).to match(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
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
        it {expect {code.call}.not_to raise_error}
        it "should not have output" do
          expect($stdout.string.lines.to_a).to be_empty
        end
        it "should produce a hello.nq file" do
          expect(File).to exist('hello.nq')
          expect(File.stat('hello.nq')).to be_file
        end

        it "should produce the expected data" do
          expect(File.read('hello.nq')).to eq %Q(_:hello <http://purl.org/dc/terms/title> "Hello, world!" <context> .\n)
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
      expect { example3 }.not_to raise_error
    end

    before(:each) { example3 }

    # TODO
  end

  context "the 'Querying RDF data using basic graph patterns (BGPs)' example" do
    require 'rdf/ntriples'
    let(:graph) {RDF::Graph.load(File.expand_path("../../etc/doap.nt", __FILE__))}
    let(:query) do
      RDF::Query.new({
        :person => {
          RDF.type  => RDF::FOAF.Person,
          RDF::FOAF.name => :name,
          RDF::FOAF.mbox => :email,
        }
      })
    end

    context "using query" do
      subject {
        query.execute(graph) do |solution|
          puts "name=#{solution.name} email=#{solution.email}"
        end
        $stdout.string
      }

      it {should =~ /name=Arto Bendiken/}
      it {should =~ /name=Ben Lavender/}
      it {should =~ /name=Gregg Kellogg/}
      it {should =~ /email=/}
    end

    context "using graph" do
      subject {
        graph.query(query) do |solution|
          puts "name=#{solution.name} email=#{solution.email}"
        end
        $stdout.string
      }

      it {should =~ /name=Arto Bendiken/}
      it {should =~ /name=Ben Lavender/}
      it {should =~ /name=Gregg Kellogg/}
      it {should =~ /email=/}
    end
  end

  context "the 'Using ad-hoc RDF vocabularies' example" do
    {
      :method => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/").knows},
      :symbol => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")[:knows]},
      :string => lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")['knows']}
    }.each do |example, code|
      context example do
        it {expect {code.call}.not_to raise_error}
        it {expect(code.call).to eq RDF::FOAF.knows}
      end
    end
  end
end
