require_relative 'spec_helper'
require 'rdf/spec/transaction'

describe RDF::Transaction do
  let(:repository) { RDF::Repository.new }

  # @see lib/rdf/spec/transaction.rb in rdf-spec
  it_behaves_like "an RDF::Transaction", RDF::Transaction

  describe 'base implementation' do
    subject { described_class.new(repository, mutable: true) }

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

    describe 'mutated?' do
      it 'raises an error for subclasses' do
        class MyTx < described_class; end

        tx = MyTx.new(repository)

        expect { tx.mutated? }.to raise_error NotImplementedError
      end
    end

    describe '#execute' do
      it 'calls `changes#apply` with repository' do
        expect(subject.changes).to receive(:apply).with(subject.repository)
        subject.execute
      end
    end
  end
end
