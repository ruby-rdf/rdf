require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do
  before :each do
    @repository = RDF::Repository.new
  end

  # @see lib/rdf/spec/repository.rb in rdf-spec
  include RDF_Repository

  it "should maintain arbitrary options" do
    @repository = RDF::Repository.new(:foo => :bar)
    expect(@repository.options).to have_key(:foo)
    expect(@repository.options[:foo]).to eq :bar
  end

  context "A non-validatable repository" do
    before :each do
      @repository = RDF::Repository.new(:with_validity => false)
    end

    # @see lib/rdf/spec/repository.rb in rdf-spec
    include RDF_Repository
  end
end
