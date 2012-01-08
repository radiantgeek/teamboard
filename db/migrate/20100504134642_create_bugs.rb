class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.integer :reporter_id
      t.integer :qa_contact_id
      t.integer :assigned_to_id
      t.text :summary
      t.text :btype
      t.text :status
      t.text :resolution
      t.text :need_info_from
      t.text :severity
      t.text :priority
      t.datetime :created
      t.datetime :modified
      t.string :milestone
      t.string :released_at
      t.string :module
      t.string :component
      t.string :product
      t.string :version
      t.string :build
      t.string :platform
      t.string :os
      t.string :to_discuss
      t.string :confirmed
      t.string :is_open
      t.string :team
      t.text   :comment
      t.integer :testsfailed
      t.float	:estimated_time
      t.float 	:remaining_time
      t.string	:test_case

      t.timestamps
    end
  end

  def self.down
    drop_table :bugs
  end
end
