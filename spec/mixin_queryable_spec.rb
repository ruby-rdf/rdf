require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  # @see lib/rdf/spec/queryable.rb in rdf-spec
  it_behaves_like 'an RDF::Queryable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a subclass of Ruby Array implementing
    # `query_pattern` and `query_execute` should do as well
    # FIXME
    let(:queryable) { RDF::Repository.new }
  end

  context "Examples" do
    subject { RDF::Repository.new.insert(*RDF::Spec.quads) }

    context "Querying for statements having a given predicate" do
      it "with array" do
        expect(subject.query([nil, RDF::Vocab::DOAP.developer, nil]).to_a).not_to be_empty
        subject.query([nil, RDF::Vocab::DOAP.developer, nil]) {|s| expect(s).to be_a_statement}
        expect{|b| subject.query([nil, RDF::Vocab::DOAP.developer, nil], &b)}.to yield_control.at_least(1).times
      end
      it "with hash" do
        expect(subject.query(:predicate => RDF::Vocab::DOAP.developer).to_a).not_to be_empty
        subject.query(:predicate => RDF::Vocab::DOAP.developer) {|s| expect(s).to be_a_statement}
        expect{|b| subject.query(:predicate => RDF::Vocab::DOAP.developer, &b)}.to yield_control.at_least(1).times
      end
    end

    context "Querying for solutions from a BGP" do
      it "returns solutions" do
        query = RDF::Query.new {pattern [:s, :p, :o]}
        expect(subject.query(query).to_a).not_to be_empty
        subject.query(query) {|s| expect(s).to be_a RDF::Query::Solution}
        expect{|b| subject.query(query, &b)}.to yield_control.exactly(subject.count).times
      end
    end
  end
end
