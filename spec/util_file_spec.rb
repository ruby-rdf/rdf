require File.join(File.dirname(__FILE__), 'spec_helper')
require 'webmock/rspec'

describe RDF::Util::File do
  let(:uri) {"http://ruby-rdf.github.com/rdf/etc/doap.nt"}
  let(:opened) {double("opened")}
  before(:each) do
    expect(opened).to receive(:opened)
  end

  describe ".open_file" do
    it "yields a local file" do
      r = RDF::Util::File.open_file(fixture_path("test.nt")) do |f|
        expect(f).to respond_to(:read)
        opened.opened
        RDF::Reader.new
      end
      expect(r).to be_a(RDF::Reader)
    end

    it "yields an http URL" do
      WebMock.stub_request(:get, uri).
        to_return(:body => File.read(File.expand_path("../../etc/doap.nt", __FILE__)),
                  :status => 200,
                  :headers => { 'Content-Type' => RDF::NTriples::Format.content_type})
      r = RDF::Util::File.open_file(uri) do |f|
        expect(f).to respond_to(:read)
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

    it "returns an http URL" do
      WebMock.stub_request(:get, uri).
        to_return(:body => File.read(File.expand_path("../../etc/doap.nt", __FILE__)),
                  :status => 200,
                  :headers => { 'Content-Type' => RDF::NTriples::Format.content_type})
      f = RDF::Util::File.open_file(uri)
      expect(f).to respond_to(:read)
      opened.opened
    end
    
    it "returns a file URL" do
      f = RDF::Util::File.open_file("file:" + fixture_path("test.nt"))
      expect(f).to respond_to(:read)
      opened.opened
    end

    it "adds Accept header using defined readers" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.flatten.uniq
      WebMock.stub_request(:get, uri).with do |request|
        request.headers.keys.include?('Accept') &&
        content_types.all? {|ct| request.headers['Accept'].include?(ct)}
      end.to_return(:body => "foo")
      RDF::Util::File.open_file(uri) do |f|
        opened.opened
      end
    end

    it "adds Accept header with low-priority */*" do
      WebMock.stub_request(:get, uri).with do |request|
        request.headers.keys.include?('Accept') &&
        request.headers['Accept'].include?('*/*;q=0.1')
      end.to_return(:body => "foo")
      RDF::Util::File.open_file(uri) do |f|
        opened.opened
      end
    end

    it "used provided Accept header" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.flatten.uniq
      WebMock.stub_request(:get, uri).with do |request|
        request.headers.keys.include?('Accept') &&
        request.headers['Accept'].include?('a/b')
      end.to_return(:body => "foo")
      RDF::Util::File.open_file(uri, :headers => {"Accept" => "a/b"}) do |f|
        opened.opened
      end
    end

    context "redirects" do
      it "sets base_uri to resource" do
        WebMock.stub_request(:get, uri).to_return(:body => "foo")
        RDF::Util::File.open_file(uri) do |f|
          expect(f.base_uri).to eq uri
          opened.opened
        end
      end

      it "sets base_uri to location if present" do
        WebMock.stub_request(:get, uri).to_return(:body => "foo", :headers => {"Location" => "http://example/"})
        RDF::Util::File.open_file(uri) do |f|
          expect(f.base_uri).to eq "http://example/"
          opened.opened
        end
      end

      it "follows 301" do
        WebMock.stub_request(:get, uri).to_return({:status => 301, :headers => {"Location" => "http://example/"}})
        WebMock.stub_request(:get, "http://example/").to_return({:body => "foo"})
        RDF::Util::File.open_file(uri) do |f|
          expect(f.base_uri).to eq "http://example/"
          expect(f.read).to eq "foo"
          opened.opened
        end
      end

      it "follows 302" do
        WebMock.stub_request(:get, uri).to_return({:status => 302, :headers => {"Location" => "http://example/"}})
        WebMock.stub_request(:get, "http://example/").to_return({:body => "foo"})
        RDF::Util::File.open_file(uri) do |f|
          expect(f.base_uri).to eq "http://example/"
          expect(f.read).to eq "foo"
          opened.opened
        end
      end

      it "follows 303 and keeps original location" do
        WebMock.stub_request(:get, uri).to_return({:status => 303, :headers => {"Location" => "http://example/"}})
        WebMock.stub_request(:get, "http://example/").to_return({:body => "foo"})
        RDF::Util::File.open_file(uri) do |f|
          expect(f.base_uri).to eq uri
          expect(f.read).to eq "foo"
          opened.opened
        end
      end
    end

    it "sets content_type and encoding to utf-8 if absent" do
      WebMock.stub_request(:get, uri).to_return(:body => "foo", :headers => {"Content-Type" => "text/turtle"})
      RDF::Util::File.open_file(uri) do |f|
        expect(f.content_type).to eq "text/turtle"
        expect(f.charset).to eq "utf-8"
        expect(f.external_encoding.to_s.downcase).to eq "utf-8"
        opened.opened
      end
    end

    it "sets content_type and encoding if provided" do
      WebMock.stub_request(:get, uri).to_return(:body => "foo", :headers => {"Content-Type" => "text/turtle ; charset=ISO-8859-4"})
      RDF::Util::File.open_file(uri) do |f|
        expect(f.content_type).to eq "text/turtle"
        expect(f.charset).to eq "ISO-8859-4"
        expect(f.external_encoding.to_s.downcase).to eq "iso-8859-4"
        opened.opened
      end
    end

    it "sets last_modified if provided" do
      WebMock.stub_request(:get, uri).to_return(:body => "foo", :headers => {"Last-Modified" => "Thu, 24 Oct 2013 23:46:56 GMT"})
      RDF::Util::File.open_file(uri) do |f|
        expect(f.last_modified).to eq DateTime.parse("Thu, 24 Oct 2013 23:46:56 GMT")
        opened.opened
      end
    end
  end
end
