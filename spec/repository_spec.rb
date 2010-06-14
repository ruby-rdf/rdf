require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do
  before :each do
    @repository = RDF::Repository.new
  end

  # @see lib/rdf/spec/repository.rb in rdf-spec
  it_should_behave_like RDF_Repository

  it "should maintain arbitrary options" do
    @repository = RDF::Repository.new(:foo => :bar)
    @repository.options.should have_key(:foo)
    @repository.options[:foo].should == :bar
  end
end
