require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Literal do
  before :each do
    @new = Proc.new { |*args| RDF::Literal.new(*args) }
  end

  # @see lib/rdf/spec/literal.rb in rdf-spec
  it_should_behave_like RDF_Literal
end
