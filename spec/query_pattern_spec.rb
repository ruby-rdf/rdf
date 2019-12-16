require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Pattern do
  context "without any variables" do
    subject {described_class.new}

    describe ".from" do
      it "creates using triple array" do
        expect(described_class.from([:s, :p, :o])).to eq described_class.new(:s, :p, :o)
      end

      it "creates using hash" do
        expect(described_class.from({subject: :s, predicate: :p, object: :o})).to eq described_class.new(:s, :p, :o)
      end

      it "creates using quad array" do
        expect(described_class.from([:s, :p, :o, :c])).to eq described_class.new(:s, :p, :o, graph_name: :c)
      end

      it "creates using hash" do
        expect(described_class.from({subject: :s, predicate: :p, object: :o}, graph_name: :c)).to eq described_class.new(:s, :p, :o, graph_name: :c)
        expect(described_class.from({subject: :s, predicate: :p, object: :o, graph_name: :c})).to eq described_class.new(:s, :p, :o, graph_name: :c)
      end
    end

    its(:cost) {is_expected.to be (4+2+1)}

    it "should not have variables" do
      expect(subject.variables?).to be_falsey
      expect(subject.variable_count).to eq 0
      expect(subject.variables).to eq({})
    end

    it "should have no unbound variables" do
      expect(subject.unbound_variables.size).to eq 0
    end

    it "should have no bound variables" do
      expect(subject.bound_variables.size).to eq 0
    end

    it "should not be bound or unbound" do
      expect(subject.unbound?).to be_falsey
      expect(subject.bound?).to be_falsey
    end

    it "should not have bindings" do
      expect(subject).not_to be_bindings
      expect(subject.binding_count).to eq 0
      expect(subject.bindings).to eq({})
    end
  end

  context "with one bound variable" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    subject {described_class.new(s)}

    specify {is_expected.not_to be_constant}
    specify {is_expected.to be_variable}
    specify {is_expected.to be_bound}

    its(:cost) {is_expected.to be (4+2+1)}

    it "should have one variable" do
      expect(subject).to be_variables
      expect(subject.variable_count).to eq 1
      expect(subject.variables.keys).to eq [:s]
      expect(subject.variables).to eq({s: s})
    end

    it "should have no unbound variables" do
      expect(subject.unbound_variables.size).to eq 0
    end

    it "should have one bound variable" do
      expect(subject.bound_variables.size).to eq 1
      expect(subject.bound_variables).to eq({s: s})
    end

    it "should be fully bound" do
      is_expected.not_to be_unbound
      is_expected.to be_bound
    end

    it "should have one binding" do
      expect(subject).to be_bindings
      expect(subject.binding_count).to eq 1
      expect(subject.bindings).to eq({s: true})
    end
  end

  context "with three bound variables" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    let(:p) {RDF::Query::Variable.new(:p, true)}
    let(:o) {RDF::Query::Variable.new(:o, true)}
    subject {described_class.new(s, p, o)}

    specify {is_expected.not_to be_constant}
    specify {is_expected.to be_variable}
    specify {is_expected.to be_bound}

    its(:cost) {is_expected.to be (4+2+1)}

    it "should have three variables" do
      expect(subject).to be_variables
      expect(subject.variable_count).to eq 3
      expect(subject.variables.keys.map { |key| key.to_s }.sort).to eq [:s, :p, :o].map { |key| key.to_s }.sort
      expect(subject.variables).to eq({s: s, p: p, o: o})
    end

    it "should have no unbound variables" do
      expect(subject.unbound_variables.size).to eq 0
    end

    it "should have three bound variables" do
      expect(subject.bound_variables.size).to eq 3
      expect(subject.bound_variables).to eq({s: s, p: p, o: o})
    end

    it "should be fully bound" do
      is_expected.not_to be_unbound
      is_expected.to be_bound
    end

    it "should have three bindings" do
      expect(subject).to be_bindings
      expect(subject.binding_count).to eq 3
      expect(subject.bindings).to eq({s: true, p: true, o: true})
    end
  end

  context "with variable in different locations" do
    {
      "spog": [[RDF::URI("s"), RDF::URI("p"), RDF::URI("o"), graph_name: RDF::URI("g")], 0],
      "spo?": [[RDF::URI("s"), RDF::URI("p"), RDF::URI("o"), graph_name: :g], 8],
      "sp?g": [[RDF::URI("s"), RDF::URI("p"), :o, graph_name: RDF::URI("g")], 1],
      "s?og": [[RDF::URI("s"), :p, RDF::URI("o"), graph_name: RDF::URI("g")], 2],
      "?pog": [[:s, RDF::URI("p"), RDF::URI("o"), graph_name: RDF::URI("g")], 4],
    }.each do |name, (args, cost)|
      it "cost for #{name} should be #{cost}" do
        pattern = described_class.new(*args)
        expect(pattern.cost).to be cost
      end
    end
  end

  context "#cost" do
    it "can be set separately" do
      expect(subject.cost).to be (4+2+1)
      subject.cost = 0
      expect(subject.cost).to be 0
    end
  end

  context "with a graph_name" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    let(:p) {RDF::Query::Variable.new(:p, true)}
    let(:o) {RDF::Query::Variable.new(:o, true)}
    subject {described_class.new(s, p, o, graph_name: :c)}

    it "uses a variable for a symbol" do
      expect(subject.graph_name).to eq RDF::Query::Variable.new(:c)
    end

    its(:cost) {is_expected.to be (8+4+2+1)}

    it "uses a constant for :default" do
      pattern = described_class.new(s, p, o, graph_name: false)
      expect(pattern.graph_name).to eq false
      expect(pattern.cost).to eq (4+2+1)
    end
  end
  
  context "with unbound variables" do
    let(:s) {RDF::Query::Variable.new(:s)}
    let(:p) {RDF::Query::Variable.new(:p)}
    let(:o) {RDF::Query::Variable.new(:o)}
    subject {described_class.new(s, p, o)}

    specify {is_expected.not_to be_constant}
    specify {is_expected.to be_variable}
    specify {is_expected.not_to be_bound}

    its(:cost) {is_expected.to be (4+2+1)}

    describe "#bind" do
      context "complete solution" do
        let(:solution) {RDF::Query::Solution.new(s: RDF::URI("s"), p: RDF::URI("p"), o: RDF::URI("o"))}
        specify {expect(subject.bind(solution)).not_to be_variable}
      end
      context "incomplete solution" do
        let(:solution) {RDF::Query::Solution.new(s: RDF::URI("s"), p: RDF::URI("p"))}
        specify {expect(subject.bind(solution)).to be_variable}
        specify {expect(subject.bind(solution)).not_to be_bound}
      end
    end
  end

  context "validataion" do
    {
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      described_class.new(nil, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => true,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil) => true,
      described_class.new(:var, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), :var, RDF::URI("http://ar.to/#self")) => true,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), :var) => true,
      described_class.new(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => false,
      described_class.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => false,
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

  context "with one bound and one unbound variable" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    let(:p) {RDF::Query::Variable.new(:p)}
    subject {described_class.new(s, p)}

    specify {is_expected.not_to be_constant}
    specify {is_expected.to be_variable}
    specify {is_expected.not_to be_bound}

    its(:cost) {is_expected.to be (4+2+1)}

    it "should have two variable" do
      expect(subject).to be_variables
      expect(subject.variable_count).to eq 2
      expect(subject.variables.keys).to eq [:s, :p]
      expect(subject.variables).to eq({s: s, p: p})
    end

    it "should have one unbound variables" do
      expect(subject.unbound_variables.size).to eq 1
      expect(subject.unbound_variables).to eq({p: p})
    end

    it "should have one bound variable" do
      expect(subject.bound_variables.size).to eq 1
      expect(subject.bound_variables).to eq({s: s})
    end

    it "should not be fully bound" do
      is_expected.not_to be_unbound
      is_expected.not_to be_bound
    end

    it "should have one binding" do
      expect(subject).to be_bindings
      expect(subject.binding_count).to eq 1
      expect(subject.bindings).to eq({s: true})
    end
  end

  context "Examples" do
    let!(:repo) {RDF::Repository.new {|r| r.insert(RDF::Spec.triples.extend(RDF::Enumerable))}}
    let!(:statement) {repo.detect {|s| s.to_a.none?(&:node?)}}
    let(:pattern) {described_class.new(:s, :p, :o)}
    subject {pattern}
    describe "#execute" do
      it "executes query against repo" do
        expect(subject.execute(repo).to_a.size).to eql repo.count
      end
    end

    describe "#solution" do
      subject {pattern.solution(statement)}
      it("pattern[:s] #=> statement.subject") { expect(subject[:s]).to eq statement.subject}
      it("pattern[:p] #=> statement.predicate") { expect(subject[:p]).to eq statement.predicate}
      it("pattern[:o] #=> statement.object") { expect(subject[:o]).to eq statement.object}
    end

    describe "#variable_terms" do
      it "has term" do
        expect(described_class.new(RDF::Node.new, :p, RDF::Literal(123)).variable_terms).to eq([:predicate])
      end
    end

    describe "#optional" do
      specify {
        expect(described_class.new(:s, :p, :o)).to_not be_optional
        expect(described_class.new(:s, :p, :o, optional: true)).to be_optional
      }
    end
  end
end
