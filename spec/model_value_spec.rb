require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Value do
  it "should not be instantiable" do
    lambda { RDF::Value.new }.should raise_error(NoMethodError)
  end
end

describe RDF::Resource do
  it "should instantiate blank nodes" do
    resource = RDF::Resource.new('_:foobar')
    resource.class.should == RDF::Node
    resource.id.should == 'foobar'
  end

  it "should instantiate URIs" do
    resource = RDF::Resource.new('http://rdf.rubyforge.org/')
    resource.class.should == RDF::URI
    resource.to_s.should == 'http://rdf.rubyforge.org/'
  end
end
