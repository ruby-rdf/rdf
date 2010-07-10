require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/list'

describe RDF::List do
  # @see lib/rdf/spec/list.rb in rdf-spec
  it_should_behave_like RDF_List
end

describe "RDF::List::NIL" do
  # @see lib/rdf/spec/list.rb in rdf-spec
  it_should_behave_like RDF_List_NIL
end
