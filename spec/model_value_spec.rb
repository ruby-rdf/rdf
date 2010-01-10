require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Value do
  it "should not be instantiable" do
    lambda { RDF::Value.new }.should raise_error(NoMethodError)
  end
end

describe RDF::Resource do
  it "should not be instantiable" do
    lambda { RDF::Resource.new }.should raise_error(NoMethodError)
  end
end
