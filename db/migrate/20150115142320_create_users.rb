class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :username, null: false
      t.string :display_username, null: false
      t.string :image
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :display_username, unique: true
  end
end
