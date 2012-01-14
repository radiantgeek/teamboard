class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      t.string :name
      t.string :title
      t.string :build
      t.string :release_name
      t.string :description
      t.date :start
      t.date :stop
      t.boolean :active, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :sprints
  end
end
