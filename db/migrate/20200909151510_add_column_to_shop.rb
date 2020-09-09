class AddColumnToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :order_updated_at, :datetime
    add_column :shops, :item_updated_at, :datetime
  end
end
