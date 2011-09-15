require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::File do
  before(:each) do
    @opened = mock("opened")
    @opened.should_receive(:opened)
    @uri = "http://rdf.rubyforge.org/doap.nt"
  end

  describe ".open_file" do
    it "yields a local file" do
      RDF::Util::File.open_file(fixture_path("test.nt")) do |f|
        f.should respond_to(:read)
        @opened.opened
      end
    end
    
    it "yields an http URL" do
      OpenURI.should_receive(:open_uri).with(URI(@uri)).and_yield(StringIO.new("data"))
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
  end
end
