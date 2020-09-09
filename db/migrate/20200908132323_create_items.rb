class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :key
      t.string :name
      t.string :detail
      t.integer :price
      t.integer :proper_price
      t.integer :tax_type
      t.integer :stock
      t.integer :visible
      t.integer :display_order
      t.string :images, array: true
      t.datetime :modified_at
      t.jsonb :variations

      t.timestamps
    end
  end
end
