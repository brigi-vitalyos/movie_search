require 'redis'
require 'json'

class MoviesRepository
  TWO_MINUTES_IN_SECONDS = 2 * 60

  def initialize
    @redis ||= Redis.new(url: ENV['MOVIES_REDIS_URL'])
  end

  def fetch(query_string, page_number)
    result = @redis.get(key_for(query_string, page_number))
    JSON.parse(result) if result
  end

  def store(query_string, page_number, results)
    @redis.set(key_for(query_string, page_number), JSON.dump(results), ex: TWO_MINUTES_IN_SECONDS)
  end

  private

  def key_for(query_string, page_number)
    "#{query_string}_#{page_number}"
  end
end
