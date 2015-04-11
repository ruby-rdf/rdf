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

    context "HTTP(s)" do

      shared_context "using a HTTP client" do
        before do
          RDF::Util::File.http_adapter = http_adapter
        end

        after do
          RDF::Util::File.http_adapter = nil
        end

        it "returns an http URL" do
          WebMock.stub_request(:get, uri).
            to_return(body: File.read(File.expand_path("../../etc/doap.nt", __FILE__)),
                      status: 200,
                      headers: { 'Content-Type' => RDF::NTriples::Format.content_type.first})
          f = RDF::Util::File.open_file(uri)
          expect(f).to respond_to(:read)
          expect(f.content_type).to eq RDF::NTriples::Format.content_type.first
          expect(f.code).to eq 200
          opened.opened
        end

        it "adds Accept header using defined readers" do
          content_types = RDF::Reader.map {|r| r.format.content_type}.flatten.uniq
          WebMock.stub_request(:get, uri).with do |request|
            expect(request.headers['Accept']).to include(*content_types)
          end.to_return(body: "foo")
          RDF::Util::File.open_file(uri) do |f|
            opened.opened
          end
        end

        it "adds Accept header with low-priority */*" do
          WebMock.stub_request(:get, uri).with do |request|
            expect(request.headers['Accept']).to include('*/*;q=0.1')
          end.to_return(body: "foo")
          RDF::Util::File.open_file(uri) do |f|
            opened.opened
          end
        end

        it "used provided Accept header" do
          WebMock.stub_request(:get, uri).with do |request|
            expect(request.headers["Accept"]).to include('a/b')
          end.to_return(body: "foo")
          RDF::Util::File.open_file(uri, headers: {"Accept" => "a/b"}) do |f|
            opened.opened
          end
        end

        it "sets content_type and encoding to utf-8 if absent" do
          WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"Content-Type" => "text/turtle"})
          RDF::Util::File.open_file(uri) do |f|
            expect(f.content_type).to eq "text/turtle"
            expect(f.charset).to eq Encoding::UTF_8
            expect(f.content_encoding).to eq "utf-8"
            expect(f.external_encoding.to_s.downcase).to eq "utf-8"
            opened.opened
          end
        end

        it "sets content_type and encoding if provided" do
          WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"Content-Type" => "text/turtle ; charset=ISO-8859-4"})
          RDF::Util::File.open_file(uri) do |f|
            expect(f.content_type).to eq "text/turtle"
            expect(f.charset).to eq "ISO-8859-4"
            expect(f.external_encoding.to_s.downcase).to eq "iso-8859-4"
            opened.opened
          end
        end

        it "sets last_modified if provided" do
          WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"Last-Modified" => "Thu, 24 Oct 2013 23:46:56 GMT"})
          RDF::Util::File.open_file(uri) do |f|
            expect(f.last_modified).to eq DateTime.parse("Thu, 24 Oct 2013 23:46:56 GMT")
            opened.opened
          end
        end

        it "sets etag if provided" do
          WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"ETag" => "abc123"})
          RDF::Util::File.open_file(uri) do |f|
            expect(f.etag).to eq "abc123"
            opened.opened
          end
        end

        it "sets arbitrary header" do
          WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"Foo" => "Bar"})
          RDF::Util::File.open_file(uri) do |f|
            expect(f.headers[:foo]).to eq %(Bar)
            opened.opened
          end
        end

        context "redirects" do
          it "sets base_uri to resource" do
            WebMock.stub_request(:get, uri).to_return(body: "foo")
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq uri
              opened.opened
            end
          end

          it "sets base_uri to location if present" do
            WebMock.stub_request(:get, uri).to_return(body: "foo", headers: {"Location" => "http://example/"})
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq "http://example/"
              opened.opened
            end
          end

          it "follows 301 and uses new location" do
            WebMock.stub_request(:get, uri).to_return({status: 301, headers: {"Location" => "http://example/"}})
            WebMock.stub_request(:get, "http://example/").to_return({body: "foo"})
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq "http://example/"
              expect(f.read).to eq "foo"
              opened.opened
            end
          end

          it "follows 302 and uses new location" do
            WebMock.stub_request(:get, uri).to_return({status: 302, headers: {"Location" => "http://example/"}})
            WebMock.stub_request(:get, "http://example/").to_return({body: "foo"})
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq "http://example/"
              expect(f.read).to eq "foo"
              opened.opened
            end
          end

          it "follows 303 and uses new location" do
            WebMock.stub_request(:get, uri).to_return({status: 303, headers: {"Location" => "http://example/"}})
            WebMock.stub_request(:get, "http://example/").to_return({body: "foo"})
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq "http://example/"
              expect(f.read).to eq "foo"
              opened.opened
            end
          end

          it "follows 307 and uses new location" do
            WebMock.stub_request(:get, uri).to_return({status: 307, headers: {"Location" => "http://example/"}})
            WebMock.stub_request(:get, "http://example/").to_return({body: "foo"})
            RDF::Util::File.open_file(uri) do |f|
              expect(f.base_uri).to eq "http://example/"
              expect(f.read).to eq "foo"
              opened.opened
            end
          end

          it "raises an IOError for HTTP 4xx status codes" do
            opened.opened

            WebMock.stub_request(:get, uri).to_return({status: 404})
            expect do
              RDF::Util::File.open_file(uri)
            end.to raise_exception IOError
          end

          it "raises an IOError for HTTP 5xx status codes" do
            opened.opened

            WebMock.stub_request(:get, uri).to_return({status: 500})
            expect do
              RDF::Util::File.open_file(uri)
            end.to raise_exception IOError
          end
        end

        context "proxy" do
          it "requests through proxy" do
            WebMock.stub_request(:get, uri).
              to_return(body: File.read(File.expand_path("../../etc/doap.nt", __FILE__)),
                        status: 200,
                        headers: { 'Content-Type' => RDF::NTriples::Format.content_type.first})
            RDF::Util::File.open_file(uri, proxy: "http://proxy.example.com") do |f|
              opened.opened
            end
            expect(WebMock).to have_requested(:get, uri)
          end
        end

        context "https" do
          let(:uri) {"https://some/secure/uri"}

          it "returns an htts URL" do
            WebMock.stub_request(:get, uri).
              to_return(body: "foo",
                        status: 200,
                        headers: { 'Content-Type' => RDF::NTriples::Format.content_type.first})
            f = RDF::Util::File.open_file(uri)
            expect(f).to respond_to(:read)
            expect(f.content_type).to eq RDF::NTriples::Format.content_type.first
            expect(f.code).to eq 200
            opened.opened
          end
        end

        context "links" do
          {
            "no links" => [
              '',
              []
            ],
            "rel" => [
              '<http://example.com/foo>; rel="self"',
              [["http://example.com/foo", [%w(rel self)]]]
            ],
            "rel-meta" => [
              '<http://example.com/>; rel="up"; meta="bar"',
              [["http://example.com/", [%w(rel up), %w(meta bar)]]]
            ],
            'bar' => [
              '<http://example.com/>',
              [["http://example.com/", []]]
            ],
            'two links' => [
              '<http://example.com/foo>; rel="self", <http://example.com/>; rel="up"; meta="bar"',
              [
                ["http://example.com/foo", [%w(rel self)]],
                ["http://example.com/", [%w(rel up), %w(meta bar)]]
              ]
            ]
          }.each do |name, (input, output)|
            it name do
              WebMock.stub_request(:get, uri).
                to_return(body: "content",
                          status: 200,
                          headers: {
                            'Content-Type' => RDF::NTriples::Format.content_type.first,
                            'Link' => input
                          })
              RDF::Util::File.open_file(uri) do |f|
                expect(f).to respond_to(:read)
                expect(f.links.to_a).to eq output
                opened.opened
              end
            end
          end

          it "can find a link using #find_link" do
            WebMock.stub_request(:get, uri).
              to_return(body: "content",
                        status: 200,
                        headers: {
                          'Content-Type' => RDF::NTriples::Format.content_type.first,
                          'Link' => '<http://example.com/foo> rel="describedby" type="application/n-triples"'
                        })
            RDF::Util::File.open_file(uri) do |f|
              expect(f.links.find_link(['rel', 'describedby']).to_a).to eq ['http://example.com/foo', [%w(rel describedby)]]
              opened.opened
            end
          end
        end
      end
      
      context "using Net::HTTP" do
        let(:http_adapter) { RDF::Util::File::NetHttpAdapter }
        it_behaves_like "using a HTTP client"
      end
      
      context "using RestClient" do
        let(:http_adapter) { RDF::Util::File::RestClientAdapter }
        require 'rest_client'
        it_behaves_like "using a HTTP client"
      end

      context "using Faraday" do
        let(:http_adapter) { RDF::Util::File::FaradayAdapter }
        require 'faraday'
        require 'faraday_middleware'
        it_behaves_like "using a HTTP client"
      end

      context "using Hurley" do
        let(:http_adapter) { RDF::Util::File::HurleyAdapter }
        require 'hurley'
        it_behaves_like "using a HTTP client"
      end
    end
  end
end
