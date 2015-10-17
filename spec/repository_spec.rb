require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do

  # @see lib/rdf/spec/repository.rb in rdf-spec
  it_behaves_like 'an RDF::Repository' do
    let(:repository) { RDF::Repository.new }
  end

  it "should maintain arbitrary options" do
    repository = RDF::Repository.new(foo: :bar)
    expect(repository.options).to have_key(:foo)
    expect(repository.options[:foo]).to eq :bar
  end

  context "A non-validatable repository" do
    # @see lib/rdf/spec/repository.rb in rdf-spec
    it_behaves_like 'an RDF::Repository' do
      let(:repository) { RDF::Repository.new(with_validity: false) }
    end
  end
end
