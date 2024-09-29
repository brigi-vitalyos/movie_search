require 'rails_helper'

RSpec.describe CacheHit, type: :model do
  describe '#increase_counter!' do
    subject(:cache_hit) { described_class.create count: 1  }

    it 'returns a cacheHit object' do
      expect(cache_hit.increase_counter!).to be_a CacheHit
    end

    it 'increases the count attribute by 1' do
      expect{ cache_hit.increase_counter! }.to change{ cache_hit.count }.by 1
    end
  end
end