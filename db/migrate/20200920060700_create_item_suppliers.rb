class CreateItemSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :item_suppliers do |t|
      t.references :item, index: true, foreign_key: true
      t.string :url
      t.integer :priority

      t.timestamps
    end
  end
end
