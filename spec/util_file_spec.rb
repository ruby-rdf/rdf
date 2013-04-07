require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::File do
  before(:each) do
    @opened = mock("opened")
    @opened.should_receive(:opened)
    @uri = "http://ruby-rdf.github.com/rdf/etc/doap.nt"
  end

  describe ".open_file" do
    it "yields a local file" do
      RDF::Util::File.open_file(fixture_path("test.nt")) do |f|
        f.should respond_to(:read)
        @opened.opened
      end
    end
    
    it "yields an http URL", :pending => ("1.8 difference" if RUBY_VERSION < "1.9") do
      OpenURI.should_receive(:open_uri).with(URI(@uri), an_instance_of(Hash)).and_yield(StringIO.new("data"))
      RDF::Util::File.open_file(@uri) do |f|
        f.should respond_to(:read)
        @opened.opened
      end
    end
    
    it "yields a file URL" do
      RDF::Util::File.open_file("file:" + fixture_path("test.nt")) do |f|
        f.should respond_to(:read)
        @opened.opened
      end
    end

    it "adds Accept header using defined readers", :ruby => "1.9" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.flatten.uniq
      Kernel.should_receive(:open) do |file_name, headers|
        headers.should be_a(Hash)
        headers.keys.should include("Accept")
        content_types.each do |ct|
          headers['Accept'].should include(ct)
        end
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(@uri) do |f|
        @opened.opened
      end
    end

    it "adds Accept header with low-priority */*", :ruby => "1.9" do
      Kernel.should_receive(:open) do |file_name, headers|
        headers.should be_a(Hash)
        headers['Accept'].should include('*/*;q=0.1')
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(@uri) do |f|
        @opened.opened
      end
    end

    it "used provided Accept header", :ruby => "1.9" do
      content_types = RDF::Reader.map {|r| r.format.content_type}.uniq
      Kernel.should_receive(:open) do |file_name, headers|
        headers.should be_a(Hash)
        headers.keys.should include("Accept")
        content_types.each do |ct|
          headers['Accept'].should == "a/b"
        end
      end.and_yield(StringIO.new)
      RDF::Util::File.open_file(@uri, :headers => {"Accept" => "a/b"}) do |f|
        @opened.opened
      end
    end
  end
end
