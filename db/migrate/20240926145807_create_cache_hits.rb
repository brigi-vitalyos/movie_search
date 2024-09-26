class CreateCacheHits < ActiveRecord::Migration[7.2]
  def change
    create_table :cache_hits do |t|
      t.integer :count
      t.text :query_string

      t.timestamps
    end
  end
end
