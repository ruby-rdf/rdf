require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Value do
  before :each do
    @value    = Proc.new { |*args| RDF::Value.new(*args) }
  end

  it "should not be instantiable" do
    lambda { @value.call }.should raise_error(NoMethodError)
  end

  context "Examples" do
    it "needs specs for documentation examples"
  end
end
