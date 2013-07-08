require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Node do
  before :each do
    @new = Proc.new { |*args| RDF::Node.new(*args) }
  end

  it "should be instantiable" do
    expect { @new.call }.not_to raise_error
  end
  
  it "== a node with the same identifier" do
    @new.call("a").should == @new.call("a")
  end

  it "is unlabled given an empty ID" do
    @new.call("").to_s.should_not == "_:"
  end
  it "not eql? a node with the same identifier" do
    @new.call("a").should_not be_eql(@new.call("a"))
  end
end
