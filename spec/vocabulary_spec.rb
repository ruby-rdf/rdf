require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Vocabulary do
  VOCABS = %w(owl rdf rdfs xsd)
  STRICT_VOCABS = %w(owl rdf rdfs)

  context "#initialize" do
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

    it "allows #send" do
      expect {subject.send(:foo)}.not_to raise_error
      expect(subject.send(:foo)).to be_a(RDF::Vocabulary::Term)
    end

    it "allows #public_send" do
      expect {subject.public_send(:foo)}.not_to raise_error
      expect(subject.public_send(:foo)).to be_a(RDF::Vocabulary::Term)
    end

    it "does not add to @@uris" do
      RDF::Vocabulary.new("http://example/")
      expect(RDF::Vocabulary.class_variable_get(:"@@uris")).to be_a(Hash)
      expect(RDF::Vocabulary.class_variable_get(:"@@uris").values).not_to include("http://example/")
    end
  end

  describe ".each" do
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
    [RDF, RDF::RDFS, RDF::OWL, RDF::XSD].each do |vocab|
      context vocab do
        subject {vocab.to_enum}
        it {should be_enumerable}
        its(:count) {is_expected.to be >= 30}
        it "enumerates statements" do
          expect {|b| subject.each(&b)}.to yield_control.at_least(10).times
          subject.each {|s| expect(s).to be_statement}
        end
      end
    end

    context "RDFS" do
      subject {RDF::RDFS.to_enum}
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
  end

  describe "#property" do
    subject {RDF::XSD}
    it "returns the 'property' term within the vocabulary" do
      expect(subject.property).to be_a(RDF::Vocabulary::Term)
      expect(subject.property).to eq "http://www.w3.org/2001/XMLSchema#property"
    end

    it "defines the named property" do
      subject.property :foo, label: "Foo"
      expect(subject.foo).to eq "http://www.w3.org/2001/XMLSchema#foo"
      expect(subject.foo.label).to eq "Foo"
    end

    it "defines an ontology if symbol is empty" do
      subject.property :"", label: "Ontology"
      expect(subject[:""]).to eq "http://www.w3.org/2001/XMLSchema#"
      expect(subject[:""].label).to eq "Ontology"
      expect(subject.ontology).to eql subject[:""]
    end

    it "defines property with Term values" do
      subject.property :Foo, subClassOf: RDF::Vocabulary::Term.new("_:bar",
        attributes: {
          label: "Bar"
        })
      expect(subject[:Foo]).to eq "http://www.w3.org/2001/XMLSchema#Foo"
      expect(subject[:Foo].subClassOf).to all(be_a(RDF::Node))
      expect(subject[:Foo].subClassOf).to all(be_a(RDF::Term))
    end
  end

  describe "#ontology" do
    subject {RDF::XSD}
    it "returns the nil if no ontology defined" do
      subject.ontology "http://www.w3.org/2001/XMLSchema"
      subject.remove_instance_variable(:@ontology)
      expect(subject.ontology).to be_nil
    end

    it "defines an ontology otherwise" do
      subject.ontology "http://www.w3.org/2001/XMLSchema", label: "XML Schema"
      expect(subject.ontology).to eq "http://www.w3.org/2001/XMLSchema"
      expect(subject.ontology.label).to eq "XML Schema"
    end

    it "defines a property with an empty symbol if same as namespace" do
      subject.ontology "http://www.w3.org/2001/XMLSchema#", label: "Ontology"
      expect(subject[:""]).to eq "http://www.w3.org/2001/XMLSchema#"
      expect(subject[:""].label).to eq "Ontology"
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
      expect(RDF::Vocabulary.expand_pname(RDF::Value)).to eql RDF::Value
    end

    it "should support Web Ontology Language (OWL)" do
      expect(RDF::OWL).to be_a_vocabulary("http://www.w3.org/2002/07/owl#")
      expect(RDF::OWL).to have_properties("http://www.w3.org/2002/07/owl#", %w(allValuesFrom annotatedProperty annotatedSource annotatedTarget assertionProperty backwardCompatibleWith bottomDataProperty bottomObjectProperty cardinality complementOf datatypeComplementOf deprecated differentFrom disjointUnionOf disjointWith distinctMembers equivalentClass equivalentProperty hasKey hasSelf hasValue imports incompatibleWith intersectionOf inverseOf maxCardinality maxQualifiedCardinality members minCardinality minQualifiedCardinality onClass onDataRange onDatatype onProperties onProperty oneOf priorVersion propertyChainAxiom propertyDisjointWith qualifiedCardinality sameAs someValuesFrom sourceIndividual targetIndividual targetValue topDataProperty topObjectProperty unionOf versionIRI versionInfo withRestrictions))
    end

    it "should support Resource Description Framework (RDF)" do
      expect(RDF).to be_a_vocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
      expect(RDF).to have_properties("http://www.w3.org/1999/02/22-rdf-syntax-ns#", %w(first object predicate rest subject type value))
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
      RDF::RDFS => [RDF::OWL, RDF::Vocab::WOT],
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
    let!(:ttl) {%{
      @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
      @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
      <http://example/Class> a rdfs:Class ; rdfs:Datatype "Class" .
      <http://example/prop> a rdf:Property ; rdfs:Datatype "prop" .
    }}
    let!(:graph) {
      RDF::Graph.new << RDF::Turtle::Reader.new(ttl)
    }
    let!(:vocab) {
      @vocab ||= RDF::Vocabulary.from_graph(graph, url: "http://example/")
    }

    subject {@vocab}

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

    context 'without a uri' do
      let!(:vocab) { @vocab ||= RDF::Vocabulary.from_graph(graph) }

      it "gives a null relative uri" do
        expect(vocab.to_uri).to eq RDF::URI.new(nil)
      end
    end

    context "with existing Vocabulary" do
      let!(:ttl) {%{
        @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
        @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
        <http://example/Klass> a rdfs:Class ; rdfs:Datatype "Class" .
        <http://example/pr0p> a rdf:Property ; rdfs:Datatype "pr0p" .
      }}
      let!(:graph) {
        RDF::Graph.new << RDF::Turtle::Reader.new(ttl)
      }
      subject {RDF::Vocabulary.from_graph(graph, url: "http://example/", class_name: vocab)}

      it "creates terms" do
        expect(subject).to be_a_vocabulary("http://example/")
        expect(subject).to have_properties("http://example/", %w(Klass pr0p))
      end

      it "removes old terms" do
        expect(subject).not_to have_properties("http://example/", %w(Class prop))
      end
    end

    context "with embedded definitions" do
      let!(:ttl) {%{
        @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
        @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
        @prefix owl: <http://www.w3.org/2002/07/owl#> .
        <http://example/Class> a rdfs:Class;
          rdfs:label "Class";
          rdfs:subClassOf [owl:unionOf (<http://example/C1> <http://example/C2>)] .
      }}
      let!(:graph) {
        RDF::Graph.new << RDF::Turtle::Reader.new(ttl)
      }
      let(:klass) {subject[:Class]}
      subject {RDF::Vocabulary.from_graph(graph, url: "http://example/", class_name: vocab)}

      it "creates terms" do
        expect(subject).to be_a_vocabulary("http://example/")
        expect(subject).to have_terms("http://example/", %w(Class))
      end

      it "has embedded subClassOf" do
        expect(klass).to be_a(RDF::Vocabulary::Term)
        expect(klass.subClassOf).to be_a(Array)
        expect(klass.subClassOf.length).to eql 1
      end

      context "subClassOf" do
        let(:sub_class_of) {klass.subClassOf.first}
        it "has embedded unionOf" do
          expect(sub_class_of).to be_a(RDF::Vocabulary::Term)
          expect(sub_class_of.attributes[:"owl:unionOf"]).to be_a(Array)
          expect(sub_class_of.attributes[:"owl:unionOf"].length).to eql 1
        end

        context "unionOf" do
          let(:union_of) {sub_class_of.attributes[:"owl:unionOf"].first}

          it "has embedded unionOf" do
            expect(union_of).to be_a_list
            expect(union_of.length).to eql 2
            expect(union_of.first).to eql RDF::URI("http://example/C1")
            expect(union_of.last).to eql RDF::URI("http://example/C2")
          end
        end
      end

      it "emits same triples as source" do
        expect(subject.to_enum).to be_equivalent_graph(graph)
      end
    end
  end

  describe RDF::Vocabulary::Term do
    context RDF::RDFS.comment do
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
    end

    context RDF::RDFS.Class do
      subject {RDF::RDFS.Class}
      specify {is_expected.to respond_to(:vocab)}
      specify {is_expected.to respond_to(:type)}
      specify {is_expected.to respond_to(:label)}
      specify {is_expected.to respond_to(:comment)}
      specify {is_expected.to respond_to(:subClassOf)}
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

    context ".new" do
      subject {
        RDF::Vocabulary::Term.new(:foo,
                                  attributes: {
                                    label: "foo",
                                    domain: RDF::RDFS.Resource,
                                    range: [RDF::RDFS.Resource, RDF::RDFS.Class],
                                    "schema:domainIncludes" => RDF::RDFS.Resource,
                                    "schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class],
                                  })
      }
      it {is_expected.to be_a(RDF::URI)}
      it {is_expected.to be_a(RDF::Vocabulary::Term)}
      its(:label) {is_expected.to eq "foo"}
      its(:domain) {is_expected.to include(RDF::RDFS.Resource)}
      its(:range) {is_expected.to include(RDF::RDFS.Resource, RDF::RDFS.Class)}
      its(:attributes) {is_expected.to include("schema:domainIncludes" => RDF::RDFS.Resource)}
      its(:attributes) {is_expected.to include("schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class])}
    end

    describe "with a BNode Label" do
      subject {
        RDF::Vocabulary::Term.new(:"_:foo",
                                  attributes: {
                                    label: "foo",
                                    domain: RDF::RDFS.Resource,
                                    range: [RDF::RDFS.Resource, RDF::RDFS.Class],
                                    "schema:domainIncludes" => RDF::RDFS.Resource,
                                    "schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class],
                                  })
      }
      it {is_expected.to be_a(RDF::Node)}
      it {is_expected.to be_a(RDF::Vocabulary::Term)}
      its(:label) {is_expected.to eq "foo"}
      its(:domain) {is_expected.to include(RDF::RDFS.Resource)}
      its(:range) {is_expected.to include(RDF::RDFS.Resource, RDF::RDFS.Class)}
      its(:attributes) {is_expected.to include("schema:domainIncludes" => RDF::RDFS.Resource)}
      its(:attributes) {is_expected.to include("schema:rangeIncludes" => [RDF::RDFS.Resource, RDF::RDFS.Class])}
    end

    describe "with a nil Label" do
      subject {
        RDF::Vocabulary::Term.new(nil, attributes: {label: "foo"})
      }
      it {is_expected.to be_a(RDF::Node)}
      it {is_expected.to be_a(RDF::Vocabulary::Term)}
      its(:label) {is_expected.to eq "foo"}
    end

    context "#each_statement" do
      it "emits statements for a vocabulary" do
        graph = RDF::Graph.new {|g| RDF::RDFS[""].each_statement {|s| g << s}}

        expect(graph.map(&:subject)).to all(eql(RDF::RDFS.to_uri))
        expect(graph.query(predicate: RDF.type).map(&:object)).to include RDF::OWL.Ontology
      end

      {
        "rdf:type" => {term: RDF.type, predicate: RDF.type, value: RDF.Property},
        "rdfs:comment" => {term: RDF::RDFS.comment, predicate: RDF::RDFS.comment, value: RDF::Literal(%(A description of the subject resource.))},
        "rdfs:label" => {term: RDF::RDFS.label, predicate: RDF::RDFS.label, value: RDF::Literal("label")},
        "rdfs:subClassOf" => {term: RDF::RDFS.Class, predicate: RDF::RDFS.subClassOf, value: RDF::RDFS.Resource},
        "rdfs:subPropertyOf" => {term: RDF::RDFS.isDefinedBy, predicate: RDF::RDFS.subPropertyOf, value: RDF::RDFS.seeAlso},
        "rdfs:domain" => {term: RDF::RDFS.domain, predicate: RDF::RDFS.domain, value: RDF.Property},
        "rdfs:range" => {term: RDF::RDFS.range, predicate: RDF::RDFS.range, value: RDF::RDFS.Class},
        "rdfs:isDefinedBy" => {term: RDF::RDFS.Class, predicate: RDF::RDFS.isDefinedBy, value: RDF::RDFS.to_uri},

        "owl:inverseOf" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {inverseOf: RDF::RDFS.Resource.to_s}),
          predicate: RDF::OWL.inverseOf,
          value: RDF::RDFS.Resource
        },

        "schema:domainIncludes" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {domainIncludes: RDF::RDFS.Resource.to_s}),
          predicate: RDF::Vocab::SCHEMA.domainIncludes,
          value: RDF::RDFS.Resource
        },
        "schema:rangeIncludes" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {rangeIncludes: RDF::RDFS.Resource.to_s}),
          predicate: RDF::Vocab::SCHEMA.rangeIncludes,
          value: RDF::RDFS.Resource
        },

        "skos:altLabel" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {altLabel: "foo"}),
          predicate: RDF::Vocab::SKOS.altLabel,
          value: RDF::Literal("foo")
        },
        "skos:broader" => {
          term: RDF::Vocabulary::Term.new(:foo, broader: "foo", attributes: {broader: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.broader,
          value: RDF::URI("http://example/Concept")
        },
        "skos:definition" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {definition: "foo"}),
          predicate: RDF::Vocab::SKOS.definition,
          value: RDF::Literal("foo")
        },
        "skos:editorialNote" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {editorialNote: "foo"}),
          predicate: RDF::Vocab::SKOS.editorialNote,
          value: RDF::Literal("foo")
        },
        "skos:exactMatch" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {exactMatch: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.exactMatch,
          value: RDF::URI("http://example/Concept")
        },
        "skos:hasTopConcept" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {hasTopConcept: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.hasTopConcept,
          value: RDF::URI("http://example/Concept")
        },
        "skos:inScheme" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {inScheme: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.inScheme,
          value: RDF::URI("http://example/Concept")
        },
        "skos:member" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {member: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.member,
          value: RDF::URI("http://example/Concept")
        },
        "skos:narrower" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {narrower: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.narrower,
          value: RDF::URI("http://example/Concept")
        },
        "skos:notation" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {notation: "foo"}),
          predicate: RDF::Vocab::SKOS.notation,
          value: RDF::Literal("foo")
        },
        "skos:note" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {note: "foo"}),
          predicate: RDF::Vocab::SKOS.note,
          value: RDF::Literal("foo")
        },
        "skos:prefLabel" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {prefLabel: "foo"}),
          predicate: RDF::Vocab::SKOS.prefLabel,
          value: RDF::Literal("foo")
        },
        "skos:related" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {related: "http://example/Concept"}),
          predicate: RDF::Vocab::SKOS.related,
          value: RDF::URI("http://example/Concept")
        },

        "vocab value" => {term: RDF::RDFS.isDefinedBy, predicate: RDF::RDFS.isDefinedBy, value: RDF::RDFS.to_uri},
        "term value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdfs:seeAlso": "rdfs:seeAlso"}),
          predicate: RDF::RDFS.seeAlso,
          value: RDF::RDFS.seeAlso
        },
        "uri value" => {term: RDF::RDFS[""], predicate: RDF::RDFS.seeAlso, value: RDF::URI("http://www.w3.org/2000/01/rdf-schema-more")},
        "date value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "2016-04-24"}),
          predicate: RDF.value,
          value: RDF::Literal::Date.new("2016-04-24")
        },
        "dateTime value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "2016-04-24T15:22:00"}),
          predicate: RDF.value,
          value: RDF::Literal::DateTime.new("2016-04-24T15:22:00")
        },
        "boolean value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "true"}),
          predicate: RDF.value,
          value: RDF::Literal::Boolean.new(true)
        },
        "integer value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "1"}),
          predicate: RDF.value,
          value: RDF::Literal::Integer.new(1)
        },
        "decimal value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "1.1"}),
          predicate: RDF.value,
          value: RDF::Literal::Decimal.new(1.1)
        },
        "double value" => {
          term: RDF::Vocabulary::Term.new(:foo, attributes: {"rdf:value": "1.1e1"}),
          predicate: RDF.value,
          value: RDF::Literal::Double.new(1.1e1)
        },
        "literal value" => {term: RDF::RDFS[""], predicate: RDF::Vocab::DC11.title, value: RDF::Literal("The RDF Schema vocabulary \(RDFS\)")},
      }.each do |pred, props|
        it "emits #{pred}" do
          graph = RDF::Graph.new {|g| props[:term].each_statement {|s| g << s}}

          expect(graph.map(&:subject)).to all(eql(props[:term]))
          expect(graph.query(predicate: props[:predicate]).map(&:object)).to all(be_a(props[:value].class))
          expect(graph.query(predicate: props[:predicate]).map(&:object)).to include props[:value]
        end
      end
    end
  end

  require 'rdf/vocab/writer'
  describe RDF::Vocabulary::Writer do
    after(:each) do
      Object.send(:remove_const, :Foo)
    end
    let!(:ttl) {%{
      @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
      @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
      <http://example/Class> a rdfs:Class ; rdfs:Datatype "Class" .
      <http://example/prop> a rdf:Property ; rdfs:Datatype "prop" .
    }}
    let!(:graph) {
      RDF::Graph.new << RDF::Turtle::Reader.new(ttl)
    }
    let!(:serialization) {RDF::Vocabulary::Writer.buffer(class_name: "Foo", module_name: "Bar", base_uri: "http://example/") {|w| w << graph}}

    [
      /module Bar/,
      /class Foo/,
      /term :Class,\s+label: "Class".freeze,\s+"rdfs:Datatype": "Class".freeze,\s+type: "rdfs:Class".freeze/m,
      /term :prop,\s+label: "prop".freeze,\s+"rdfs:Datatype": "prop".freeze,\s+type: "rdf:Property".freeze/m,
    ].each do |regexp,|
      it "matches #{regexp}" do
        expect(serialization).to match(regexp)
      end
    end

    context "Embedded Concept" do
      let!(:ttl) {%{
        @prefix jur: <http://sweet.jpl.nasa.gov/2.3/humanJurisdiction.owl#>.
        @prefix dce: <http://purl.org/dc/elements/1.1/>.
        @prefix dct: <http://purl.org/dc/terms/>.
        @prefix foaf: <http://xmlns.com/foaf/0.1/>.
        @prefix owl: <http://www.w3.org/2002/07/owl#>.
        @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>.
        @prefix skos: <http://www.w3.org/2004/02/skos/core#>.
        @prefix country: <http://eulersharp.sourceforge.net/2003/03swap/countries#>.
        country:af
        	a jur:Country;
        	rdfs:isDefinedBy <http://eulersharp.sourceforge.net/2003/03swap/countries#>;
        	skos:exactMatch [
        		a skos:Concept; skos:inScheme country:iso3166-1-alpha-2; skos:notation "af"^^country:iso3166-1-alpha-2DT], [
        		a skos:Concept; skos:inScheme country:iso3166-1-alpha-3; skos:notation "afg"^^country:iso3166-1-alpha-3DT];
        	foaf:name """Afghanistan"""@en.
      }}
      let!(:serialization) {RDF::Vocabulary::Writer.buffer(class_name: "Foo", module_name: "Bar", base_uri: "http://eulersharp.sourceforge.net/2003/03swap/countries#") {|w| w << graph}}

      [
        /module Bar/,
        /class Foo/,
        /term :af/,
        /exactMatch: \[RDF::Vocabulary::Term.new\(nil/,
        /type: %\(skos:Concept\).freeze/,
        /notation: %\(af\).freeze/,
        /inScheme: %\(foo:iso3166-1-alpha-2\).freeze/,
        /notation: %\(afg\).freeze/,
        /inScheme: %\(foo:iso3166-1-alpha-3\).freeze/,
        /"foaf:name": "Afghanistan".freeze/,
        /isDefinedBy: "foo:".freeze/,
        /label: "af".freeze/,
        /type: "http:\/\/sweet.jpl.nasa.gov\/2.3\/humanJurisdiction.owl\#Country".freeze/,
      ].each do |regexp,|
        it "matches #{regexp}" do
          expect(serialization).to match(regexp)
        end
      end
    end

    context "owl:unionOf" do
      let!(:ttl) {%{
        @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
        @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
        @prefix owl: <http://www.w3.org/2002/07/owl#> .
        <http://example/Class> a rdfs:Class;
          rdfs:label "Class";
          rdfs:subClassOf [owl:unionOf (<http://example/C1> <http://example/C2>)] .
      }}
      let!(:serialization) {RDF::Vocabulary::Writer.buffer(class_name: "Foo", module_name: "Bar", base_uri: "http://example/") {|w| w << graph}}

      [
        /module Bar/,
        /class Foo/,
        /term :Class/,
        /label: "Class".freeze/,
        /subClassOf: RDF::Vocabulary::Term.new\(nil,/,
        /"owl:unionOf": RDF::List\[/,
        /RDF::URI\("http:\/\/example\/C1".freeze\)/,
        /RDF::URI\("http:\/\/example\/C2".freeze\)/,
        /type: "rdfs:Class".freeze/,
      ].each do |regexp,|
        it "matches #{regexp}" do
          expect(serialization).to match(regexp)
        end
      end
    end
  end
end
