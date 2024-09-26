class MoviesController < ApplicationController
  def index
  end

  def search
    movies_repo = MoviesRepository.new

    cached_result = movies_repo.fetch query_string, page_number
    if cached_result.nil? || cached_result.empty?
      response = MoviesClient.new.search(query_string)
      movies_repo.store query_string, page_number, response
      @movies = process_movies(response['results'])
    else
      @movies = process_movies(cached_result['results'])
    end
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

  private

  def query_string
    params[:query_string]
  end

  def page_number
    1
  end
end
