class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :name
      t.string :title
      t.string :color
      t.string :tab_name
      t.integer :pos
      t.boolean :active
    end
  end

  def self.down
    drop_table :metrics
  end
end
