require 'rdf'

describe RDF::Reader::NTriples do
  before :each do
    @reader = RDF::Reader::NTriples
  end

  context "when created" do
    it "should accept files" do
      lambda { @reader.new(File.open("spec/data/test.nt")) }.should_not raise_error
    end

    it "should accept IO streams" do
      lambda { @reader.new(StringIO.new("")) }.should_not raise_error
    end

    it "should accept strings" do
      lambda { @reader.new("") }.should_not raise_error
    end
  end

  context "when parsing" do
    it "should parse empty lines" do
      ["\n", "\r\n", "\r"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines" do
      ["#\n", "# \n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines preceded by whitespace" do
      ["\t#\n", " #\n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse W3C's test data" do
      lambda { @reader.new(File.open("spec/data/test.nt")).to_a.size.should == 30 }.should_not raise_error
    end
  end
end
