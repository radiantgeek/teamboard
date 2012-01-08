class CreateSyncs < ActiveRecord::Migration
  def self.up
    create_table :syncs do |t|
      t.date :sync

      t.timestamps
    end
  end

  def self.down
    drop_table :syncs
  end
end
