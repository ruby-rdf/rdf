require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/queryable'

describe RDF::Queryable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a subclass of Ruby Array implementing
    # `query_pattern` should do as well
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
      end
      it "with hash" do
        subject.query(:predicate => RDF::DOAP.developer).to_a.should_not be_empty
      end
    end
  end
end
