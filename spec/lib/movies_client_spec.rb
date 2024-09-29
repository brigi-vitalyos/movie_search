require 'webmock/rspec'
require 'dotenv'

require_relative '../../lib/movies_client.rb'
Dotenv.load '.env.test'

RSpec.describe MoviesClient do
  subject(:client) { described_class.new }

  let(:query_string) { 'movie' }
  let(:page_number) { 1 }
  let(:url) { "#{ENV['MOVIE_API_URL']}?query=#{query_string}&page=#{page_number}" }

  let(:response_body) do
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
     'total_results'=>44}.to_json
  end

  describe '#search' do
    it 'returns the response body when response is successful' do
      stub_request(:get, url).with(headers: {'Authorization' => %r{Bearer \w+}})
                             .to_return(status: 200, body: response_body)
      expect(client.search(query_string)).to eq response_body
    end

    it 'throws an exception when response is failed' do
      stub_request(:get, url).with(headers: {'Authorization' => %r{Bearer \w+}})
                             .to_return(status: 500, body: 'Server Unavailable')
      expect{client.search(query_string)}.to raise_error 'Movie Database Server Unavailable'
    end

    context 'when the query string contains specific characters' do
      let(:query_string) { 'öüóőúéáí' }

      it 'returns the response body when response is successful' do
        stub_request(:get, url).with(headers: {'Authorization' => %r{Bearer \w+}})
                               .to_return(status: 200, body: response_body)
        expect(client.search(query_string)).to eq response_body
      end
    end

    context 'when pagination is used' do
      let(:page_number) { 10 }

      it 'returns the requested page' do
        stub_request(:get, url).with(headers: {'Authorization' => %r{Bearer \w+}})
                               .to_return(status: 200, body: response_body)
        expect(client.search(query_string, page: page_number)).to eq response_body
      end
    end
  end
end

