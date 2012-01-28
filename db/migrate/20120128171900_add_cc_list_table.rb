class AddCcListTable < ActiveRecord::Migration
  def change
    create_table :cc_list, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :bug_id, :null => false
    end

    add_index(:cc_list, :user_id)
    add_index(:cc_list, :bug_id)
  end
end
