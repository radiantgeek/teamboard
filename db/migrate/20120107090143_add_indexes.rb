class AddIndexes < ActiveRecord::Migration
  def up
    add_index(:bugs, :assigned_to_id)
    add_index(:bugs, :reporter_id)
    add_index(:bugs, :status, :length => 10)
    add_index(:bugs, :milestone)

    add_index(:users, :email)
    add_index(:users, :name)

    add_index(:metrics, :name, :unique => true)
    add_index(:metrics, :tab_name)

    add_index(:tabs, :name, :unique => true)

    add_index(:releases, :name, :unique => true)

    add_index(:sprints, :name, :unique => true)
    add_index(:sprints, :release)
  end

  def down
  end
end
