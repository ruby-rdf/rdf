require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Statement do
  let(:s) {RDF::URI.new("http://rubygems.org/gems/rdf")}
  let(:p) {RDF::URI("http://purl.org/dc/terms/creator")}
  let(:o) {RDF::URI.new("http://ar.to/#self")}
  let(:stmt) {RDF::Statement.new(subject: s, predicate: p, object: o)}
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

    context "allows arguments to be term or implement #to_term" do
      [
        {subject: RDF::List("foo"), predicate: RDF::URI("p"), object: RDF::URI("o")},
        {subject: RDF::URI("s"), predicate: RDF::URI("p"), object: RDF::List("foo")},
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
      ].each do |arg|
        specify {expect{RDF::Statement.new(arg)}.to raise_error(NotImplementedError)}
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
  end

  context "when created with a blank node subject" do
    subject {RDF::Statement.new(subject: RDF::Node.new, predicate: p, object: o)}
    it {is_expected.to be_node}
  end

  context "when created with a blank node object" do
    subject {RDF::Statement.new(subject: s, predicate: p, object: RDF::Node.new)}
    it {is_expected.to be_node}
  end

  context "when created without a graph_name" do
    subject {RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: nil)}
    its(:graph_name) {is_expected.to be_nil}
    it {is_expected.not_to have_graph}
  end

  context "when created with a graph_name" do
    subject {RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: s)}
    it {is_expected.to have_graph}
    its(:graph_name) {is_expected.not_to be_nil}
    it {is_expected.to eq stmt}
    it {is_expected.not_to eql stmt}
  end

  context "when created with a default graph" do
    subject {RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: false)}
    let(:stmtc) {RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: s)}
    it {is_expected.not_to have_graph}
    its(:graph_name) {is_expected.to eq false}
    it {is_expected.to eq stmt}
    it {is_expected.to eq stmtc}
    it {is_expected.to_not eql stmtc}
  end

  context "when used with symbols" do
    specify {expect(RDF::Statement(subject: :s, predicate: p, object: o)).to eq  (RDF::Statement(subject: :s, predicate: p, object: o))}
    specify {expect(RDF::Statement(subject: :s, predicate: p, object: o)).to eql (RDF::Statement(subject: :s, predicate: p, object: o))}
    specify {expect(RDF::Statement(subject: s, predicate: p, object: :o)).to eq  (RDF::Statement(subject: s, predicate: p, object: :o))}
    specify {expect(RDF::Statement(subject: s, predicate: p, object: :o)).to eql (RDF::Statement(subject: s, predicate: p, object: :o))}
  end

  context "when used with strings" do
    specify {expect(RDF::Statement(subject: s, predicate: p, object: "o")).to eq  (RDF::Statement(subject: s, predicate: p, object: "o"))}
    specify {expect(RDF::Statement(subject: s, predicate: p, object: "o")).to eql (RDF::Statement(subject: s, predicate: p, object: RDF::Literal("o")))}
    specify {expect(RDF::Statement(subject: s, predicate: p, object: RDF::Literal("o"))).to eql (RDF::Statement(subject: s, predicate: p, object: "o"))}
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

  it {is_expected.to respond_to(:to_hash)}
  its(:to_hash) do
    is_expected.to eql({
      subject:    stmt.subject,
      predicate:  stmt.predicate,
      object:     stmt.object,
      graph_name: stmt.graph_name,
    })
  end

  it {is_expected.to respond_to(:to_s)}
  its(:to_s) {is_expected.to eql "<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."}

  context "when comparing equality" do
    let(:gn) {RDF::URI.parse("http://example.org/graph_name")}
    let(:other_stmt) {RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: gn)}

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
      expect(subject).not_to equal RDF::Statement.new subject: s, predicate: p, object: o
      expect(subject).to equal subject
    end
  end

  context "completness" do
    {
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::Node("node"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Node("node")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Literal("literal")) => true,
      RDF::Statement.new(subject: RDF::URI('file:///path/to/file with spaces.txt'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: nil, predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: nil, object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: nil) => false,
      RDF::Statement.new(subject: RDF::Literal("literal"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::Node("node"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::Literal("literal"), object: RDF::URI("http://ar.to/#self")) => true,
    }.each do |st, complete|
      describe st.to_ntriples do
        if complete
          specify {expect(st).to be_complete}
          specify {expect(st).not_to be_incomplete}
        else
          specify {expect(st).not_to be_complete}
          specify {expect(st).to be_incomplete}
        end
      end
    end
  end

  context "validatation" do
    {
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::Node("node"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Node("node")) => true,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Literal("literal")) => true,
      RDF::Statement.new(subject: RDF::URI('file:///path/to/file with spaces.txt'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: nil, predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: nil, object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: nil) => false,
      RDF::Statement.new(subject: RDF::Literal("literal"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::Node("node"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::Literal("literal"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI('scheme://auth/\\u0000'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI('scheme://auth/^'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI('scheme://auth/`'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(subject: RDF::URI('scheme://auth/\\'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => false,
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
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Literal("literal")) =>
        RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::Literal("literal")),
      RDF::Statement.new(subject: RDF::URI('file:///path/to/file with spaces.txt'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(subject: RDF::URI('file:///path/to/file%20with%20spaces.txt'), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(subject: nil, predicate: RDF::URI("http://purl.org/dc/terms/creator").dup, object: RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: nil, object: RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: nil) => nil,
      RDF::Statement.new(subject: RDF::Literal("literal"), predicate: RDF::URI("http://purl.org/dc/terms/creator"), object: RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(subject: RDF::URI("http://rubygems.org/gems/rdf"), predicate: RDF::Literal("literal"), object: RDF::URI("http://ar.to/#self")) => nil,
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
      expect(RDF::Statement.new(subject: s, predicate: p, object: o)).to be_a_statement
    end

    it "Creating an RDF statement from a Hash" do
      expect(RDF::Statement.new({
        subject:   RDF::URI.new("http://rubygems.org/gems/rdf"),
        predicate: RDF::URI("http://purl.org/dc/terms/creator"),
        object:    RDF::URI.new("http://ar.to/#self"),
      })).to be_a_statement
    end

    it "Creating an RDF statement with a graph_name" do
      expect(RDF::Statement.new(subject: s, predicate: p, object: o, graph_name: uri).graph_name).to eq uri
    end

    it "Creating an RDF statement from a Hash" do
      expect(RDF::Statement.new({
        subject:   RDF::URI.new("http://rubygems.org/gems/rdf"),
        predicate: RDF::URI("http://purl.org/dc/terms/creator"),
        object:    RDF::URI.new("http://ar.to/#self"),
      })).to be_a_statement
    end

    it "Creating an RDF statement with interned nodes" do
      s = RDF::Node.intern("s")
      o = RDF::Node.intern("o")
      expect(RDF::Statement.new(subject: :s, predicate: p, object: :o)).to eql RDF::Statement.new(subject: s, predicate: p, object: o)
    end

    it "Creating an RDF statement with interned nodes" do
      o = RDF::Literal("o")
      expect(RDF::Statement.new(subject: s, predicate: p, object: "o")).to eql RDF::Statement.new(subject: s, predicate: p, object: o)
    end
  end

  describe "1.99 deprecation" do
    it "#initialize expects DEPRECATION when used with positional arguments" do
      expect do
        expect(RDF::Statement.new(s, p, o)).to eql stmt
      end.to write("DEPRECATION").to(:error)
    end
  end
end
