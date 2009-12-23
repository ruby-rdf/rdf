require 'rdf'

describe RDF::Literal do
  it "should be instantiable" do
    lambda { RDF::Graph.new }.should_not raise_error
  end
end
