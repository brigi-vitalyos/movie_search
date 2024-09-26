class MoviesController < ApplicationController
  def index
  end

  def search
    response = MoviesClient.new.search(params[:query_string])
    @movies = process_movies(response['results'])
    render :index
  rescue
    redirect_to '/500'
  end

  private
  def process_movies(results)
    results.each_with_object([]) do |movie, arr|
      arr << Movie.new(movie)
    end
  end
end
