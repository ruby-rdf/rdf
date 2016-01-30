require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/repository'

describe RDF::Repository do

  # @see lib/rdf/spec/repository.rb in rdf-spec
  it_behaves_like 'an RDF::Repository' do
    let(:repository) { RDF::Repository.new }
  end

  it "maintains arbitrary options" do
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

  describe '#apply_changeset' do
    let(:changeset) { double('changeset', deletes: dels, inserts: ins) }

    let(:dels) { [] }
    let(:ins)  { [] }
    
    it 'applies atomically' do
      subject << existing_statement = RDF::Statement(:s, RDF.type, :o)
      dels << existing_statement
      ins << RDF::Statement(nil, nil, nil)

      expect do
        begin; subject.apply_changeset(changeset) rescue ArgumentError; end;
      end.not_to change { subject.statements }
    end
  end
end
