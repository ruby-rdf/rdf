require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/node'

describe RDF::Node do
  before :each do
    @new = Proc.new { |*args| RDF::Node.new(*args) }
  end

  # @see lib/rdf/spec/node.rb in rdf-spec
  it_should_behave_like RDF_Node
end
