require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #search' do
    subject(:do_request) { post :search, params: params }
    let(:params) { {query_string: query_string, page_number: page_number} }
    let(:query_string) { 'movie_title' }
    let(:page_number) { 1 }

    let(:api_response) do
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

    let(:redis) { Redis.new url: ENV['MOVIES_REDIS_URL'] }

    before do
      redis.flushdb
      allow_any_instance_of(MoviesClient).to receive(:search).and_return api_response
    end

    it 'renders the index template' do
      do_request
      expect(response).to render_template :index
    end

    it 'calls the Movie API with the right parameters' do
      expect_any_instance_of(MoviesClient).to receive(:search).with(query_string, page: page_number)
      do_request
    end

    it 'stores the result form the API to the chache' do
      do_request

      cache_result = MoviesRepository.new.fetch(query_string, page_number)
      expect(cache_result).to eq api_response
    end

    it 'creates a new a cache hit count for statistics with the right parameters' do
      expect{ do_request }.to change{ CacheHit.count }.by(1)
      expect(CacheHit.last.attributes).to include({'query_string' => query_string,
                                                   'page_number' => page_number,
                                                   'count' => 0})
    end

    context 'when the result is already stores in cache' do
      before do
        MoviesRepository.new.store(query_string, page_number, api_response)
        CacheHit.create!(query_string: query_string, page_number: page_number, count: 2)
      end

      it 'does not calls the Movie API' do
        expect_any_instance_of(MoviesClient).not_to receive(:search).with(query_string, page: page_number)
        do_request
      end

      it 'gets the result form the cache' do
        expect_any_instance_of(MoviesRepository).to receive(:fetch).with(query_string, page_number)
        do_request
      end

      it 'does not create a new cache hit' do
        expect{ do_request }.not_to change{ CacheHit.count }
      end

      it 'updates the cache hit count' do
        cahce_hit = CacheHit.where(query_string: query_string, page_number: page_number).last

        expect{ do_request }.to change{ cahce_hit.reload.count }.by 1
      end
    end

    context 'when the Movies API responds with error' do
      before { allow_any_instance_of(MoviesClient).to receive(:search).and_raise error }
      let(:error) { StandardError.new('Movie Database Server Unavailable') }

      it 'renders error page' do
        do_request
        expect(response).to render_template 'errors/server_error'
      end

      it 'logs the error message' do
        expect(Rails.logger).to receive(:warn).with error
        do_request
      end
    end
  end

  describe 'POST #show' do
    subject(:do_request) { post :show, params: params }
    let(:params) do
      {
        'movie'=> {
          'adult'=>false,
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
          'vote_count'=>25
        }.to_json
      }
    end

    it 'renders the show template' do
      do_request
      expect(response).to render_template :show
    end

    context 'when parameter is missing' do
      let(:params) { nil }

      it 'renders error page' do
        do_request
        expect(response).to render_template 'errors/server_error'
      end

      it 'logs the error message' do
        expect(Rails.logger).to receive(:warn)
        do_request
      end
    end
  end
end
