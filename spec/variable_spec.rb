require 'rdf'

describe RDF::Variable do
  context "when created" do
    before :each do
      @var = RDF::Variable.new(:x)
    end

    it "should require a name" do
      lambda { var = RDF::Variable.new }.should raise_error(ArgumentError)
    end

    it "should have a name" do
      @var.named?.should be_true
      @var.name.should == :x
    end

    it "should not have a value" do
      @var.value.should be_nil
    end

    it "should be convertible to a symbol" do
      @var.to_sym.should == :x
    end

    it "should have a string representation" do
      @var.to_s.should == "?x"
    end
  end

  context "when not bound" do
    before :each do
      @var = RDF::Variable.new(:x)
    end

    it "should not have a value" do
      @var.value.should be_nil
    end

    it "should be unbound" do
      @var.unbound?.should be_true
      @var.bound?.should be_false
      @var.variables.should == {:x => @var}
      @var.bindings.should == {}
    end

    it "should match any value" do
      [nil, true, false, 123].each do |value|
        (@var === value).should be_true
      end
    end

    it "should have a string representation" do
      @var.to_s.should == "?x"
    end
  end

  context "when bound" do
    before :each do
      @var = RDF::Variable.new(:x, 123)
    end

    it "should have a value" do
      @var.value.should == 123
    end

    it "should be bound" do
      @var.unbound?.should be_false
      @var.bound?.should be_true
      @var.variables.should == {:x => @var}
      @var.bindings.should == {:x => 123}
    end

    it "should match only its value" do
      [nil, true, false, 456].each do |value|
        (@var === value).should be_false
      end
      (@var === 123).should be_true
    end

    it "should have a string representation" do
      @var.to_s.should == "?x=123"
    end
  end

  context "when rebound" do
    before :each do
      @var = RDF::Variable.new(:x, 123)
    end

    it "should return the previous value" do
      @var.bind(456).should == 123
      @var.bind(789).should == 456
    end

    it "should still be bound" do
      @var.bind!(456)
      @var.unbound?.should be_false
      @var.bound?.should be_true
    end
  end

  context "when unbound" do
    before :each do
      @var = RDF::Variable.new(:x, 123)
    end

    it "should return the previous value" do
      @var.unbind.should == 123
      @var.unbind.should == nil
    end

    it "should now be unbound" do
      @var.unbind!
      @var.unbound?.should be_true
      @var.bound?.should be_false
    end
  end
end
