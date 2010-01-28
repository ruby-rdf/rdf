require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::URI do
  it "should be instantiable" do
    lambda { RDF::URI.new("http://rdf.rubyforge.org/") }.should_not raise_error
  end

  it "should be duplicable" do
    url  = Addressable::URI.parse("http://rdf.rubyforge.org/")
    uri2 = (uri1 = RDF::URI.new(url)).dup

    uri1.should_not be_equal(uri2)
    uri1.should be_eql(uri2)
    uri1.should == uri2

    url.path = '/rdf/'
    uri1.should_not be_equal(uri2)
    uri1.should_not be_eql(uri2)
    uri1.should_not == uri2
  end
end
