require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Repository do
  it "should be instantiable" do
    lambda { RDF::Repository.new }.should_not raise_error
  end
end
