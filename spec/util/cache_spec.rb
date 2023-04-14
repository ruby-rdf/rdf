require_relative '../spec_helper'

describe RDF::Util::Cache do
  subject(:cache) do
    described_class.new(10)
  end

  describe '#capacity' do
    it 'returns the cache size' do
      expect(cache.capacity).to eq 10
    end
  end

  describe '#size' do
    it 'returns the cache size' do
      cache[:key] = {}
      expect(cache.size).to eq 1
    end
  end

  describe '#[]' do
    it 'returns the value' do
      cache[:key] = {}
      expect(cache[:key]).to eq({})
    end
  end

  describe '#[]=' do
    context 'when the cache is not full' do
      it 'stores the value' do
        expect {
          cache[:key] = {}
        }.to change(cache, :size).by(1)
      end

      it 'returns the value' do
        expect(cache[:key] = {}).to eq({})
      end
    end

    context 'when the cache is full' do
      before do
        10.times { |i| cache[i] = {} }
      end

      it 'does not store the value' do
        expect {
          cache[:key] = {}
        }.not_to change(cache, :size)
      end

      it 'returns the value' do
        expect(cache[:key] = {}).to eq({})
      end
    end
  end

  context 'when the GC starts' do
    before do
      100.times { |i| cache[i] = {}; nil }
    end

    # Sometimes the last reference is not gc
    it 'cleans the unused references' do
      expect {
        GC.start
      }.to change(cache, :size).by_at_most(-9)
    end
  end

  describe '#delete' do
    before do
      cache[:key] = {}
    end

    it 'delete the value' do
      expect { cache.delete(:key) }.to change(cache, :size).to(0)
    end
  end
end