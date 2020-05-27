require_relative 'spec_helper'
require 'rdf/spec/writable'

describe RDF::Writable do
  subject {RDF::Repository.new}

  # @see lib/rdf/spec/writable.rb in rdf-spec
  it_behaves_like 'an RDF::Writable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    let(:writable) { RDF::Repository.new }
  end

  describe "#freeze" do
    it "should make the object no longer writable" do
      subject.freeze

      expect(subject).not_to be_writable
    end
  end
end
