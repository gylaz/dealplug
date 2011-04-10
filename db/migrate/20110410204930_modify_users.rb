class ModifyUsers < ActiveRecord::Migration
  def self.up
    # removing uniquness on the email index
    remove_index :users, :email
    add_index :users, :email

    # devise upgrade (salt no longer needed)
    remove_column :users, :password_salt
  end

  def self.down
  end
end
