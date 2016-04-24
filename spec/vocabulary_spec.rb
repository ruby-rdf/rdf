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

    it "camelizes on method_missing" do
      expect(subject.foo_bar).to be_a(RDF::Vocabulary::Term)
      expect(subject.foo_bar).to eq (subject.to_uri / 'fooBar')
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
      expect {|b| RDF::Vocabulary.each(&b)}.to yield_control.at_least(3).times
      expect(RDF::Vocabulary.each.to_a).to include(RDF, RDF::RDFS, RDF::OWL)
    end

    it "inumerates properties of a subclass" do
      expect {|b| RDF::RDFS.each(&b)}.to yield_control.at_least(5).times
      expect(RDF::RDFS.each.to_a).to include(RDF::RDFS.range, RDF::RDFS.subClassOf, RDF::RDFS.domain)
    end
  end

  describe "#to_enum" do
    subject {RDF::RDFS.to_enum}
    it {should be_enumerable}
    its(:count) {is_expected.to be >= 30}
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
        specify {is_expected.to be_strict}

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
        specify {is_expected.not_to be_strict}
      end

      it "allows unknown property" do
        expect(vocab.unknown_property).to eq "#{vocab.to_uri}unknownProperty"
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
        property :prop2, label: "Test property label", comment: " Test property comment"
      end
    end

    it "should have Vocabulary::method_missing" do
      expect {test_vocab.a_missing_method}.not_to raise_error
    end

    it "camelizes on method_missing" do
      expect(test_vocab.a_missing_method)
        .to eq (test_vocab.to_uri / 'aMissingMethod')
    end

    it "should respond to [] with properties that have been defined" do
      expect(test_vocab[:prop]).to be_a(RDF::URI)
      expect(test_vocab["prop2"]).to be_a(RDF::URI)
    end

    it "should respond to [] with properties that have not been defined" do
      expect(test_vocab[:not_a_prop]).to eq (test_vocab.to_uri / 'not_a_prop')
      expect(test_vocab["not_a_prop"]).to eq (test_vocab.to_uri / 'not_a_prop')
    end

    its(:property) {is_expected.to eq RDF::URI("http://example.com/test#property")}
    its(:properties) {is_expected.to include("http://example.com/test#Class", "http://example.com/test#prop", "http://example.com/test#prop2")}

    it "should respond to methods for which a property has been defined explicitly" do
      expect(test_vocab.prop).to be_a(RDF::URI)
    end

    it "should respond to methods for which a class has been defined by a graph" do
      expect(test_vocab.Class).to be_a(RDF::URI)
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
  end unless ENV["CI"]

  describe ".imports" do
    {
      RDF::Vocab::FOAF => [],
      RDF::Vocab::WOT => [RDF::RDFS, RDF::OWL]
    }.each do |v, r|
      context v.to_uri do
        subject {v}
        its(:imports) {is_expected.to eq r}
      end
    end

    specify {expect {RDF::Vocab::SCHEMA.imports}.not_to raise_error}
  end unless ENV["CI"]

  describe ".imported_from" do
    {
      RDF::RDFS => [RDF::Vocab::WOT],
      RDF::OWL => [RDF::Vocab::WOT]
    }.each do |v, r|
      context v.to_uri do
        subject {v}
        its(:imported_from) {is_expected.to eq r}
      end
    end

    specify {expect {RDF::Vocab::SCHEMA.imports}.not_to raise_error}
  end unless ENV["CI"]

  describe ".from_graph" do
    let!(:nt) {%{
      <http://example/Class> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2000/01/rdf-schema#Class> .
      <http://example/Class> <http://www.w3.org/2000/01/rdf-schema#Datatype> "Class" .
      <http://example/prop> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Property> .
      <http://example/prop> <http://www.w3.org/2000/01/rdf-schema#Datatype> "prop" .
    }}
    let!(:graph) {
      RDF::Graph.new << RDF::NTriples::Reader.new(nt)
    }

    subject {RDF::Vocabulary.from_graph(graph, url: "http://example/")}

    it "creates terms" do
      expect(subject).to be_a_vocabulary("http://example/")
      expect(subject).to have_properties("http://example/", %w(Class prop))
    end

    describe ":extra" do
      subject {RDF::Vocabulary.from_graph(graph, url: "http://example/", extra: {id: {label: "Identifier"}})}

      it "adds extra properties to vocabulary" do
        expect(subject).to have_properties("http://example/", %w(id))
      end
    end
  end

  describe RDF::Vocabulary::Term do
    subject {RDF::RDFS.comment}
    specify {is_expected.to be_uri}
    specify {is_expected.to respond_to(:vocab)}
    specify {is_expected.to respond_to(:type)}
    specify {is_expected.to respond_to(:label)}
    specify {is_expected.to respond_to(:comment)}
    specify {is_expected.to respond_to(:domain)}
    specify {is_expected.to respond_to(:range)}
    specify {is_expected.to be_property}
    specify {is_expected.not_to be_class}
    specify {is_expected.not_to be_datatype}
    specify {is_expected.not_to be_other}
    its(:label) {is_expected.to eq "comment"}
    its(:comment) {is_expected.to eq "A description of the subject resource."}
    its(:vocab) {is_expected.to eql RDF::RDFS}

    context RDF::RDFS.Class do
      subject {RDF::RDFS.Class}
      specify {is_expected.not_to be_property}
      specify {is_expected.to be_class}
      specify {is_expected.not_to be_datatype}
      specify {is_expected.not_to be_other}
      its(:vocab) {is_expected.to eql RDF::RDFS}
    end

    context RDF::XSD.integer do
      subject {RDF::XSD.integer}
      specify {is_expected.not_to be_property}
      specify {is_expected.not_to be_class}
      specify {is_expected.to be_datatype}
      specify {is_expected.not_to be_other}
      its(:vocab) {is_expected.to eql RDF::XSD}
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
      its(:label) {is_expected.to eq "foo"}
      its(:domain) {is_expected.to include(RDF::RDFS.Resource)}
      its(:range) {is_expected.to include(RDF::RDFS.Resource, RDF::RDFS.Class)}
      its(:attributes) {is_expected.to include("schema:domainIncludes" => RDF::RDFS.Resource)}
      its(:attributes) {is_expected.to include("schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class])}
    end

    context "#each_statement" do
      it "emits statements for a vocabulary" do
        graph = RDF::Graph.new {|g| RDF::RDFS[""].each_statement {|s| g << s}}

        expect(graph.map(&:subject)).to all(eql(RDF::RDFS.to_uri))
        expect(graph.query(predicate: RDF.type).map(&:object)).to include RDF::OWL.Ontology
      end

      {
        "rdfs:comment" => {term: RDF::RDFS.comment, predicate: RDF::RDFS.comment, value: RDF::Literal(%(A description of the subject resource.))},
        "rdfs:label" => {term: RDF::RDFS.label, predicate: RDF::RDFS.label, value: RDF::Literal("label")},
        "rdf:type" => {term: RDF.type, predicate: RDF.type, value: RDF.Property},
        "rdfs:subClassOf" => {term: RDF::RDFS.Class, predicate: RDF::RDFS.subClassOf, value: RDF::RDFS.Resource},
        "rdfs:subPropertyOf" => {term: RDF::RDFS.isDefinedBy, predicate: RDF::RDFS.subPropertyOf, value: RDF::RDFS.seeAlso},
        "rdfs:domain" => {term: RDF::RDFS.domain, predicate: RDF::RDFS.domain, value: RDF.Property},
        "rdfs:range" => {term: RDF::RDFS.range, predicate: RDF::RDFS.range, value: RDF::RDFS.Class},
        "schema:domainIncludes" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {domainIncludes: RDF::RDFS.Resource}),
          predicate: RDF::Vocab::SCHEMA.domainIncludes,
          value: RDF::RDFS.Resource
        },
        "schema:inverseOf" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {inverseOf: RDF::RDFS.Resource}),
          predicate: RDF::Vocab::SCHEMA.inverseOf,
          value: RDF::RDFS.Resource
        },
        "schema:rangeIncludes" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {rangeIncludes: RDF::RDFS.Resource}),
          predicate: RDF::Vocab::SCHEMA.rangeIncludes,
          value: RDF::RDFS.Resource
        },
        "vocab value" => {term: RDF::RDFS.isDefinedBy, predicate: RDF::RDFS.isDefinedBy, value: RDF::RDFS.to_uri},
        "term value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdfs:seeAlso" => "rdfs:seeAlso"}),
          predicate: RDF::RDFS.seeAlso,
          value: RDF::RDFS.seeAlso
        },
        "uri value" => {term: RDF::RDFS[""], predicate: RDF::RDFS.seeAlso, value: RDF::URI("http://www.w3.org/2000/01/rdf-schema-more")},
        "date value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "2016-04-24"}),
          predicate: RDF.value,
          value: RDF::Literal::Date.new("2016-04-24")
        },
        "dateTime value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "2016-04-24T15:22:00"}),
          predicate: RDF.value,
          value: RDF::Literal::DateTime.new("2016-04-24T15:22:00")
        },
        "boolean value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "true"}),
          predicate: RDF.value,
          value: RDF::Literal::Boolean.new(true)
        },
        "integer value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "1"}),
          predicate: RDF.value,
          value: RDF::Literal::Integer.new(1)
        },
        "decimal value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "1.1"}),
          predicate: RDF.value,
          value: RDF::Literal::Decimal.new(1.1)
        },
        "double value" => {
          term: RDF::Vocabulary::Term.new(:foo, label: "foo", attributes: {:"rdf:value" => "1.1e1"}),
          predicate: RDF.value,
          value: RDF::Literal::Double.new(1.1e1)
        },
        "literal value" => {term: RDF::RDFS[""], predicate: RDF::Vocab::DC11.title, value: RDF::Literal("The RDF Schema vocabulary \(RDFS\)")},
      }.each do |pred, props|
        it "emits #{pred}" do
          graph = RDF::Graph.new {|g| props[:term].each_statement {|s| g << s}}

          expect(graph.map(&:subject)).to all(eql(props[:term]))
          expect(graph.query(predicate: props[:predicate]).map(&:object)).to include props[:value]
        end
      end
    end
  end
end
