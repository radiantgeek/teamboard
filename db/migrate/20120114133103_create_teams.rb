class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :title
      t.integer :alpha, :default => 1
      t.boolean :active, :null => false, :default => false

      t.timestamps
    end

    add_index(:teams, :name, :unique => true)
  end
end
