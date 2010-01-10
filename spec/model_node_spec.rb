require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Node do
  it "should be instantiable" do
    lambda { RDF::Node.new }.should_not raise_error
  end
end
