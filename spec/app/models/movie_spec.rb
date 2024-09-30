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
  
  attributes = %w[title overview poster_path
              original_language original_title
              adult popularity release_date
              vote_average vote_count
              video]

  attributes.each do |attribute|
    describe "##{attribute}" do
      subject { movie.send(attribute) }

      it "returns the movie #{attribute}" do
        expect(subject).to eq movie_config[attribute]
      end
    end
  end
end