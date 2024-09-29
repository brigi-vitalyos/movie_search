class MoviesController < ApplicationController
  def index
  end

  def search
    movies_repo = MoviesRepository.new
    @cache_hit_count = 0

    result = movies_repo.fetch query_string, page_number
    if result.nil? || result.empty?
      result = MoviesClient.new.search(query_string, page: page_number)
      movies_repo.store query_string, page_number, result
      create_first_cache_hit_for(query_string, page_number)
    else
      cache_hit = cache_hit_for(query_string, page_number)
      cache_hit.increase_counter!
      @cache_hit_count = cache_hit.count
    end
    @total_pages = result['total_pages']
    @movies = process_movies(result['results'])

    render :index
  rescue
    render 'errors/server_error'
  end

  private
  def process_movies(results)
    results.each_with_object([]) do |movie, arr|
      arr << Movie.new(movie)
    end
  end

  private

  def create_first_cache_hit_for(query_string, page_number)
    CacheHit.create! query_string: query_string,
                     page_number: page_number
  end

  def cache_hit_for(query_string, page_number)
    CacheHit.where(query_string: query_string, page_number: page_number)
            .where('created_at > ?', 2.minutes.ago.to_s).first
  end
  def query_string
    params[:query_string]
  end

  def page_number
    @current_page ||= (params[:page_number] || 1).to_i
  end
end
