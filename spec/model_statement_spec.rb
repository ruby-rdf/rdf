require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Statement do
  before :each do
    @n3   = "<http://rubygems.org/gems/rdf> <http://purl.org/dc/elements/1.1/creator> <http://ar.to/#self> ."
    @s    = RDF::URI("http://rubygems.org/gems/rdf")
    @p    = RDF::URI("http://purl.org/dc/elements/1.1/creator")
    @o    = RDF::URI("http://ar.to/#self")
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

    it "should be statement" do
      @stmt.statement?.should be_true
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
    before :each do
      @stmtc = RDF::Statement.new(@s, @p, @o, :context => @s)
    end

    it "should have a context" do
      @stmtc.has_context?.should be_true
      @stmtc.context.should_not be_nil
    end
    
    it "== statement without a context" do
      @stmtc.should == @stmt
    end
    
    it "eql? statement without a context" do
      @stmtc.should == @stmt
    end
  end

  context "when created with a default context" do
    before :each do
      @stmtdc = RDF::Statement.new(@s, @p, @o, :context => false)
      @stmtc = RDF::Statement.new(@s, @p, @o, :context => @s)
    end

    it "should not have a context" do
      @stmtdc.has_context?.should be_false
      @stmtdc.context.should == false
    end
    
    it "== statement without a context" do
      @stmtdc.should == @stmt
    end
    
    it "== statement with a context" do
      @stmtdc.should == @stmtc
    end
    
    it "!eql? statement with a context" do
      @stmtdc.should_not be_eql @stmtc
    end
    
    it "eql? statement without a context" do
      @stmtdc.should == @stmt
    end
  end

  context "when used like an Array" do
    it "should respond to #to_a" do
      @stmt.should respond_to(:to_a)
    end

    it "should respond to #[]" do
      @stmt.should respond_to(:[])
    end

    it "should respond to #[]=" do
      @stmt.should respond_to(:[]=)
    end

    it "should support #to_a" do
      @stmt.to_a.should eql([@stmt.subject, @stmt.predicate, @stmt.object])
    end

    it "should support #[] for the subject" do
      @stmt[0].should equal(@stmt.subject)
    end

    it "should support #[] for the predicate" do
      @stmt[1].should equal(@stmt.predicate)
    end

    it "should support #[] for the object" do
      @stmt[2].should equal(@stmt.object)
    end

    it "should support #[] for the context" do
      @stmt[3].should equal(@stmt.context)
    end

    it "should support #[]= for the subject" do
      stmt = @stmt.dup
      stmt[0] = s = RDF::URI("http://example.org/subject")
      stmt.subject.should == s
    end

    it "should support #[]= for the predicate" do
      stmt = @stmt.dup
      stmt[1] = p = RDF::URI("http://example.org/predicate")
      stmt.predicate.should == p
    end

    it "should support #[]= for the object" do
      stmt = @stmt.dup
      stmt[2] = o = RDF::URI("http://example.org/object")
      stmt.object.should == o
    end

    it "should support #[]= for the context" do
      stmt = @stmt.dup
      stmt[3] = c = RDF::URI("http://example.org/context")
      stmt.context.should == c
    end
  end

  context "when used like a Hash" do
    it "should support #to_hash" do
      @stmt.should respond_to(:to_hash)
      @stmt.to_hash.should eql({
        :subject   => @stmt.subject,
        :predicate => @stmt.predicate,
        :object    => @stmt.object,
        :context   => @stmt.context,
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
      @stmt.should_not be_eql(@other_stmt)
    end

    it "should match (===) a statement with a missing component to one with that component" do
      @stmt.should === @other_stmt
    end

    it "should not match (===) a statement with a component to one which is missing that component" do
      @other_stmt.should_not === @stmt
    end

    it "should only equals? with object equality" do
      @same_stmt = RDF::Statement.new @s, @p, @o
      @stmt.should_not equal(@same_stmt)
      @stmt.should equal(@stmt)
    end
  end
end
