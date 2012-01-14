class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.string :name
      t.string :title
      t.string :version
      t.string :milestone
      t.date :start
      t.date :stop
      t.date :plan_stop
      t.boolean :active, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
