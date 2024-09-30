require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject(:movie) { described_class.new movie_config }

  let(:movie_config) do
    {'adult'=>false,
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
     'vote_count'=>25}
  end

  describe '#title' do
    subject(:title) { movie.title }

    it 'returns the movie title' do
      expect(title).to eq movie_config['title']
    end
  end

  describe '#overview' do
    subject(:overview) { movie.overview }

    it 'returns the movie overview' do
      expect(overview).to eq movie_config['overview']
    end
  end

  describe '#poster_path' do
    subject(:poster_path) { movie.poster_path }

    it 'returns the movie poster_path' do
      expect(poster_path).to eq movie_config['poster_path']
    end
  end
end