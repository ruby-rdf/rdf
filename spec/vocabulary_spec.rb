require 'rdf'

describe RDF::Vocabulary do
  DC_URI = "http://purl.org/dc/elements/1.1/"

  context "when created" do
    it "should require one argument" do
      lambda { RDF::Vocabulary.new }.should raise_error(ArgumentError)
      lambda { RDF::Vocabulary.new(DC_URI) }.should_not raise_error
      lambda { RDF::Vocabulary.new(DC_URI, DC_URI) }.should raise_error(ArgumentError)
    end
  end

  context "when queried" do
    it "should support arbitrary properties" do
      @dc = RDF::Vocabulary.new(DC_URI)
      @dc.creator.should be_kind_of(RDF::URI)
      @dc[:creator].should be_kind_of(RDF::URI)
      @dc.title.should be_kind_of(RDF::URI)
      @dc[:title].should be_kind_of(RDF::URI)
    end
  end
end
