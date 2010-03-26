require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Statement do
  before :each do
    @n3   = "<http://rubygems.org/gems/rdf> <http://purl.org/dc/elements/1.1/creator> <http://ar.to/#self> ."
    @s    = RDF::URI.parse("http://rubygems.org/gems/rdf")
    @p    = RDF::URI.parse("http://purl.org/dc/elements/1.1/creator")
    @o    = RDF::URI.parse("http://ar.to/#self")
    @stmt = RDF::Statement.new(@s, @p, @o)
  end

  context "when initializing" do
    it "should be instantiable with a hash argument" do
      lambda { RDF::Statement.new(:subject => @s,
                                  :predicate => @p,
                                  :object => @o) }.should_not raise_error(ArgumentError)

    end

    it "should not alter a hash argument" do
      hash = { :subject => @s, :predicate => @p, :object => @o }
      original_hash = hash.dup
      stmt = RDF::Statement.new(hash)
      original_hash.should == hash
    end

    it "should not alter its options argument" do
      options = { :context => RDF::DOAP.name }
      original_options = options.dup
      stmt = RDF::Statement.new(@s, @p, @o, options)
      options.should == original_options
    end
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

  context "when created with a blank node subject" do
    before :each do
      @stmt = RDF::Statement.new(RDF::Node.new, @p, @o)
    end

    it "should have a blank node" do
      @stmt.has_blank_nodes?.should be_true
    end
  end

  context "when created with a blank node object" do
    before :each do
      @stmt = RDF::Statement.new(@s, @p, RDF::Node.new)
    end

    it "should have a blank node" do
      @stmt.has_blank_nodes?.should be_true
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
      @stmt.to_hash.should eql({
        :subject   => @stmt.subject,
        :predicate => @stmt.predicate,
        :object    => @stmt.object,
      })
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

  context "when comparing equality" do
    before :each do
      @c = RDF::URI.parse("http://example.org/context")
      @other_stmt = RDF::Statement.new(@s, @p, @o, :context => @c)
    end

    it "should == regardless of context" do
      @stmt.should == @other_stmt
    end

    it "should not be eql? with differing contexts" do
      @stmt.should_not be_eql @other_stmt
    end

    it "should match (===) a statement with a missing component to one with that component" do
      @stmt.should === @other_stmt
    end

    it "should not match (===) a statement with a component to one which is missing that component" do
      @other_stmt.should_not === @stmt
    end

    it "should only equals? with object equality" do
      @same_stmt = RDF::Statement.new @s, @p, @o
      @stmt.should_not equal @same_stmt
      @stmt.should equal @stmt
    end

  end
end
