class MoviesController < ApplicationController
  def index
  end

  def search
    movies_repo = MoviesRepository.new
    @cache_hit_count = 0

    result = movies_repo.fetch query_string, page_number
    if result.nil? || result.empty?
      result = MoviesClient.new.search(query_string)
      movies_repo.store query_string, page_number, result
      CacheHit.create! query_string: query_string, count: @cache_hit_count
    else
      @cache_hit_count = cache_hit_for(query_string).count + 1
      cache_hit_for(query_string).update count: @cache_hit_count
    end
    @movies = process_movies(result['results'])
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

  def cache_hit_for(query_string)
    @cache_hit ||= CacheHit.where(query_string: query_string).where('created_at > ?', 2.minutes.ago.to_s).first
  end
  def query_string
    params[:query_string]
  end

  def page_number
    1
  end
end
