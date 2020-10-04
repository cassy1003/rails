class CreateItemVariations < ActiveRecord::Migration[6.0]
  def change
    create_table :item_variations do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :base_id, null: false
      t.string :text
      t.integer :stock
      t.string :key
      t.string :barcode

      t.timestamps
    end
  end
end
