require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a subclass of Ruby Array implementing
    # `query_pattern` should do as well
    # FIXME
    @queryable = RDF::Repository.new
  end

  # @see lib/rdf/spec/queryable.rb in rdf-spec
  include RDF_Queryable
end
