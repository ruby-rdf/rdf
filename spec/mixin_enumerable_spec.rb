require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Enumerable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    #@enumerable = [].extend(RDF::Enumerable) # FIXME
    @enumerable = RDF::Repository.new
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  it_should_behave_like RDF_Enumerable
end
