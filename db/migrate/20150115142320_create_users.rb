class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :username, null: false, index: { unique: true }
      t.string :display_username, null: false, index: { unique: true }
      t.string :photo
      t.string :password_digest

      t.string :remember_digest, :string

      t.string :reset_digest, :string
      t.string :reset_sent_at, :datetime

      t.timestamps null: false
    end
  end
end
