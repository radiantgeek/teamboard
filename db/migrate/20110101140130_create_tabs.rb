class CreateTabs < ActiveRecord::Migration
  def self.up
    create_table :tabs do |t|
      t.string :name
      t.string :title
      t.integer :pos
      t.boolean :is_showed, :default => false
      t.boolean :show_on_sidebar, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tabs
  end
end
