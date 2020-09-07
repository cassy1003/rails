class CreateShopUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
