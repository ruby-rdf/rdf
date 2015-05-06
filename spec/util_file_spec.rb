require File.join(File.dirname(__FILE__), 'spec_helper')
require 'webmock/rspec'
require 'rdf/ntriples'

describe RDF::Util::File do
  describe ".http_adapter" do
    after do
      RDF::Util::File.http_adapter = nil
    end

    it "returns Net::HTTP if rest-client is not available" do
      hide_const("RestClient")
      expect(RDF::Util::File.http_adapter).to eq RDF::Util::File::NetHttpAdapter
    end

    it "returns RestClient if rest-client is available" do
      require 'rest-client'
      expect(RDF::Util::File.http_adapter).to eq RDF::Util::File::RestClientAdapter
    end

    it "return Net::HTTP if explicitly requested" do
      require 'rest-client'
      expect(RDF::Util::File.http_adapter(true)).to eq RDF::Util::File::NetHttpAdapter
    end
  end

  describe RDF::Util::File::HttpAdapter do
    describe ".default_accept_header" do
      subject { RDF::Util::File::HttpAdapter.default_accept_header.split(", ") }
      before do
        allow(RDF::Format).to receive(:reader_types).and_return(["text/html", "text/plain", "application/xhtml+xml"])
      end
      it "should demote text/html to q=0.5" do
        expect(subject).to include "text/html;q=0.5"
      end
      it "should demote text/plain to q=0.5" do
        expect(subject).to include "text/plain;q=0.5"
      end
      it "should demote application/xhtml+xml to q=0.7" do
        expect(subject).to include "application/xhtml+xml;q=0.7"
      end
    end
  end

  describe RDF::Util::File::FaradayAdapter do
    let(:http_adapter) { RDF::Util::File::FaradayAdapter }
    require 'faraday'
    require 'faraday_middleware'

    describe ".conn=" do
      after do
        http_adapter.conn = nil
      end

      it "should set the Faraday connection" do
        custom_connection = Faraday.new
        http_adapter.conn = custom_connection
        expect(http_adapter.conn).to eq custom_connection
      end
    end

    describe ".conn" do
      it "should return a Faraday connection that follows redirects" do
        expect(http_adapter.conn.builder.handlers).to include FaradayMiddleware::FollowRedirects
      end
    end
  end

  describe ".open_file" do
    let(:uri) {"http://ruby-rdf.github.com/rdf/etc/doap.nt"}
    let(:opened) {double("opened")}
    before(:each) do
      expect(opened).to receive(:opened)
    end

    it "yields a local file" do
      r = RDF::Util::File.open_file(fixture_path("test.nt")) do |f|
        expect(f).to respond_to(:read)
        opened.opened
        RDF::Reader.new
      end
      expect(r).to be_a(RDF::Reader)
    end

    it "yields an RemoteDocument and returns yieldreturn" do
      WebMock.stub_request(:get, uri).
        to_return(body: File.read(File.expand_path("../../etc/doap.nt", __FILE__)),
                  status: 200,
                  headers: { 'Content-Type' => RDF::NTriples::Format.content_type.first})
      r = RDF::Util::File.open_file(uri) do |f|
        expect(f).to respond_to(:read)
        expect(f.content_type).to eq RDF::NTriples::Format.content_type.first
        expect(f.code).to eq 200
        opened.opened
        RDF::Reader.new
      end
      expect(r).to be_a(RDF::Reader)
    end

    it "yields a file URL" do
      r = RDF::Util::File.open_file("file:" + fixture_path("test.nt")) do |f|
        expect(f).to respond_to(:read)
        opened.opened
        RDF::Reader.new
      end
      expect(r).to be_a(RDF::Reader)
    end

    it "returns a local file" do
      f = RDF::Util::File.open_file(fixture_path("test.nt"))
      expect(f).to respond_to(:read)
      opened.opened
    end

    it "returns a file URL" do
      f = RDF::Util::File.open_file("file:" + fixture_path("test.nt"))
      expect(f).to respond_to(:read)
      opened.opened
    end
  end

  context "HTTP Adapters" do
    require 'rdf/spec/http_adapter'

    context "using Net::HTTP" do
      let(:http_adapter) { RDF::Util::File::NetHttpAdapter }

      it_behaves_like 'an RDF::HttpAdapter'
    end

    context "using RestClient" do
      require 'rest_client'
      let(:http_adapter) { RDF::Util::File::RestClientAdapter }

      it_behaves_like 'an RDF::HttpAdapter'
    end

    context "using Faraday" do
      require 'faraday'
      require 'faraday_middleware'
      let(:http_adapter) { RDF::Util::File::FaradayAdapter }

      it_behaves_like 'an RDF::HttpAdapter'
    end
  end
end
