class CacheHit < ApplicationRecord
  def increase_counter!
    self.increment!(:count)
  end
end
