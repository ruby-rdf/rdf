require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/writable'

describe RDF::Writable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    #@writable = [].extend(RDF::Writable) # FIXME
    @writable = RDF::Repository.new
  end

  # @see lib/rdf/spec/writable.rb in rdf-spec
  include RDF_Writable

  describe "#freeze" do
    it "should make the object no longer writable" do
      @writable.freeze

      expect(@writable).not_to be_writable
    end
  end
end
