class Movie
  attr_reader :title, :overview, :poster_path

  def initialize(config)
    config.each do |attr, value|
      instance_variable_set("@#{attr}", value)
    end
  end
end