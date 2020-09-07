class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :key
      t.datetime :ordered_at
      t.datetime :cancelled_at
      t.datetime :dispatched_at
      t.integer :payment
      t.integer :price
      t.date :delivery_date
      t.integer :status
      t.datetime :modified_at
      t.string :subscription_key
      t.integer :subscription_repeat_number
      t.integer :subscription_repeat_times

      t.timestamps
    end
  end
end
