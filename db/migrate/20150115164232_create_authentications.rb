class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.belongs_to :user, index: true

      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token
      t.string :secret
      t.string :access_token_digest

      t.boolean :expires

      t.timestamp :expires_at

      t.json :info
      t.json :extra

      t.timestamps null: false
    end

    add_index :authentications, [:provider, :uid], unique: true

    add_foreign_key :authentications, :users, on_cascade: :delete
  end
end
