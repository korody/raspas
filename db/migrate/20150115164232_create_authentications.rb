class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.belongs_to :user, null: false

      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps null: false
    end
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid], unique: true
  end
end
