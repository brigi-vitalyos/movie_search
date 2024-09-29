class AddDefaultValueToCacheHitCount < ActiveRecord::Migration[7.2]
  def change
    change_column_default :cache_hits, :count, 0
  end
end
