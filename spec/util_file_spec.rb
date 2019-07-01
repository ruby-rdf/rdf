require File.join(File.dirname(__FILE__), 'spec_helper')
require 'webmock/rspec'
require 'rdf/ntriples'

describe RDF::Util::File do
  before(:each) {WebMock.disable_net_connect!}
  after(:each) {WebMock.allow_net_connect!}

  describe ".http_adapter" do
    after do
      RDF::Util::File.http_adapter = nil
    end

    it "returns Net::HTTP if rest-client is not available" do
      hide_const("RestClient")
      RDF::Util::File.remove_instance_variable(:@http_adapter) if RDF::Util::File.instance_variable_defined?(:@http_adapter)
      RDF::Util::File.http_adapter
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
        allow(RDF::Format).to receive(:accept_types).and_return(["text/html;q=0.5", "text/plain;q=0.2", "application/xhtml+xml;q=0.7", "text/csv;q=0.4", "text/tab-separated-values;q=0.4"])
      end
      it "should demote text/plain to q=0.2" do
        expect(subject).to include "text/plain;q=0.2"
      end
      it "should demote text/csv to q=0.4" do
        expect(subject).to include "text/plain;q=0.2"
      end
      it "should demote text/tab-separated-values to q=0.4" do
        expect(subject).to include "text/plain;q=0.2"
      end
      it "should demote text/html to q=0.5" do
        expect(subject).to include "text/html;q=0.5"
      end
      it "should demote application/xhtml+xml to q=0.7" do
        expect(subject).to include "application/xhtml+xml;q=0.7"
      end
    end

    describe ".default_user_agent" do
      subject {RDF::Util::File::HttpAdapter.default_user_agent}
      specify {is_expected.to eq "Ruby RDF.rb/#{RDF::VERSION}"}
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

    it "raises IOError on missing local file" do
      expect {RDF::Util::File.open_file(fixture_path("not-here"))}.to raise_error IOError
      opened.opened
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
    end unless ENV["CI"]

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

    it "returns a local file with fragment identifier" do
      f = RDF::Util::File.open_file(fixture_path("test.nt#fragment"))
      expect(f).to respond_to(:read)
      opened.opened
    end

    it "returns a local file with query" do
      f = RDF::Util::File.open_file(fixture_path("test.nt?query"))
      expect(f).to respond_to(:read)
      opened.opened
    end

    it "returns a file URL" do
      f = RDF::Util::File.open_file("file:" + fixture_path("test.nt"))
      expect(f).to respond_to(:read)
      opened.opened
    end

    it "raises IOError on missing file URL" do
      expect {RDF::Util::File.open_file("file:" + fixture_path("not-here"))}.to raise_error IOError
      opened.opened
    end
  end

  describe RDF::Util::File::RemoteDocument do
    subject {
      described_class.new("body",
        headers: {
          content_type: %(text/turtle ; charset=UTF-8 ; foo="a B c"),
          last_modified: "Thu, 24 Oct 2013 23:46:56 GMT",
          etag: "abc123",
          location: "http://location.example.org/",
          content_encoding: "gzip, identity",
          link: %(<http://example.com/foo>; rel="self"),
        },
        base_uri: "http://base.example.org/",
        code: 200
      )
    }

    its(:read) {is_expected.to eq "body"}
    its(:base_uri) {is_expected.to eq "http://base.example.org/"}
    its(:content_type) {is_expected.to eq "text/turtle"}
    its(:charset) {is_expected.to eq "utf-8"}
    its(:code) {is_expected.to eq 200}
    its(:etag) {is_expected.to eq "abc123"}
    its(:parameters) {is_expected.to eq({charset: "UTF-8", foo: "a B c"})}
    its(:last_modified) {is_expected.to eq DateTime.parse("Thu, 24 Oct 2013 23:46:56 GMT")}
    its(:content_encoding) {is_expected.to eq %w(gzip identity)}
    its(:links) {expect(subject.links.to_a).to eq [["http://example.com/foo", [%w(rel self)]]]}
  end

  context "HTTP Adapters" do
    require 'rdf/spec/http_adapter'

    context "using Net::HTTP" do
      it_behaves_like 'an RDF::HttpAdapter' do
        let(:http_adapter) { RDF::Util::File::NetHttpAdapter }
      end
    end

    context "using RestClient" do
      require 'rest_client'

      it_behaves_like 'an RDF::HttpAdapter' do
        let(:http_adapter) { RDF::Util::File::RestClientAdapter }
      end
    end

    context "using Faraday" do
      require 'faraday'
      require 'faraday_middleware'

      it_behaves_like 'an RDF::HttpAdapter' do
        let(:http_adapter) { RDF::Util::File::FaradayAdapter }
      end
    end
  end unless ENV["CI"]
end
