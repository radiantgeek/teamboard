class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :name, :unique => true
      t.string :title
      t.string :color
      t.string :tab_name
      t.integer :pos
      t.boolean :active, :default => false, :null => false
    end
  end

  def self.down
    drop_table :metrics
  end
end
