require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do
  let(:repository) { RDF::Repository.new }

  # @see lib/rdf/spec/repository.rb in rdf-spec
  it_behaves_like 'an RDF::Repository'

  it "should maintain arbitrary options" do
    repository = RDF::Repository.new(:foo => :bar)
    expect(repository.options).to have_key(:foo)
    expect(repository.options[:foo]).to eq :bar
  end

  context "A non-validatable repository" do
    let(:repository) { RDF::Repository.new(:with_validity => false) }

    # @see lib/rdf/spec/repository.rb in rdf-spec
    it_behaves_like 'an RDF::Repository'
  end
end
