require 'rdf'

describe RDF::URI do
  it "should be instantiable" do
    lambda { RDF::URI.new("http://rdf.rubyforge.org/") }.should_not raise_error
  end
end
