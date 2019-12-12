# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'fileutils'

describe 'README' do
  around(:example) do |example|
    tmpdir = File.join(File.dirname(__FILE__), '..', 'tmp')
    FileUtils.mkdir_p(tmpdir)
    Dir.chdir(tmpdir, &example)
  end

  context "the 'Writing RDF data using the N-Triples format' example" do
    after(:each) { File.delete('hello.nt') }

    {
      example1: lambda {
        require 'rdf/ntriples'

        RDF::Writer.open("hello.nt") do |writer|
          writer << RDF::Graph.new do |graph|
            graph << [:hello, RDF::RDFS.label, "Hello, world!"]
          end
        end
      },
      example2: lambda {
        require 'rdf/ntriples'
        graph = RDF::Graph.new << [:hello, RDF::RDFS.label, "Hello, world!"]
        File.open("hello.nt", "w") {|f| f << graph.dump(:ntriples)}
      }
    }.each do |example, code|
      context example do
        before(:each) {code.call}
        it {expect {code.call}.not_to raise_error}
        it "should not have output" do
          expect {code.call}.not_to write.to(:error)
        end
        it "should produce a hello.nt file" do
          expect(File).to exist('hello.nt')
          expect(File.stat('hello.nt')).to be_file
        end

        it "should produce the expected data" do
          expect(File.read('hello.nt')).to eq %Q(_:hello <http://www.w3.org/2000/01/rdf-schema#label> "Hello, world!" .\n)
        end
      end
    end
  end

  context "the 'Reading RDF data in the N-Triples format' example" do
    {
      example0: lambda {
        require 'rdf/ntriples'
        RDF::NTriples::Reader.open("http://ruby-rdf.github.com/rdf/etc/doap.nt") do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      },
      example1: lambda {
        require 'rdf/ntriples'

        RDF::NTriples::Reader.open(File.expand_path("../../etc/doap.nt", __FILE__)) do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      }
    }.each do |example, code|
      context example do
        subject {
          if example == :example0
            expect(RDF::Util::File).to receive(:open_file).
              with("http://ruby-rdf.github.com/rdf/etc/doap.nt", hash_including(:headers)).
              at_least(1).
              and_yield(Kernel.open(File.expand_path("../../etc/doap.nt", __FILE__)))
          end
          code.call
        }
        it "should have output" do
          expect {subject}.to write(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
        end
      end
    end
  end

  context "the 'Reading RDF data in other formats' example" do
    {
      example0: lambda {
        require 'rdf/nquads'

        graph = RDF::Graph.load("http://ruby-rdf.github.com/rdf/etc/doap.nq", format: :nquads)
        graph.each_statement do |statement|
          puts statement.inspect
        end
      },
      example1: lambda {
        require 'rdf/nquads'

        RDF::NQuads::Reader.open(File.expand_path("../../etc/doap.nq", __FILE__)) do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      }
    }.each do |example, code|
      context example do
        subject {
          if example == :example0
            expect(RDF::Util::File).to receive(:open_file).
              with("http://ruby-rdf.github.com/rdf/etc/doap.nq", hash_including(:headers, base_uri: "http://ruby-rdf.github.com/rdf/etc/doap.nq")).
              at_least(1).
              and_yield(Kernel.open(File.expand_path("../../etc/doap.nq", __FILE__)))
          end
          code.call
        }
        it "should output inspected statements" do
          expect {subject}.to write(/^\#<RDF::Statement:0x[\da-fA-F]+\(.*?\)>\Z/)
        end
      end
    end
  end

  context "the 'Writing RDF data using other formats' example" do
    after(:each) { File.delete('hello.nq') }

    {
      example1: lambda {
        require 'rdf/nquads'

        RDF::Writer.open("hello.nq") do |writer|
          writer << RDF::Repository.new do |repo|
            repo << RDF::Statement.new(:hello, RDF::RDFS.label, "Hello, world!", graph_name: RDF::URI("http://example/context"))
          end
        end
      },
      example2: lambda {
        require 'rdf/nquads'
        repo = RDF::Repository.new << RDF::Statement.new(:hello, RDF::RDFS.label, "Hello, world!", graph_name: RDF::URI("http://example/context"))
        File.open("hello.nq", "w") {|f| f << repo.dump(:nquads)}
      },
    }.each do |example, code|
      context example do
        subject {code.call}
        it "should not have output" do
          expect {subject}.not_to write(:anything)
        end
        it "should produce a hello.nq file" do
          subject
          expect(File).to exist('hello.nq')
          expect(File.stat('hello.nq')).to be_file
        end

        it "should produce the expected data" do
          subject
          expect(File.read('hello.nq')).to eq %Q(_:hello <http://www.w3.org/2000/01/rdf-schema#label> "Hello, world!" <http://example/context> .\n)
        end
      end
    end
  end

  context "the 'Using pre-defined RDF vocabularies' example" do
    subject do
      RDF.type           #=> RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
      RDF::RDFS.seeAlso  #=> RDF::URI("http://www.w3.org/2000/01/rdf-schema#seeAlso")
      RDF::OWL.sameAs    #=> RDF::URI("http://www.w3.org/2002/07/owl#sameAs")
      RDF::XSD.dateTime  #=> RDF::URI("http://www.w3.org/2001/XMLSchema#dateTime")
    end

    it "should not raise errors" do
      expect { subject }.not_to raise_error
    end
  end

  context "the 'Querying RDF data using basic graph patterns (BGPs)' example" do
    require 'rdf/ntriples'
    let(:graph) {RDF::Graph.load(File.expand_path("../../etc/doap.nt", __FILE__))}
    let(:query) do
      RDF::Query.new({
        person: {
          RDF.type  => RDF::Vocab::FOAF.Person,
          RDF::Vocab::FOAF.name => :name,
          RDF::Vocab::FOAF.mbox => :email,
        }
      }, **{})
    end

    context "using query" do
      subject {
        query.execute(graph) do |solution|
          puts "name=#{solution.name} email=#{solution.email}"
        end
      }
      [
        "name=Arto Bendiken",
        "name=Ben Lavender",
        "name=Gregg Kellogg",
        "email="
      ].each do |re|
        specify { expect {subject}.to write(re)}
      end
    end

    context "using graph" do
      subject {
        graph.query(query) do |solution|
          puts "name=#{solution.name} email=#{solution.email}"
        end
      }

      [
        "name=Arto Bendiken",
        "name=Ben Lavender",
        "name=Gregg Kellogg",
        "email="
      ].each do |re|
        specify { expect {subject}.to write(re)}
      end
    end
  end

  context "the 'Using ad-hoc RDF vocabularies' example" do
    {
      method: lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/").knows},
      symbol: lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")[:knows]},
      string: lambda {RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")['knows']}
    }.each do |example, code|
      context example do
        it {expect {code.call}.not_to raise_error}
        it {expect(code.call).to eq RDF::Vocab::FOAF.knows}
      end
    end
  end
end
