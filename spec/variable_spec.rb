require 'rdf'

describe RDF::Variable do
  context "when created" do
    it "should require a name" do
      lambda { var = RDF::Variable.new }.should raise_error(ArgumentError)
    end

    it "should have a name" do
      var = RDF::Variable.new(:x)
      var.name.should == :x
    end

    it "should be unbound" do
      var = RDF::Variable.new(:x)
      var.value.should be_nil
      var.unbound?.should be_true
      var.bound?.should be_false
      var.variables.should == { :x => var }
      var.bindings.should == {}
    end
  end
end
