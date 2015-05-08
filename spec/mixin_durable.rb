require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/durable'

describe RDF::Durable do
  # The available reference implementations are `RDF::Repository` and
  # `RDF::Graph`, but a plain Ruby array will do fine as well
  # FIXME
  before { @load_durable = lambda { RDF::Repository.new } }

  # @see lib/rdf/spec/countable.rb in rdf-spec
  it_behaves_like 'an RDF::Durable'
end
