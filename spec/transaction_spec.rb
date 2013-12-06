require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/transaction'

describe RDF::Transaction do
  # @see lib/rdf/spec/transaction.rb in rdf-spec
  it_behaves_like "RDF_Transaction", RDF::Transaction
end
