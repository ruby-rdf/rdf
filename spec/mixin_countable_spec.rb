require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/countable'

describe RDF::Countable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    @statements = RDF::NTriples::Reader.new(File.open('etc/doap.nt')).to_a
    @countable  = @statements.dup.extend(RDF::Countable)
  end

  # @see lib/rdf/spec/countable.rb in rdf-spec
  it_should_behave_like RDF_Countable
end
