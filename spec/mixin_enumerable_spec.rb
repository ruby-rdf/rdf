require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Enumerable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    @statements = RDF::NTriples::Reader.new(File.open('etc/doap.nt')).to_a
    @enumerable = @statements.dup.extend(RDF::Enumerable)
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  include RDF_Enumerable
end
