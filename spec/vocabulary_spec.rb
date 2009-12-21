require 'rdf'

describe RDF::Vocabulary do
  VOCABS = %w(cc dc doap exif foaf http owl rdfs rss sioc skos wot xhtml xsd)
  DC_URI = "http://purl.org/dc/terms/"

  context "when created" do
    it "should require one argument" do
      lambda { RDF::Vocabulary.new }.should raise_error(ArgumentError)
      lambda { RDF::Vocabulary.new(DC_URI) }.should_not raise_error
      lambda { RDF::Vocabulary.new(DC_URI, DC_URI) }.should raise_error(ArgumentError)
    end
  end

  context "pre-defined vocabularies" do
    it "should support pre-defined vocabularies" do
      VOCABS.map { |s| s.to_s.upcase.to_sym }.each do |vocab|
        lambda { RDF.const_get(vocab) }.should_not raise_error(NameError)
      end
    end

    it "should support Creative Commons (CC)" do
      RDF::CC.license.to_s.should eql("http://creativecommons.org/ns#license")
    end

    it "should support Dublin Core (DC)" do
      RDF::DC.creator.to_s.should eql("http://purl.org/dc/terms/creator")
      RDF::DC.title.to_s.should eql("http://purl.org/dc/terms/title")
    end

    it "should support Description of a Project (DOAP)" do
      RDF::DOAP.platform.to_s.should eql("http://usefulinc.com/ns/doap#platform")
      RDF::DOAP['mailing-list'].to_s.should eql("http://usefulinc.com/ns/doap#mailing-list")
    end

    it "should support Exchangeable Image File Format (EXIF)" do
      RDF::EXIF.resolution.to_s.should eql("http://www.w3.org/2003/12/exif/ns#resolution")
    end

    it "should support Friend of a Friend (FOAF)" do
      RDF::FOAF.knows.to_s.should eql("http://xmlns.com/foaf/0.1/knows")
      RDF::FOAF.name.to_s.should eql("http://xmlns.com/foaf/0.1/name")
    end

    it "should support Hypertext Transfer Protocol (HTTP)" do
      RDF::HTTP.response.to_s.should eql("http://www.w3.org/2006/http#response")
    end

    it "should support Web Ontology Language (OWL)" do
      RDF::OWL.sameAs.to_s.should eql("http://www.w3.org/2002/07/owl#sameAs")
    end

    it "should support Resource Description Framework (RDF)" do
      RDF.type.to_s.should eql("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    end

    it "should support RDF Schema (RDFS)" do
      RDF::RDFS.seeAlso.to_s.should eql("http://www.w3.org/2000/01/rdf-schema#seeAlso")
    end

    it "should support RDF Site Summary (RSS)" do
      RDF::RSS.title.to_s.should eql("http://purl.org/rss/1.0/title")
    end

    it "should support Semantically-Interlinked Online Communities (SIOC)" do
      RDF::SIOC.has_member.to_s.should eql("http://rdfs.org/sioc/ns#has_member")
    end

    it "should support Simple Knowledge Organization System (SKOS)" do
      RDF::SKOS.definition.to_s.should eql("http://www.w3.org/2004/02/skos/core#definition")
    end

    it "should support Web of Trust (WOT)" do
      RDF::WOT.fingerprint.to_s.should eql("http://xmlns.com/wot/0.1/fingerprint")
    end

    it "should support XHTML Vocabulary (XHTML)" do
      RDF::XHTML.stylesheet.to_s.should eql("http://www.w3.org/1999/xhtml/vocab#stylesheet")
    end

    it "should support XML Schema (XSD)" do
      RDF::XSD.dateTime.to_s.should eql("http://www.w3.org/2001/XMLSchema#dateTime")
    end
  end

  context "ad-hoc vocabularies" do
    it "should support ad-hoc vocabularies" do
      dc = RDF::Vocabulary.new(DC_URI)

      dc.creator.should be_kind_of(RDF::URI)
      dc[:creator].should be_kind_of(RDF::URI)
      dc.creator.should eql(RDF::DC.creator)

      dc.title.should be_kind_of(RDF::URI)
      dc[:title].should be_kind_of(RDF::URI)
      dc.title.should eql(RDF::DC.title)
    end
  end
end
