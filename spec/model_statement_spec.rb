require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Statement do
  let(:s) {RDF::URI.new("https://rubygems.org/gems/rdf")}
  let(:p) {RDF::URI("http://purl.org/dc/terms/creator")}
  let(:o) {RDF::URI.new("http://ar.to/#self")}
  let(:stmt) {RDF::Statement.new(s, p, o)}
  subject {stmt}

  context "when initializing" do
    it "should be instantiable with a hash argument" do
      expect { RDF::Statement.new(subject: s,
                                  predicate: p,
                                  object: o) }.not_to raise_error

    end

    it "should not alter a hash argument" do
      hash = { subject: s, predicate: p, object: o }
      original_hash = hash.dup
      RDF::Statement.new(hash)
      expect(original_hash).to eq hash
    end

    it "should not alter its options argument" do
      options = { graph_name: RDF::URI("URI:http://usefulinc.com/ns/doap#name") }
      original_options = options.dup
      RDF::Statement.new(s, p, o, options)
      expect(options).to eq original_options
    end

    context "allows arguments to be term or implement #to_term" do
      [
        {subject: RDF::List("foo"), predicate: RDF::URI("p"), object: RDF::URI("o")},
        {subject: RDF::URI("s"), predicate: RDF::URI("p"), object: RDF::List("foo")},
        [RDF::List("foo"), RDF::URI("p"), RDF::URI("o")],
        [RDF::URI("s"), RDF::URI("p"), RDF::List("foo")],
      ].each do |arg|
        if arg.is_a?(Array)
          specify {expect{RDF::Statement.new(*arg)}.not_to raise_error}
        else
          specify {expect{RDF::Statement.new(arg)}.not_to raise_error}
        end
      end
    end

    context "raises an error if any argument does not a term or does not implement #to_term" do
      [
        {subject: RDF::Graph.new, predicate: RDF::URI("p"), object: RDF::URI("o")},
        {subject: RDF::URI("s"), predicate: RDF::URI("p"), object: RDF::Graph.new},
        [RDF::Graph.new, RDF::URI("p"), RDF::URI("o")],
        [RDF::URI("s"), RDF::URI("p"), RDF::Graph.new],
      ].each do |arg|
        if arg.is_a?(Array)
          specify {expect{RDF::Statement.new(*arg)}.to raise_error(NotImplementedError)}
        else
          specify {expect{RDF::Statement.new(arg)}.to raise_error(NotImplementedError)}
        end
      end
    end
  end

  context "when created" do
    it "should not require arguments" do
      expect { RDF::Statement.new }.not_to raise_error
    end

    it {is_expected.to have_subject}
    its(:subject) {is_expected.not_to be_nil}
    it {expect(subject.has_predicate?).to be_truthy}
    its(:predicate) {is_expected.not_to be_nil}
    it {is_expected.to have_object}
    its(:object) {is_expected.not_to be_nil}
    it {is_expected.to be_asserted}
    it {is_expected.not_to be_quoted}
    it {is_expected.to be_statement}
    it {is_expected.not_to be_inferred}
  end

  context "when created with a blank node subject" do
    subject {RDF::Statement.new(RDF::Node.new, p, o)}
    it {is_expected.to be_node}
  end

  context "when created with a blank node object" do
    subject {RDF::Statement.new(s, p, RDF::Node.new)}
    it {is_expected.to be_node}
  end

  context "when created without a graph_name" do
    subject {RDF::Statement.new(s, p, o, graph_name: nil)}
    its(:graph_name) {is_expected.to be_nil}
    it {is_expected.not_to have_graph}
  end

  context "when created with a graph_name" do
    subject {RDF::Statement.new(s, p, o, graph_name: s)}
    it {is_expected.to have_graph}
    its(:graph_name) {is_expected.not_to be_nil}
    it {is_expected.to eq stmt}
    it {is_expected.not_to eql stmt}
  end

  context "when created with a default graph" do
    subject {RDF::Statement.new(s, p, o, graph_name: false)}
    let(:stmtc) {RDF::Statement.new(s, p, o, graph_name: s)}
    it {is_expected.not_to have_graph}
    its(:graph_name) {is_expected.to eq false}
    it {is_expected.to eq stmt}
    it {is_expected.to eq stmtc}
    it {is_expected.to_not eql stmtc}
  end

  context "when used with symbols" do
    specify {expect(RDF::Statement(:s, p, o)).to eq (RDF::Statement(:s, p, o))}
    specify {expect(RDF::Statement(:s, p, o)).to eql (RDF::Statement(:s, p, o))}
    specify {expect(RDF::Statement(s, p, :o)).to eq (RDF::Statement(s, p, :o))}
    specify {expect(RDF::Statement(s, p, :o)).to eql (RDF::Statement(s, p, :o))}
  end

  context "when used with strings" do
    specify {expect(RDF::Statement(s, p, "o")).to eq (RDF::Statement(s, p, "o"))}
    specify {expect(RDF::Statement(s, p, "o")).to eql (RDF::Statement(s, p, RDF::Literal("o")))}
    specify {expect(RDF::Statement(s, p, RDF::Literal("o"))).to eql (RDF::Statement(s, p, "o"))}
  end

  context "when used like an Array" do
    it {is_expected.to respond_to(:to_a)}
    it {is_expected.to respond_to(:[])}
    it {is_expected.to respond_to(:[]=)}
    its(:to_a) {is_expected.to eql([stmt.subject, stmt.predicate, stmt.object])}

    it "should support #[] for the subject" do
      expect(subject[0]).to equal(subject.subject)
    end

    it "should support #[] for the predicate" do
      expect(subject[1]).to equal(subject.predicate)
    end

    it "should support #[] for the object" do
      expect(subject[2]).to equal(subject.object)
    end

    it "should support #[] for the graph_name" do
      expect(subject[3]).to equal(subject.graph_name)
    end

    it "should support #[]= for the subject" do
      stmt = subject.dup
      stmt[0] = s = RDF::URI("http://example.org/subject")
      expect(stmt.subject).to eq s
    end

    it "should support #[]= for the predicate" do
      stmt = subject.dup
      stmt[1] = p = RDF::URI("http://example.org/predicate")
      expect(stmt.predicate).to eq p
    end

    it "should support #[]= for the object" do
      stmt = subject.dup
      stmt[2] = o = RDF::URI("http://example.org/object")
      expect(stmt.object).to eq o
    end

    it "should support #[]= for the graph_name" do
      stmt = subject.dup
      stmt[3] = c = RDF::URI("http://example.org/graph_name")
      expect(stmt.graph_name).to eq c
    end
  end

  context "when marked as inferred" do
    subject {RDF::Statement.new(RDF::Node.new, p, o, inferred: true)}
    it {is_expected.to be_inferred}
  end

  it {is_expected.to respond_to(:to_h)}
  its(:to_h) do
    is_expected.to eql({
      subject:    stmt.subject,
      predicate:  stmt.predicate,
      object:     stmt.object,
      graph_name: stmt.graph_name,
    })
  end

  it {is_expected.to respond_to(:to_s)}
  its(:to_s) {is_expected.to eql "<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."}

  context "when comparing equality" do
    let(:gn) {RDF::URI.parse("http://example.org/graph_name")}
    let(:other_stmt) {RDF::Statement.new(s, p, o, graph_name: gn)}

    it "should == regardless of graph_name" do
      expect(subject).to eq other_stmt
    end

    it "should not be eql? with differing graph_names" do
      expect(subject).not_to eql other_stmt
    end

    it "should match (===) a statement with a missing component to one with that component" do
      expect(subject === other_stmt).to be_truthy
    end

    it "should not match (===) a statement with a component to one which is missing that component" do
      expect(other_stmt === subject).not_to be_truthy
    end

    it "should only equals? with object equality" do
      expect(subject).not_to equal RDF::Statement.new s, p, o
      expect(subject).to equal subject
    end

    it "is not == a RDF::List" do
      expect(subject).not_to eq RDF::List[*subject]
    end

    specify {expect(RDF::Statement(:s, p, o).hash).to eq (RDF::Statement(:s, p, o).hash)}
  end

  context "completness" do
    {
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::Node("node"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Node("node")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal")) => true,
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(nil, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil) => false,
      RDF::Statement.new(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => true,
    }.each do |st, complete|
      if complete
        specify {expect(st).to be_complete}
        specify {expect(st).not_to be_incomplete}
      else
        specify {expect(st).not_to be_complete}
        specify {expect(st).to be_incomplete}
      end
    end
  end

  context "validatation" do
    {
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::Node("node"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Node("node")) => true,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal")) => true,
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(nil, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil) => false,
      RDF::Statement.new(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI('scheme://auth/\\u0000'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI('scheme://auth/^'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI('scheme://auth/`'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI('scheme://auth/\\'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
    }.each do |st, valid|
      context "given #{st}" do
        if valid
          specify {expect(st).to be_valid}
          specify {expect(st).not_to be_invalid}
          describe "#validate!" do
            specify {expect {st.validate!}.not_to raise_error}
          end
        else
          specify {expect(st).not_to be_valid}
          specify {expect(st).to be_invalid}
          describe "#validate!" do
            specify {expect {st.validate!}.to raise_error(ArgumentError)}
          end
        end
      end
    end
  end

  context "c14n" do
    {
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal")) =>
        RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal")),
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI('file:///path/to/file%20with%20spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(nil, RDF::URI("http://purl.org/dc/terms/creator").dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil) => nil,
      RDF::Statement.new(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => nil,
    }.each do |st, result|
      context "given #{st}" do
        if result
          specify {expect {st.canonicalize!}.not_to raise_error}
          specify {expect(st.canonicalize!).to eq result}
          specify {expect(st.canonicalize).to eq result}
          specify {expect(st.canonicalize).to be_valid}
        else
          specify {expect {st.canonicalize!}.to raise_error(ArgumentError)}
          specify {expect(st.canonicalize).to be_nil}
        end
      end
    end
  end

  context "Examples" do
    let(:uri) {RDF::URI("http://example/")}

    it "Creating an RDF statement" do
      expect(RDF::Statement.new(s, p, o)).to be_a_statement
    end

    it "Creating an RDF statement from a Hash" do
      expect(RDF::Statement.new({
        subject:   RDF::URI.new("https://rubygems.org/gems/rdf"),
        predicate: RDF::URI("http://purl.org/dc/terms/creator"),
        object:    RDF::URI.new("http://ar.to/#self"),
      })).to be_a_statement
    end

    it "Creating an RDF statement with a graph_name" do
      expect(RDF::Statement.new(s, p, o, graph_name: uri).graph_name).to eq uri
    end

    it "Creating an RDF statement from a Hash" do
      expect(RDF::Statement.new({
        subject:   RDF::URI.new("https://rubygems.org/gems/rdf"),
        predicate: RDF::URI("http://purl.org/dc/terms/creator"),
        object:    RDF::URI.new("http://ar.to/#self"),
      })).to be_a_statement
    end

    it "Creating an RDF statement with interned nodes" do
      s = RDF::Node.intern("s")
      o = RDF::Node.intern("o")
      expect(RDF::Statement.new(:s, p, :o)).to eql RDF::Statement.new(s, p, o)
    end

    it "Creating an RDF statement with interned nodes" do
      o = RDF::Literal("o")
      expect(RDF::Statement.new(s, p, "o")).to eql RDF::Statement.new(s, p, o)
    end
  end
end
