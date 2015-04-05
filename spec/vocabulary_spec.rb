require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Vocabulary do
  VOCABS = %w(owl rdf rdfs xsd)
  STRICT_VOCABS = %w(owl rdf rdfs)

  context "#new" do
    it "should require one argument" do
      expect { RDF::Vocabulary.new }.to raise_error(ArgumentError)
      expect { RDF::Vocabulary.new("http://example.org/") }.not_to raise_error
      expect { RDF::Vocabulary.new("http://example.org/", "http://example.org/") }.to raise_error(ArgumentError)
    end

    subject {RDF::Vocabulary.new('http://example.org/')}
    it "should allow method_missing" do
      expect {subject.foo}.not_to raise_error
      expect(subject.foo).to be_a(RDF::Vocabulary::Term)
    end

    it "should allow []" do
      expect {subject["foo"]}.not_to raise_error
      expect(subject["foo"]).to be_a(RDF::Vocabulary::Term)
    end

    it "does not add to @@uris" do
      RDF::Vocabulary.new("http://example/")
      expect(RDF::Vocabulary.class_variable_get(:"@@uris")).to be_a(Hash)
      expect(RDF::Vocabulary.class_variable_get(:"@@uris").values).not_to include("http://example/")
    end
  end

  describe "#each" do
    it "inumerates pre-defined vocabularies" do
      expect {|b| RDF::Vocabulary.each(&b)}.to yield_control.at_least(10).times
      expect(RDF::Vocabulary.each.to_a).to include(RDF, RDF::CC, RDF::DC, RDF::RDFS)
    end

    it "inumerates properties of a subclass" do
      expect {|b| RDF::RDFS.each(&b)}.to yield_control.at_least(5).times
      expect(RDF::RDFS.each.to_a).to include(RDF::RDFS.range, RDF::RDFS.subClassOf, RDF::RDFS.domain)
    end
  end

  describe "#to_enum" do
    subject {RDF::RDFS.to_enum}
    it {should be_enumerable}
    its(:count) {should >= 30}
    it "enumerates statements" do
      expect {|b| subject.each(&b)}.to yield_control.at_least(30).times
      subject.each {|s| expect(s).to be_statement}
    end

    it "yields rdfs:label" do
      expect(subject).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.label, RDF::RDFS.comment.label))
    end
    it "yields rdfs:comment" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.comment, RDF::RDFS.comment.comment))
    end
    it "yields rdfs:isDefinedBy" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.isDefinedBy, RDF::RDFS.to_uri))
    end
    it "yields rdf:type" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF.type, RDF.Property))
    end
    it "yields rdfs:domain" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.domain, RDF::RDFS.Resource))
    end
    it "yields rdfs:range" do
      expect(subject.to_a).to include(RDF::Statement(RDF::RDFS.comment, RDF::RDFS.range, RDF::RDFS.Literal))
    end
  end

  context "strict vocabularies" do
    STRICT_VOCABS.map {|s| RDF.const_get(s.upcase.to_sym)}.each do |vocab|
      context vocab do
        subject {vocab}
        specify {should be_strict}

        it "raises error on unknown property" do
          expect {vocab._unknown_}.to raise_error(NoMethodError)
        end
      end
    end
  end

  context "non-strict vocabularies" do
    (VOCABS - STRICT_VOCABS).map {|s| RDF.const_get(s.upcase.to_sym)}.each do |vocab|
      context vocab do
        subject {vocab}
        specify {should_not be_strict}
      end

      it "allows unknown property" do
        expect(vocab._unknown_).to eq "#{vocab.to_uri}_unknown_"
      end
    end
  end

  context "pre-defined vocabularies" do
    it "should support pre-defined vocabularies" do
      VOCABS.map { |s| s.to_s.upcase.to_sym }.each do |vocab|
        expect { RDF.const_get(vocab) }.not_to raise_error
      end
    end

    it "should expand PName for vocabulary" do
      expect(RDF::Vocabulary.expand_pname("rdfs:")).to eql RDF::RDFS.to_uri
      expect(RDF::Vocabulary.expand_pname("rdfs:label")).to eql RDF::RDFS.label
    end

    it "should support Web Ontology Language (OWL)" do
      expect(RDF::OWL).to be_a_vocabulary("http://www.w3.org/2002/07/owl#")
      expect(RDF::OWL).to have_properties("http://www.w3.org/2002/07/owl#", %w(allValuesFrom annotatedProperty annotatedSource annotatedTarget assertionProperty backwardCompatibleWith bottomDataProperty bottomObjectProperty cardinality complementOf datatypeComplementOf deprecated differentFrom disjointUnionOf disjointWith distinctMembers equivalentClass equivalentProperty hasKey hasSelf hasValue imports incompatibleWith intersectionOf inverseOf maxCardinality maxQualifiedCardinality members minCardinality minQualifiedCardinality onClass onDataRange onDatatype onProperties onProperty oneOf priorVersion propertyChainAxiom propertyDisjointWith qualifiedCardinality sameAs someValuesFrom sourceIndividual targetIndividual targetValue topDataProperty topObjectProperty unionOf versionIRI versionInfo withRestrictions))
    end

    it "should support Resource Description Framework (RDF)" do
      expect(RDF).to be_a_vocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
      expect(RDF).to have_properties("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(first object predicate rest subject type value))
      expect(RDF).to have_terms("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(datatype Description parseType ID nodeID li))
      expect(RDF).to have_terms("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(datatype Description parseType ID nodeID li))
      %w(first object predicate rest subject type value).each do |p|
        expect(RDF.send(p)).to eq RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns##{p}")
      end
    end

    it "should support RDF Schema (RDFS)" do
      expect(RDF::RDFS).to be_a_vocabulary("http://www.w3.org/2000/01/rdf-schema#")
      expect(RDF::RDFS).to have_properties("http://www.w3.org/2000/01/rdf-schema#", %w(comment domain isDefinedBy label member range seeAlso subClassOf subPropertyOf))
      expect(RDF::RDFS).to have_terms("http://www.w3.org/2000/01/rdf-schema#", %w(Class Container ContainerMembershipProperty Datatype Literal Resource))
    end

    it "should support XML Schema (XSD)" do
      expect(RDF::XSD).to be_a_vocabulary("http://www.w3.org/2001/XMLSchema#")
      expect(RDF::XSD).to have_properties("http://www.w3.org/2001/XMLSchema#", %w(anyURI base64Binary boolean date dateTime decimal double duration float gDay gMonth gMonthDay gYear gYearMonth hexBinary string time NCName NMTOKEN Name byte int integer language long negativeInteger nonNegativeInteger nonPositiveInteger normalizedString positiveInteger short token unsignedByte unsignedInt unsignedLong unsignedShort))
    end

    describe "#properties" do
      context "when iterating over vocabularies" do
        it "includes properties only from the selected vocabulary" do
          [RDF::RDFS, RDF::OWL].each do |v|
            v.properties.each do |p|
              expect(p.to_s).to start_with(v.to_s)
            end
          end
        end
      end
    end
  end

  context "ad-hoc vocabularies" do
    subject :test_vocab do
      Class.new(RDF::Vocabulary.create("http://example.com/test#")) do
        property :Class
        property :prop
        property :prop2, :label => "Test property label", :comment => " Test property comment"
      end
    end

    it "should have Vocabulary::method_missing" do
      expect {test_vocab.a_missing_method}.not_to raise_error
    end

    it "should respond to [] with properties that have been defined" do
      expect(test_vocab[:prop]).to be_a(RDF::URI)
      expect(test_vocab["prop2"]).to be_a(RDF::URI)
    end

    it "should respond to [] with properties that have not been defined" do
      expect(test_vocab[:not_a_prop]).to be_a(RDF::URI)
      expect(test_vocab["not_a_prop"]).to be_a(RDF::URI)
    end

    its(:property) {should eq RDF::URI("http://example.com/test#property")}
    its(:properties) {should include("http://example.com/test#Class", "http://example.com/test#prop", "http://example.com/test#prop2")}

    it "should respond to methods for which a property has been defined explicitly" do
      expect(test_vocab.prop).to be_a(RDF::URI)
    end

    it "should respond to methods for which a class has been defined by a graph" do
      expect(test_vocab.Class).to be_a(RDF::URI)
    end

    it "should respond to label_for from base RDFS (DEPRECATED)" do
      expect {
        expect(test_vocab.label_for("prop2")).to eql "Test property label"
      }.to write('[DEPRECATION]').to(:error)
    end

    it "should respond to comment_for from base RDFS (DEPRECATED)" do
      expect {
        expect(test_vocab.comment_for(:prop2)).to eql " Test property comment"
      }.to write('[DEPRECATION]').to(:error)
    end

    it "should not enumerate from RDF::Vocabulary.each" do
      expect(RDF::Vocabulary.each.to_a).not_to include(test_vocab)
    end

    it "should accept property class method" do
      test_vocab.property :prop3, label: "prop3"
      expect(test_vocab.properties).to include("http://example.com/test#prop3")
    end
  end

  let(:terms) {{
    RDF::RDFS.Class => RDF::RDFS,
    RDF.type        => RDF
  }}

  describe ".find" do
    it "returns the vocab given a Term" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find(term)).to equal vocab
      end
    end
    it "returns the vocab given a URI" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find(RDF::URI(term.to_s))).to equal vocab
      end
    end
    it "returns the vocab given a String" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find(term.to_s)).to equal vocab
      end
    end
  end

  describe ".find_term" do
    it "returns itself given a Term" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find_term(term)).to equal term
      end
    end
    it "returns the term given a URI" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find_term(RDF::URI(term.to_s))).to equal term
      end
    end
    it "returns the term given a String" do
      terms.each do |term, vocab|
        expect(RDF::Vocabulary.find_term(term.to_s)).to equal term
      end
    end
  end

  describe ".imports" do
    {
      RDF::FOAF => [],
      RDF::WOT => [RDF::RDFS, RDF::OWL]
    }.each do |v, r|
      context v.to_uri do
        subject {v}
        its(:imports) {should eq r}
      end
    end

    specify {expect {RDF::SCHEMA.imports}.not_to raise_error}
  end

  describe ".imported_from" do
    {
      RDF::FOAF => [RDF::DOAP, RDF::MO],
      RDF::RDFS => [RDF::WOT],
      RDF::OWL => [RDF::WOT]
    }.each do |v, r|
      context v.to_uri do
        subject {v}
        its(:imported_from) {should eq r}
      end
    end

    specify {expect {RDF::SCHEMA.imports}.not_to raise_error}
  end

  describe ".load" do
    let!(:nt) {%{
      <http://example/Class> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2000/01/rdf-schema#Class> .
      <http://example/Class> <http://www.w3.org/2000/01/rdf-schema#Datatype> "Class" .
      <http://example/prop> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Property> .
      <http://example/prop> <http://www.w3.org/2000/01/rdf-schema#Datatype> "prop" .
    }}
    before(:each) do
      allow(RDF::Graph).to receive(:load).and_return(RDF::Graph.new << RDF::NTriples::Reader.new(nt))
    end

    subject {RDF::Vocabulary.load("http://example/")}

    it "creates terms" do
      expect(subject).to be_a_vocabulary("http://example/")
      expect(subject).to have_properties("http://example/", %w(Class prop))
    end
  end

  describe RDF::Vocabulary::Term do
    subject {RDF::RDFS.comment}
    specify {should be_uri}
    specify {should respond_to(:vocab)}
    specify {should respond_to(:type)}
    specify {should respond_to(:label)}
    specify {should respond_to(:comment)}
    specify {should respond_to(:domain)}
    specify {should respond_to(:range)}
    specify {should be_property}
    specify {should_not be_class}
    specify {should_not be_datatype}
    specify {should_not be_other}
    its(:label) {should eq "comment"}
    its(:comment) {should eq "A description of the subject resource."}
    its(:vocab) {should eql RDF::RDFS}

    context RDF::RDFS.Class do
      subject {RDF::RDFS.Class}
      specify {should_not be_property}
      specify {should be_class}
      specify {should_not be_datatype}
      specify {should_not be_other}
      its(:vocab) {should eql RDF::RDFS}
    end

    context RDF::XSD.integer do
      subject {RDF::XSD.integer}
      specify {should_not be_property}
      specify {should_not be_class}
      specify {should be_datatype}
      specify {should_not be_other}
      its(:vocab) {should eql RDF::XSD}
    end

    context "#initialize" do
      subject {
        RDF::Vocabulary::Term.new(:foo,
                                  label: "foo",
                                  attributes: {
                                    domain: RDF::RDFS.Resource,
                                    range: [RDF::RDFS.Resource, RDF::RDFS.Class],
                                    "schema:domainIncludes" => RDF::RDFS.Resource,
                                    "schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class],
                                  })
          }
      its(:label) {should eq "foo"}
      its(:domain) {should include(RDF::RDFS.Resource)}
      its(:range) {should include(RDF::RDFS.Resource, RDF::RDFS.Class)}
      its(:attributes) {should include("schema:domainIncludes" => RDF::RDFS.Resource)}
      its(:attributes) {should include("schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class])}
    end
  end
end
