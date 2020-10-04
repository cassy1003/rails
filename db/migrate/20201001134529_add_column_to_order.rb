class AddColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :shipping_method, :string
    add_column :orders, :shipping_fee, :integer
    add_column :orders, :cod_fee, :integer
    add_column :orders, :country, :string
    add_column :orders, :zip_code, :string
    add_column :orders, :prefecture, :string
    add_column :orders, :address, :string
    add_column :orders, :address2, :string
    add_column :orders, :email, :string
    add_column :orders, :tel, :string
    add_column :orders, :remark, :string
    add_column :orders, :comment, :string
    add_column :orders, :delivery_company_id, :integer
    add_column :orders, :delivery_time_zone, :string
    add_column :orders, :tracking_number, :string
    add_column :orders, :receiver_first_name, :string
    add_column :orders, :receiver_last_name, :string
    add_column :orders, :receiver_zipcode, :string
    add_column :orders, :receiver_prefecture, :string
    add_column :orders, :receiver_address, :string
    add_column :orders, :receiver_address2, :string
    add_column :orders, :receiver_tel, :string
    add_column :orders, :receiver_country, :string
    add_column :orders, :balance_logs, :text, array: true
  end
end
