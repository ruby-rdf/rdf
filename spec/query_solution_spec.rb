require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Solution do
  describe "new" do
    it "is instantiable" do
      lambda { RDF::Query::Solution.new }.should_not raise_error
    end
  end
  
  describe "#compatible?" do
    it "returns true if two solutions have equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1"})
      s2 = RDF::Query::Solution.new({:a => "1"})
      s1.compatible?(s2).should be_true
    end

    it "returns true if two solutions have overlapping equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "1", :b => "2"})
      s1.compatible?(s2).should be_true
    end
    
    it "returns false if two solutions any mappings which are different" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "3", :c => "3"})
      s1.compatible?(s2).should be_false
    end
  end
  
  describe "#eql?" do
    it "returns true if two solutions have equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1"})
      s2 = RDF::Query::Solution.new({:a => "1"})
      s1.eql?(s2).should be_true
    end

    it "returns false if two solutions have overlapping equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "1", :b => "2"})
      s1.eql?(s2).should be_false
    end
    
    it "returns false if two solutions any mappings which are different" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "3", :c => "3"})
      s1.eql?(s2).should be_false
    end
  end

  context "Examples" do
    let(:foo) {RDF::Query::Variable.new(:title, "foo")}
    let(:bar) {RDF::Query::Variable.new(:mbox, "jrhacker@example.org")}
    let!(:solution) {RDF::Query::Solution.new(:title => "foo", :mbox => "jrhacker@example.org")}

    it "Iterating over every binding in the solution" do
      expect {|b| solution.each_binding(&b)}.to yield_successive_args([:title, "foo"], [:mbox, "jrhacker@example.org"])
      expect {|b| solution.each_variable(&b)}.to yield_successive_args(foo, bar)
    end

    it "Iterating over every value in the solution" do
      expect {|b| solution.each_value(&b)}.to yield_successive_args("foo", "jrhacker@example.org")
    end

    it "Checking whether a variable is bound or unbound" do
      solution.should be_bound(:title)
      solution.should_not be_unbound(:mbox)
    end

    it "Retrieving the value of a bound variable" do
      solution[:mbox].should == "jrhacker@example.org"
      solution.mbox.should == "jrhacker@example.org"
    end

    it "Retrieving all bindings in the solution as a Hash" do
      solution.to_hash.should == {:title => "foo", :mbox => "jrhacker@example.org"}
    end
  end
end
