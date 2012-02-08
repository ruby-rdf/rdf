require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/durable'

describe RDF::Durable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well
    # FIXME
    @load_durable = lambda {RDF::Repository.new}
  end

  # @see lib/rdf/spec/countable.rb in rdf-spec
  it_should_behave_like RDF_Durable
end
