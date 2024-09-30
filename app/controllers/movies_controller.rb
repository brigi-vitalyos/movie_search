class MoviesController < ApplicationController
  def index
  end

  def search
    cached_result = movies_repo.fetch query_string, page_number

    if cached_result.nil? || cached_result.empty?
      cache_hit_count, result = execute_search_using_api
    else
      cache_hit_count, result = increase_cache_hit_count, cached_result
    end

    @cache_hit_count = cache_hit_count
    @total_pages = result['total_pages']
    @movies = process_movies(result['results'])

    render :index
  rescue
    render 'errors/server_error'
  end

  def show
    @movie = Movie.new JSON.parse(params[:movie])
  rescue
    render 'errors/server_error'
  end

  private

  def execute_search_using_api
    result = MoviesClient.new.search(query_string, page: page_number)
    movies_repo.store query_string, page_number, result
    create_first_cache_hit_for(query_string, page_number)

    [0, result]
  end

  def increase_cache_hit_count
    cache_hit = CacheHit.where(query_string: query_string, page_number: page_number)
                        .where('created_at > ?', 2.minutes.ago.to_s).first
    cache_hit.increase_counter!

    cache_hit.count
  end

  def process_movies(results)
    results.each_with_object([]) do |movie, arr|
      arr << Movie.new(movie)
    end
  end

  private

  def movies_repo
    MoviesRepository.new
  end

  def create_first_cache_hit_for(query_string, page_number)
    CacheHit.create! query_string: query_string,
                     page_number: page_number
  end

  def query_string
    params[:query_string].to_s
  end

  def page_number
    @current_page ||= (params[:page_number] || 1).to_i
  end
end
