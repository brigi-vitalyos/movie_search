require_relative '../../lib/movies_repository.rb'

RSpec.describe MoviesRepository do
  subject(:repo) { described_class.new }
  let(:redis) { Redis.new url: ENV['MOVIES_REDIS_URL'] }
  let(:query_string) { 'movie' }
  let(:page_number) { 1 }
  let(:results) do
    {'page'=>page_number,
     'results'=>
       [{'adult'=>false,
         'backdrop_path'=>'/xyz.jpg',
         'genre_ids'=>[18, 35],
         'id'=>293456,
         'original_language'=>'hu',
         'original_title'=>'Something original',
         'overview'=> 'Some description.',
         'popularity'=>1.521,
         'poster_path'=>'/xzy.jpg',
         'release_date'=>'2014-07-10',
         'title'=>'Something',
         'video'=>false,
         'vote_average'=>7.1,
         'vote_count'=>25}],
     'total_pages'=>3,
     'total_results'=>44}
  end

  before { redis.flushdb }

  describe '#store' do
    it 'stores the results in Redis' do
      repo.store query_string, page_number, results
      expect(redis.keys.count).to eq 1
      expect(redis.get(redis.keys.first)).to eq results.to_json
    end

    it 'sets a TTL for the metric' do
      repo.store query_string, page_number, results
      expect(redis.ttl(redis.keys.first)).to eq 2 * 60
    end
  end

  describe '#fetch' do
    it 'returns nil for query that have no stored result' do
      expect(repo.fetch(query_string, page_number)).to be_nil
    end

    it 'returns the results if it was already stored' do
      repo.store query_string, page_number, results
      expect(repo.fetch(query_string, page_number)).to eq results
    end
  end
end
