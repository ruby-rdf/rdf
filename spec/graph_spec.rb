require 'rdf'

describe RDF::Graph do
  context "unnamed graphs" do
    it "should be instantiable" do
      lambda { RDF::Graph.new }.should_not raise_error
    end

    it "should be unnamed" do
      graph = RDF::Graph.new
      graph.unnamed?.should be_true
      graph.named?.should be_false
    end

    it "should not have a context" do
      graph = RDF::Graph.new
      graph.context.should be_nil
      graph.contexts.size.should == 0
    end
  end

  context "named graphs" do
    it "should be instantiable" do
      lambda { RDF::Graph.new }.should_not raise_error
    end

    it "should be named" do
      graph = RDF::Graph.new("http://rdf.rubyforge.org/")
      graph.unnamed?.should be_false
      graph.named?.should be_true
    end

    it "should have a context" do
      graph = RDF::Graph.new("http://rdf.rubyforge.org/")
      graph.context.should_not be_nil
      graph.contexts.size.should == 1
    end
  end

  context "all graphs" do
    it "should have as many subjects as statements" do
      # TODO
    end

    it "should have as many predicates as statements" do
      # TODO
    end

    it "should have as many objects as statements" do
      # TODO
    end
  end
end
