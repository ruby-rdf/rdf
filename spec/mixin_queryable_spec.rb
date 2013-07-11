require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a subclass of Ruby Array implementing
    # `query_pattern` and `query_execute` should do as well
    # FIXME
    @queryable = RDF::Repository.new
  end

  # @see lib/rdf/spec/queryable.rb in rdf-spec
  include RDF_Queryable

  context "Examples" do
    before(:each) {@queryable.insert(*RDF::Spec.quads); $stdout = StringIO.new}
    after(:each) {$stdout = STDOUT}
    subject {@queryable}

    context "Querying for statements having a given predicate" do
      it "with array" do
        subject.query([nil, RDF::DOAP.developer, nil]).to_a.should_not be_empty
        subject.query([nil, RDF::DOAP.developer, nil]) {|s| s.should be_a_statement}
      end
      it "with hash" do
        subject.query(:predicate => RDF::DOAP.developer).to_a.should_not be_empty
        subject.query(:predicate => RDF::DOAP.developer) {|s| s.should be_a_statement}
      end
    end

    context "Querying for solutions from a BGP" do
      it "returns solutions" do
        query = RDF::Query.new {pattern [:s, :p, :o]}
        subject.query(query).to_a.should_not be_empty
        subject.query(query) {|s| s.should be_a RDF::Query::Solution}
      end
    end
  end
end
