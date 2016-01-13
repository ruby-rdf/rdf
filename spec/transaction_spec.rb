require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/transaction'

describe RDF::Transaction do
  let(:repository) { RDF::Repository.new }

  # @see lib/rdf/spec/transaction.rb in rdf-spec
  it_behaves_like "an RDF::Transaction", RDF::Transaction

  describe 'default implementation' do
    subject { described_class.new(repository, mutable: true) }

    describe '#buffered' do
      it 'is true if changeset has changes' do
        subject.insert([:s, :p, :o])
        expect(subject).to(be_buffered)
      end
    end

    describe "#insert" do
      let(:st) { RDF::Statement(:s, RDF::URI('p'), 'o') }
      
      it 'adds to inserts' do
        expect { subject.insert(st) }
          .to change { subject.changes.inserts }.to contain_exactly(st)
      end

      it 'adds multiple to inserts' do
        sts = [st] << RDF::Statement(:x, RDF::URI('y'), 'z')
        
        expect { subject.insert(*sts) }
          .to change { subject.changes.inserts }.to contain_exactly(*sts)
      end

      it 'adds enumerable to inserts' do
        sts = [st] << RDF::Statement(:x, RDF::URI('y'), 'z')
        sts.extend(RDF::Enumerable)

        expect { subject.insert(sts) }
          .to change { subject.changes.inserts }.to contain_exactly(*sts)
      end
    end
    
    describe '#delete' do
      let(:st) { RDF::Statement(:s, RDF::URI('p'), 'o') }

      it 'adds to deletes' do
        expect { subject.delete(st) }
          .to change { subject.changes.deletes }.to contain_exactly(st)
      end

      it 'adds multiple to deletes' do
        sts = [st] << RDF::Statement(:x, RDF::URI('y'), 'z')

        expect { subject.delete(*sts) }
          .to change { subject.changes.deletes }.to contain_exactly(*sts)
      end

      it 'adds enumerable to deletes' do
        sts = [st] << RDF::Statement(:x, RDF::URI('y'), 'z')
        sts.extend(RDF::Enumerable)

        expect { subject.delete(sts) }
          .to change { subject.changes.deletes }.to contain_exactly(*sts)
      end
    end
  end
end
