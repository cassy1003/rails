class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :base_id, null: false, unique: true
      t.string :name, null: false
      t.string :introduction
      t.string :url
      t.string :logo
      t.string :email

      t.string :base_access_token
      t.datetime :base_access_token_expires_at
      t.string :base_refresh_token
      t.datetime :base_refresh_token_expires_at

      t.timestamps
    end
  end
end
