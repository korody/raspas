class AddEmailAndPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, null: false
    add_column :users, :password_digest, :string
    add_index :users, :email
  end
end
