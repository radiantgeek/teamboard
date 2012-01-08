class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :real_name
      t.string :email
      t.string :name
      t.boolean :can_login
      t.boolean :email_enabled

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
