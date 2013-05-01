require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Pattern do
  context "without any variables" do
    before :each do
      @pattern = RDF::Query::Pattern.new
    end

    describe ".from" do
      it "creates using triple array" do
        RDF::Query::Pattern.from([:s, :p, :o]).should == RDF::Query::Pattern.new(:s, :p, :o)
      end

      it "creates using hash" do
        RDF::Query::Pattern.from(:subject => :s, :predicate => :p, :object => :o).should == RDF::Query::Pattern.new(:s, :p, :o)
      end

      it "creates using quad array" do
        RDF::Query::Pattern.from([:s, :p, :o, :c]).should == RDF::Query::Pattern.new(:s, :p, :o, :context => :c)
      end

      it "creates using hash" do
        RDF::Query::Pattern.from(:subject => :s, :predicate => :p, :object => :o, :context => :c).should == RDF::Query::Pattern.new(:s, :p, :o, :context => :c)
      end
    end
    
    it "should not have variables" do
      @pattern.variables?.should be_false
      @pattern.variable_count.should == 0
      @pattern.variables.should == {}
    end

    it "should have no unbound variables" do
      @pattern.unbound_variables.size.should == 0
    end

    it "should have no bound variables" do
      @pattern.bound_variables.size.should == 0
    end

    it "should not be bound or unbound" do
      @pattern.unbound?.should be_false
      @pattern.bound?.should be_false
    end

    it "should not have bindings" do
      @pattern.bindings?.should be_false
      @pattern.binding_count.should == 0
      @pattern.bindings.should == {}
    end
  end

  context "with one bound variable" do
    before :each do
      @s = RDF::Query::Variable.new(:s, true)
      @pattern = RDF::Query::Pattern.new(@s)
    end

    it "should have one variable" do
      @pattern.variables?.should be_true
      @pattern.variable_count.should == 1
      @pattern.variables.keys.should == [:s]
      @pattern.variables.should == {:s => @s}
    end

    it "should have no unbound variables" do
      @pattern.unbound_variables.size.should == 0
    end

    it "should have one bound variable" do
      @pattern.bound_variables.size.should == 1
      @pattern.bound_variables.should == {:s => @s}
    end

    it "should be fully bound" do
      @pattern.unbound?.should be_false
      @pattern.bound?.should be_true
    end

    it "should have one binding" do
      @pattern.bindings?.should be_true
      @pattern.binding_count.should == 1
      @pattern.bindings.should == {:s => true}
    end
  end

  context "with three bound variables" do
    before :each do
      @s = RDF::Query::Variable.new(:s, true)
      @p = RDF::Query::Variable.new(:p, true)
      @o = RDF::Query::Variable.new(:o, true)
      @pattern = RDF::Query::Pattern.new(@s, @p, @o)
    end

    it "should have three variables" do
      @pattern.variables?.should be_true
      @pattern.variable_count.should == 3
      @pattern.variables.keys.map { |key| key.to_s }.sort.should == [:s, :p, :o].map { |key| key.to_s }.sort
      @pattern.variables.should == {:s => @s, :p => @p, :o => @o}
    end

    it "should have no unbound variables" do
      @pattern.unbound_variables.size.should == 0
    end

    it "should have three bound variables" do
      @pattern.bound_variables.size.should == 3
      @pattern.bound_variables.should == {:s => @s, :p => @p, :o => @o}
    end

    it "should be fully bound" do
      @pattern.unbound?.should be_false
      @pattern.bound?.should be_true
    end

    it "should have three bindings" do
      @pattern.bindings?.should be_true
      @pattern.binding_count.should == 3
      @pattern.bindings.should == {:s => true, :p => true, :o => true}
    end
  end

  context "with a context" do
    it "uses a variable for a symbol" do
      p = RDF::Query::Pattern.new(@s, @p, @o, :context => :c)
      p.context.should == RDF::Query::Variable.new(:c)
    end
    
    it "uses a constant for :default" do
      p = RDF::Query::Pattern.new(@s, @p, @o, :context => false)
      p.context.should == false
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
        subject.execute(repo).to_a.should have(repo.count).items
      end
    end

    describe "#solution" do
      subject {pattern.solution(statement)}
      it("pattern[:s] #=> statement.subject") { subject[:s].should == statement.subject}
      it("pattern[:p] #=> statement.predicate") { subject[:p].should == statement.predicate}
      it("pattern[:o] #=> statement.object") { subject[:o].should == statement.object}
    end

    describe "#variable_terms" do
      it "has term" do
        RDF::Query::Pattern.new(RDF::Node.new, :p, 123).variable_terms.should ==[:predicate]
      end
    end

    describe "#optional" do
      specify {
        RDF::Query::Pattern.new(:s, :p, :o).should_not be_optional
        RDF::Query::Pattern.new(:s, :p, :o, :optional => true).should be_optional
      }
    end
  end
end
