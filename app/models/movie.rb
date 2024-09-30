class Movie
  attr_reader :title, :overview, :poster_path,
              :original_language, :original_title,
              :adult, :popularity, :release_date,
              :vote_average, :vote_count,
              :video

  def initialize(config)
    config.each do |attr, value|
      instance_variable_set("@#{attr}", value)
    end
  end
end
