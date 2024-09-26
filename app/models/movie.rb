class Movie
  attr_reader :title, :description, :poster_path

  def initialize(config)
    @config = config
  end

  def title
    @config['title']
  end

  def description
    @config['overview']
  end
  def poster_path
    @config['poster_path']
  end
end