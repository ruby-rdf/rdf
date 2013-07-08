require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/indexable'

describe RDF::Indexable do
  before :each do
    @indexable = double("Indexable")
    @indexable.extend(RDF::Indexable)
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  include RDF_Indexable
end
