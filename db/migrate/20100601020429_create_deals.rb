class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.string :title
      t.string :url
      t.float  :price
      t.string :description
      t.integer :points
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
