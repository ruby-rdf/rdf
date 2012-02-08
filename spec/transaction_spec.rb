require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/transaction'

describe RDF::Transaction do
  before(:each) { @transaction = RDF::Transaction.new }
  
  # @see lib/rdf/spec/transaction.rb in rdf-spec
  it_should_behave_like RDF_Transaction
end
