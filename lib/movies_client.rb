##
# This class responsible to process movies list
require 'faraday'

class MoviesClient
  BASE_URL='https://api.themoviedb.org/3/search/movie'
  def search(query_string, page: 1)
    response = client.get("?query=#{CGI.escape(query_string)}&page=#{page}")
    raise 'Movie Database Server Unavailable' if response.status >= 500
    response.body
  end



  def client
    Faraday.new(BASE_URL) do |faraday|
      faraday.request :authorization, 'Bearer', ENV['MOVIE_API_KEY']
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
    end
  end
end

