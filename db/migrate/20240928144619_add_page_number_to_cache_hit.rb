class AddPageNumberToCacheHit < ActiveRecord::Migration[7.2]
  def change
    add_column :cache_hits, :page_number, :integer
  end
end
