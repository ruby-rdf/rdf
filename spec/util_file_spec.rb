require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::File do
  let(:uri) {"http://ruby-rdf.github.com/rdf/etc/doap.nt"}
  let(:opened) {double("opened")}
  before(:each) do
    opened.should_receive(:opened)
  end

  describe ".open_file" do
    it "yields a local file" do
      RDF::Util::File.open_file(fixture_path("test.nt")) do |f|
        expect(f).to respond_to(:read)
        opened.opened
      end
    end
    
    it "yields an http URL", :pending => ("1.8 difference" if RUBY_VERSION < "1.9") do
      expect(OpenURI).to receive(:open_uri).with(URI(uri), an_instance_of(Hash)).and_yield(StringIO.new("data"))
      RDF::Util::File.open_file(uri) do |f|
        expect(f).to respond_to(:read)
        opened.opened
      end
    end
    
    it "yields a file URL" do
      RDF::Util::File.open_file("file:" + fixture_path("test.nt")) do |f|
        expect(f).to respond_to(:read)
        opened.opened
      end
    end

    it "adds Accept header using defined readers", :ruby => "1.9" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.flatten.uniq
      Kernel.should_receive(:open) do |file_name, headers|
        expect(headers).to be_a(Hash)
        expect(headers.keys).to include("Accept")
        content_types.each do |ct|
          expect(headers['Accept']).to include(ct)
        end
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(uri) do |f|
        opened.opened
      end
    end

    it "adds Accept header with low-priority */*", :ruby => "1.9" do
      Kernel.should_receive(:open) do |file_name, headers|
        expect(headers).to be_a(Hash)
        expect(headers['Accept']).to include('*/*;q=0.1')
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(uri) do |f|
        opened.opened
      end
    end

    it "used provided Accept header", :ruby => "1.9" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.uniq
      Kernel.should_receive(:open) do |file_name, headers|
        expect(headers).to be_a(Hash)
        expect(headers.keys).to include("Accept")
        content_types.each do |ct|
          expect(headers['Accept']).to eq "a/b"
        end
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(uri, :headers => {"Accept" => "a/b"}) do |f|
        opened.opened
      end
    end
  end
end
