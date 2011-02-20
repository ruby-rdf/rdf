require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Solution do
  context "new" do
    it "is instantiable" do
      lambda { RDF::Query::Solution.new }.should_not raise_error
    end
  end
  
  context "#compatible?" do
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
end
