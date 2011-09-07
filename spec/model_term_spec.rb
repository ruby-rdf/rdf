require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Value do
  before :each do
    @term    = Proc.new { |*args| RDF::Term.new(*args) }
  end

  it "should not be instantiable" do
    lambda { @term.call }.should raise_error(NoMethodError)
  end
end
