require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Pattern do
  context "without any variables" do
    subject {RDF::Query::Pattern.new}

    describe ".from" do
      it "creates using triple array" do
        expect(RDF::Query::Pattern.from([:s, :p, :o])).to eq RDF::Query::Pattern.new(:s, :p, :o)
      end

      it "creates using hash" do
        expect(RDF::Query::Pattern.from(:subject => :s, :predicate => :p, :object => :o)).to eq RDF::Query::Pattern.new(:s, :p, :o)
      end

      it "creates using quad array" do
        expect(RDF::Query::Pattern.from([:s, :p, :o, :c])).to eq RDF::Query::Pattern.new(:s, :p, :o, :context => :c)
      end

      it "creates using hash" do
        expect(RDF::Query::Pattern.from(:subject => :s, :predicate => :p, :object => :o, :context => :c)).to eq RDF::Query::Pattern.new(:s, :p, :o, :context => :c)
      end
    end

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
      expect(subject.bindings?).to be_falsey
      expect(subject.binding_count).to eq 0
      expect(subject.bindings).to eq({})
    end
  end

  context "with one bound variable" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    subject {RDF::Query::Pattern.new(s)}

    specify {expect(subject).not_to be_constant}
    specify {expect(subject).to be_variable}
    specify {expect(subject).to be_bound}

    it "should have one variable" do
      expect(subject.variables?).to be_truthy
      expect(subject.variable_count).to eq 1
      expect(subject.variables.keys).to eq [:s]
      expect(subject.variables).to eq({:s => s})
    end

    it "should have no unbound variables" do
      expect(subject.unbound_variables.size).to eq 0
    end

    it "should have one bound variable" do
      expect(subject.bound_variables.size).to eq 1
      expect(subject.bound_variables).to eq({:s => s})
    end

    it "should be fully bound" do
      expect(subject.unbound?).to be_falsey
      expect(subject.bound?).to be_truthy
    end

    it "should have one binding" do
      expect(subject.bindings?).to be_truthy
      expect(subject.binding_count).to eq 1
      expect(subject.bindings).to eq({:s => true})
    end
  end

  context "with three bound variables" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    let(:p) {RDF::Query::Variable.new(:p, true)}
    let(:o) {RDF::Query::Variable.new(:o, true)}
    subject {RDF::Query::Pattern.new(s, p, o)}

    specify {expect(subject).not_to be_constant}
    specify {expect(subject).to be_variable}
    specify {expect(subject).to be_bound}

    it "should have three variables" do
      expect(subject.variables?).to be_truthy
      expect(subject.variable_count).to eq 3
      expect(subject.variables.keys.map { |key| key.to_s }.sort).to eq [:s, :p, :o].map { |key| key.to_s }.sort
      expect(subject.variables).to eq({:s => s, :p => p, :o => o})
    end

    it "should have no unbound variables" do
      expect(subject.unbound_variables.size).to eq 0
    end

    it "should have three bound variables" do
      expect(subject.bound_variables.size).to eq 3
      expect(subject.bound_variables).to eq({:s => s, :p => p, :o => o})
    end

    it "should be fully bound" do
      expect(subject.unbound?).to be_falsey
      expect(subject.bound?).to be_truthy
    end

    it "should have three bindings" do
      expect(subject.bindings?).to be_truthy
      expect(subject.binding_count).to eq 3
      expect(subject.bindings).to eq({:s => true, :p => true, :o => true})
    end
  end

  context "with a context" do
    let(:s) {RDF::Query::Variable.new(:s, true)}
    let(:p) {RDF::Query::Variable.new(:p, true)}
    let(:o) {RDF::Query::Variable.new(:o, true)}
    it "uses a variable for a symbol" do
      pattern = RDF::Query::Pattern.new(s, p, o, :context => :c)
      expect(pattern.context).to eq RDF::Query::Variable.new(:c)
    end
    
    it "uses a constant for :default" do
      pattern = RDF::Query::Pattern.new(s, p, o, :context => false)
      expect(pattern.context).to eq false
    end
  end
  
  context "with unbound variables" do
    let(:s) {RDF::Query::Variable.new(:s)}
    let(:p) {RDF::Query::Variable.new(:p)}
    let(:o) {RDF::Query::Variable.new(:o)}
    subject {RDF::Query::Pattern.new(s, p, o)}

    specify {expect(subject).not_to be_constant}
    specify {expect(subject).to be_variable}
    specify {expect(subject).not_to be_bound}

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

  context "with one bound and one unbound variable" do
    it "needs a spec" # TODO
  end

  context "Examples" do
    let!(:repo) {RDF::Repository.new {|r| r.insert(*RDF::Spec.triples)}}
    let!(:statement) {repo.detect {|s| s.to_a.none?(&:node?)}}
    let(:pattern) {RDF::Query::Pattern.new(:s, :p, :o)}
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
        expect(RDF::Query::Pattern.new(RDF::Node.new, :p, 123).variable_terms).to eq([:predicate])
      end
    end

    describe "#optional" do
      specify {
        expect(RDF::Query::Pattern.new(:s, :p, :o)).to_not be_optional
        expect(RDF::Query::Pattern.new(:s, :p, :o, :optional => true)).to be_optional
      }
    end
  end
end
