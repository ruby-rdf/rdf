require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rdf/spec/value'

describe RDF::Resource do

  before :each do
    @value    = Proc.new { | *args | RDF::Value.new(*args) }
    @resource = Proc.new { | *args | RDF::Resource.new(*args) }
  end

  it_should_behave_like RDF_Value
end
