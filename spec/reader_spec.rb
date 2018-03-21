# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'webmock/rspec'
require 'rdf/ntriples'
require 'rdf/nquads'
require 'rdf/turtle'

describe RDF::Reader do
  describe ".each" do
    it "enumerates formats having a reader" do
      expect(described_class.each.to_a).to include(RDF::NTriples::Reader, RDF::NQuads::Reader, RDF::Turtle::Reader)
    end

    it "does not include RDF::Reader" do
      expect(described_class.each.to_a & [RDF::Reader]).to be_empty
    end
  end

  describe ".for" do
    [
      :ntriples,
      'etc/doap.nt',
      {file_name:      'etc/doap.nt'},
      {file_extension: 'nt'},
      {content_type:   'application/n-triples'},
      {content_type:   'text/plain'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Reader.for(arg)).to eq RDF::NTriples::Reader
      end
    end
  end

  describe ".format" do
    it "returns nil if given no format" do
      expect(described_class.format).to be_nil
    end

    it "returns nil if given a format" do
      expect(described_class.format(:ntriples)).to be_nil
    end
  end

  describe ".open" do
    it "sets Accept header for all readers" do
      uri = "http://example/foo"
      accept = (RDF::Format.accept_types + %w(*/*;q=0.1)).join(", ")
      reader_mock = double("reader")
      expect(reader_mock).to receive(:got_here)
      WebMock.stub_request(:get, uri).with do |request|
        expect(request.headers['Accept']).to eql accept
      end.to_return(body: "foo")

      described_class.open(uri) do |r|
        expect(r).to be_a(described_class)
        reader_mock.got_here
      end
    end

    it "uses content type in preference to file extension" do
      uri = "http://example/foo.nq"
      accept = (RDF::Format.accept_types + %w(*/*;q=0.1)).join(", ")
      reader_mock = double("reader")
      expect(reader_mock).to receive(:got_here)
      WebMock.
        stub_request(:get, uri).
        to_return(body: "foo", status: 200, headers: { 'Content-Type' => 'text/turtle'})

      described_class.open(uri) do |r|
        expect(r).to be_a(RDF::Turtle::Reader)
        reader_mock.got_here
      end
    end

    it "ignores content type 'text/plain'" do
      uri = "http://example/foo.ttl"
      accept = (RDF::Format.accept_types + %w(*/*;q=0.1)).join(", ")
      reader_mock = double("reader")
      expect(reader_mock).to receive(:got_here)
      WebMock.
        stub_request(:get, uri).
        to_return(body: "foo", status: 200, headers: { 'Content-Type' => 'text/plain'})

      described_class.open(uri) do |r|
        expect(r).to be_a(RDF::Turtle::Reader)
        reader_mock.got_here
      end
    end
  end
end
