require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rdf/spec/literal'

describe RDF::Literal do

  before :each do 
    @new = Proc.new { | *args | RDF::Literal.new(*args) }
  end

  it_should_behave_like RDF_Literal

end
