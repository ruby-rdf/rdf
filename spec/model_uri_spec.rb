require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::URI do
  it "should be instantiable" do
    lambda { RDF::URI.new("http://rdf.rubyforge.org/") }.should_not raise_error
  end

  it "should return the root URI" do
    uri = RDF::URI.new("http://rdf.rubyforge.org/RDF/URI.html")
    uri.should respond_to(:root)
    uri.root.should be_a_uri
    uri.root.should == RDF::URI.new("http://rdf.rubyforge.org/")
  end

  it "should find the parent URI" do
    uri = RDF::URI.new("http://rdf.rubyforge.org/RDF/URI.html")
    uri.should respond_to(:parent)
    uri.parent.should be_a_uri
    uri.parent.should == RDF::URI.new("http://rdf.rubyforge.org/RDF/")
    uri.parent.parent.should == RDF::URI.new("http://rdf.rubyforge.org/")
    uri.parent.parent.parent.should be_nil
  end

  it "should return a consistent hash code" do
    hash1 = RDF::URI.new("http://rdf.rubyforge.org/").hash
    hash2 = RDF::URI.new("http://rdf.rubyforge.org/").hash
    hash1.should == hash2
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
