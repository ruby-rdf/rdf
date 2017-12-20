require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Value do
  subject {"".extend(RDF::Value)}
  let(:uri) {RDF::URI("http://example/")}
  let(:node) {RDF::Node.new}
  let(:literal) {RDF::Literal("")}
  let(:graph) {RDF::Graph.new}
  let(:statement) {RDF::Statement(RDF::URI("http::/a"), RDF::URI("http::/b"), "c")}
  let(:variable) {RDF::Query::Variable.new(:v)}
  let(:list) {RDF::List[]}

  it "should not be instantiable" do
    expect { described_class.new }.to raise_error(NoMethodError)
  end

  it "#graph?" do
    expect(graph).to be_graph
    [subject, uri, node, literal, statement, variable, list].each do |v|
      expect(v).not_to be_graph
    end
  end

  it "#statement?" do
    expect(statement).to be_statement
    [subject, uri, node, literal, graph, variable, list].each do |v|
      expect(v).not_to be_statement
    end
  end

  it "#list?" do
    expect(list).to be_list
    [subject, statement, uri, node, literal, graph, statement, variable].each do |v|
      expect(v).not_to be_list
    end
  end

  it "#term?" do
    [uri, node, literal, variable].each do |v|
      expect(v).to be_term
    end
    [subject, statement, graph, statement, list].each do |v|
      expect(v).not_to be_term
    end
  end

  it "#resource?" do
    [uri, node].each do |v|
      expect(v).to be_resource
    end
    [subject, statement, graph, statement, list, literal, variable].each do |v|
      expect(v).not_to be_resource
    end
  end

  it "#literal?" do
    expect(literal).to be_literal
    [subject, statement, uri, node, graph, statement, variable, list].each do |v|
      expect(v).not_to be_literal
    end
  end

  it "#node?" do
    expect(node).to be_node
    [subject, uri, literal, graph, statement, variable, list].each do |v|
      expect(v).not_to be_node
    end
    expect(RDF::Statement(:a, :b, :c)).to be_node
  end

  it "#iri?" do
    expect(uri).to be_iri
    [subject, node, literal, graph, statement, variable, list].each do |v|
      expect(v).not_to be_iri
    end
  end

  it "#uri?" do
    expect(uri).to be_uri
    [subject, node, literal, graph, statement, variable, list].each do |v|
      expect(v).not_to be_uri
    end
  end

  it "#variable?" do
    expect(variable).to be_variable
    [subject, uri, node, literal, graph, statement, list].each do |v|
      expect(v).not_to be_variable
    end
    expect(RDF::Statement(:a, :b, RDF::Query::Variable.new(:c))).to be_variable
  end

  it "#constant?" do
    expect(variable).not_to be_constant
    [subject, uri, node, literal, graph, statement, list].each do |v|
      expect(v).to be_constant
    end
    expect(RDF::Statement(:a, :b, RDF::Query::Variable.new(:c))).not_to be_constant
  end

  it "#anonymous?" do
    is_expected.not_to be_anonymous
    expect(node).to be_anonymous
    [subject, uri, literal, graph, statement, variable, list].each do |v|
      expect(v).not_to be_anonymous
    end
    expect(RDF::Statement(:a, :b, :c)).not_to be_anonymous
  end

  it "#valid?" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect(v).to be_valid
    end
    expect(RDF::URI("invalid")).not_to be_valid
  end

  it "#invalid?" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect(v).not_to be_invalid
    end
    expect(RDF::URI("invalid")).to be_invalid
  end

  it "#validate!" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect {v.validate!}.not_to raise_error
    end
    expect {RDF::URI("invalid").validate!}.to raise_error(ArgumentError)
  end

  it "#canonicalize" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect(v.canonicalize).not_to equal v
    end
  end

  it "#canonicalize!" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect(v.canonicalize!).to equal v
    end
  end

  it "#to_rdf" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect {v.to_rdf}.not_to raise_error
    end
  end

  it "#to_ruby" do
    [statement, uri, node, literal, graph, statement, variable, list].each do |v|
      expect {v.to_ruby}.not_to raise_error
    end
  end

  it "#to_term" do
    [uri, node, literal, variable, list].each do |v|
      expect {v.to_term}.not_to raise_error
    end
    [statement, graph, statement].each do |v|
      expect {v.to_term}.to raise_error(NotImplementedError)
    end
  end

  context "Examples" do
    it "Checking if a value is a resource (blank node or URI reference)" do
    end

    it "Checking if a value is a blank node" do
    end

    it "Checking if a value is a URI reference" do
    end

    it "Checking if a value is a literal" do
    end
  end
end
