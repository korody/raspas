class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :username, null: false
      t.string :display_username, null: false
      t.string :photo

      t.timestamps null: false
    end
    add_index :users, :username, unique: true
    add_index :users, :display_username, unique: true
  end
end
