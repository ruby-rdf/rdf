require 'rdf'

describe RDF::Statement do
  before :each do
    @n3   = "<http://gemcutter.org/gems/rdf> <http://purl.org/dc/elements/1.1/creator> <http://ar.to/#self> ."
    @s    = RDF::URI.parse("http://gemcutter.org/gems/rdf")
    @p    = RDF::URI.parse("http://purl.org/dc/elements/1.1/creator")
    @o    = RDF::URI.parse("http://ar.to/#self")
    @stmt = RDF::Statement.new(@s, @p, @o)
  end

  context "when created" do
    it "should require three arguments" do
      lambda { RDF::Statement.new }.should raise_error(ArgumentError)
      lambda { RDF::Statement.new(@s) }.should raise_error(ArgumentError)
      lambda { RDF::Statement.new(@s, @p) }.should raise_error(ArgumentError)
      lambda { RDF::Statement.new(@s, @p, @o) }.should_not raise_error
    end

    it "should have a subject" do
      @stmt.subject.should_not be_nil
      @stmt.subject?.should be_true
    end

    it "should have a predicate" do
      @stmt.predicate.should_not be_nil
      @stmt.predicate?.should be_true
    end

    it "should have an object" do
      @stmt.object.should_not be_nil
      @stmt.object?.should be_true
    end

    it "should be asserted" do
      @stmt.asserted?.should be_true
    end

    it "should not be quoted" do
      @stmt.quoted?.should be_false
    end
  end

  context "when created without a context" do
    it "should not have a context" do
      @stmt = RDF::Statement.new(@s, @p, @o, :context => nil)
      @stmt.context.should be_nil
      @stmt.context?.should be_false
    end
  end

  context "when created with a context" do
    it "should have a context" do
      @stmt = RDF::Statement.new(@s, @p, @o, :context => @s)
      @stmt.context.should_not be_nil
      @stmt.context?.should be_true
    end
  end

  context "when used like an Array" do
    it "should support #to_a" do
      @stmt.should respond_to(:to_a)
      @stmt.to_a.should eql([@stmt.subject, @stmt.predicate, @stmt.object])
    end

    it "should support #[]" do
      @stmt.should respond_to(:[])
      @stmt[0].should equal(@stmt.subject)
      @stmt[1].should equal(@stmt.predicate)
      @stmt[2].should equal(@stmt.object)
    end

    it "should support #[]=" do
      @stmt.should respond_to(:[]=)
      # TODO
    end
  end

  context "when used like a Hash" do
    it "should support #to_hash" do
      @stmt.should respond_to(:to_hash)
      @stmt.to_hash.should eql({@stmt.subject => {@stmt.predicate => @stmt.object}})
    end
  end

  context "when used like a String" do
    it "should support #to_s" do
      @stmt.should respond_to(:to_s)
    end

    it "should have an N-Triples representation" do
      @stmt.to_s.should eql(@n3)
    end
  end
end
