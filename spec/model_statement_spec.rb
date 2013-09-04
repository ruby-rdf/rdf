require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Statement do
  let(:s) {RDF::URI.new("http://rubygems.org/gems/rdf")}
  let(:p) {RDF::DC.creator}
  let(:o) {RDF::URI.new("http://ar.to/#self")}
  let(:stmt) {RDF::Statement.new(s, p, o)}
  subject {stmt}

  context "when initializing" do
    it "should be instantiable with a hash argument" do
      expect { RDF::Statement.new(:subject => s,
                                  :predicate => p,
                                  :object => o) }.not_to raise_error

    end

    it "should not alter a hash argument" do
      hash = { :subject => s, :predicate => p, :object => o }
      original_hash = hash.dup
      stmt = RDF::Statement.new(hash)
      expect(original_hash).to eq hash
    end

    it "should not alter its options argument" do
      options = { :context => RDF::DOAP.name }
      original_options = options.dup
      stmt = RDF::Statement.new(s, p, o, options)
      expect(options).to eq original_options
    end
  end

  context "when created" do
    it "should not require arguments" do
      expect { RDF::Statement.new }.not_to raise_error
    end

    it {should have_subject}
    its(:subject) {should_not be_nil}
    it {expect(subject.has_predicate?).to be_true}
    its(:predicate) {should_not be_nil}
    it {should have_object}
    its(:object) {should_not be_nil}
    it {should be_asserted}
    it {should_not be_quoted}
    it {should be_statement}
  end

  context "when created with a blank node subject" do
    subject {RDF::Statement.new(RDF::Node.new, p, o)}
    it {should have_blank_nodes}
  end

  context "when created with a blank node object" do
    subject {RDF::Statement.new(s, p, RDF::Node.new)}
    it {should have_blank_nodes}
  end

  context "when created without a context" do
    subject {RDF::Statement.new(s, p, o, :context => nil)}
    its(:context) {should be_nil}
    it {should_not have_context}
  end

  context "when created with a context" do
    subject {RDF::Statement.new(s, p, o, :context => s)}
    it {should have_context}
    its(:context) {should_not be_nil}
    it {should eq stmt}
    it {should_not eql stmt}
  end

  context "when created with a default context" do
    subject {RDF::Statement.new(s, p, o, :context => false)}
    let(:stmtc) {RDF::Statement.new(s, p, o, :context => s)}
    it {should_not have_context}
    its(:context) {should == false}
    it {should == stmt}
    it {should == stmtc}
    it {should_not eql stmtc}
  end

  context "when used like an Array" do
    it {should respond_to(:to_a)}
    it {should respond_to(:[])}
    it {should respond_to(:[]=)}
    its(:to_a) {should eql([stmt.subject, stmt.predicate, stmt.object])}

    it "should support #[] for the subject" do
      subject[0].should equal(subject.subject)
    end

    it "should support #[] for the predicate" do
      subject[1].should equal(subject.predicate)
    end

    it "should support #[] for the object" do
      subject[2].should equal(subject.object)
    end

    it "should support #[] for the context" do
      subject[3].should equal(subject.context)
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

    it "should support #[]= for the context" do
      stmt = subject.dup
      stmt[3] = c = RDF::URI("http://example.org/context")
      expect(stmt.context).to eq c
    end
  end

  it {should respond_to(:to_hash)}
  its(:to_hash) do
    should eql({
            :subject   => stmt.subject,
            :predicate => stmt.predicate,
            :object    => stmt.object,
            :context   => stmt.context,
          })
  end

  it {should respond_to(:to_s)}
  its(:to_s) {should eql "<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."}

  context "when comparing equality" do
    let(:c) {RDF::URI.parse("http://example.org/context")}
    let(:other_stmt) {RDF::Statement.new(s, p, o, :context => c)}

    it "should == regardless of context" do
      expect(subject).to eq other_stmt
    end

    it "should not be eql? with differing contexts" do
      expect(subject).not_to eql other_stmt
    end

    it "should match (===) a statement with a missing component to one with that component" do
      expect(subject === other_stmt).to be_true
    end

    it "should not match (===) a statement with a component to one which is missing that component" do
      expect(other_stmt === subject).not_to be_true
    end

    it "should only equals? with object equality" do
      @same_stmt = RDF::Statement.new s, p, o
      expect(subject).not_to equal RDF::Statement.new s, p, o
      expect(subject).to equal subject
    end
  end

  context "validataion" do
    {
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::Node("node"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Node("node")) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Literal("literal")) => true,
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(nil, RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, nil) => false,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => false,
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
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Literal("literal")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Literal("literal")),
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI('file:/path/to/file%20with%20spaces.txt'), RDF::DC.creator, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(nil, RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, nil) => nil,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => nil,
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

    it "Creating an RDF statement with a context" do
      expect(RDF::Statement.new(s, p, o, :context => uri).context).to eq uri
    end

    it "Creating an RDF statement from a Hash" do
      expect(RDF::Statement.new({
        :subject   => RDF::URI.new("http://rubygems.org/gems/rdf"),
        :predicate => RDF::DC.creator,
        :object    => RDF::URI.new("http://ar.to/#self"),
      })).to be_a_statement
    end
  end
end
