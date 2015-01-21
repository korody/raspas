class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.belongs_to :user

      t.string :provider, null: false
      t.string :uid, null: false

      t.string :info

      t.string :token
      t.string :secret
      t.boolean :expires
      t.timestamp :expires_at

      t.string :extra

      t.timestamps null: false
    end
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid], unique: true
  end
end
