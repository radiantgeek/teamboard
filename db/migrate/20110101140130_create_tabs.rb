class CreateTabs < ActiveRecord::Migration
  def self.up
    create_table :tabs do |t|
      t.string :name
      t.string :title
      t.integer :pos
      t.boolean :is_showed, :default => false, :null => false
      t.boolean :show_on_sidebar, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tabs
  end
end
