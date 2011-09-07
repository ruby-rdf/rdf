require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Resource do
  before :each do
    @resource = Proc.new { |*args| RDF::Resource.new(*args) }
  end

  it "should instantiate blank nodes" do
    resource = @resource.call('_:foobar')
    resource.class.should == RDF::Node
    resource.id.should == 'foobar'
  end

  it "should instantiate URIs" do
    resource = @resource.call('http://rdf.rubyforge.org/')
    resource.class.should == RDF::URI
    resource.to_s.should == 'http://rdf.rubyforge.org/'
  end
end
