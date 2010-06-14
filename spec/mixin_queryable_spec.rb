require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    #@queryable = [].extend(RDF::Queryable) # FIXME
    @queryable = RDF::Repository.new
  end

  # @see lib/rdf/spec/queryable.rb in rdf-spec
  it_should_behave_like RDF_Queryable
end
