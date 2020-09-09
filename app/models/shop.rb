class Shop < ApplicationRecord
  has_many :shop_users
  has_many :users, through: :shop_users
  has_many :orders
  has_many :items

  def base_access_token_expired?
    base_access_token_expires_at < Time.zone.now
  end

  def base_refresh_token_expired?
    base_refresh_token_expires_at < Time.zone.now
  end

  def latest_access_token
    if base_access_token_expired?
      tokens = Base::Api.auth_with_refresh_token(base_refresh_token)
      update(tokens)
    end
    base_access_token
  end

  def create_item_by_res(res)
    item = Item.find_or_initialize_by_res(res)
    item.update(shop_id: id) if item.new_record?
  end

  def create_order_by_res(res)
    order = Order.find_or_initialize_by_res(res)
    order.update(shop_id: id) if order.new_record?
  end

  def orders_summary
    {
      daily: { count: to_h(orders.daily.count), price: to_h(orders.daily.sum(:price)) },
      monthly: { count: to_h(orders.monthly.count), price: to_h(orders.monthly.sum(:price)) },
      yearly: { count: to_h(orders.yearly.count), price: to_h(orders.yearly.sum(:price)) },
    }
  end

  private

  def to_h(values)
    result = {}
    values.each do |arr, v|
      result[arr[0]] = {} if result[arr[0]].nil?
      result[arr[0]][arr[1]] = v
    end
    result
  end
end
