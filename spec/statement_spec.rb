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
    it "should not require arguments" do
      lambda { RDF::Statement.new }.should_not raise_error(ArgumentError)
    end

    it "should have a subject" do
      @stmt.has_subject?.should be_true
      @stmt.subject.should_not be_nil
    end

    it "should have a predicate" do
      @stmt.has_predicate?.should be_true
      @stmt.predicate.should_not be_nil
    end

    it "should have an object" do
      @stmt.has_object?.should be_true
      @stmt.object.should_not be_nil
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
      @stmt.has_context?.should be_false
    end
  end

  context "when created with a context" do
    it "should have a context" do
      @stmt = RDF::Statement.new(@s, @p, @o, :context => @s)
      @stmt.has_context?.should be_true
      @stmt.context.should_not be_nil
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
