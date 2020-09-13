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
    return if modified_item?(res['modified'])

    item = Item.find_or_initialize_by(key: res['item_id'])
    item.name = res['title']
    item.detail = res['detail']
    item.price = res['price']
    item.proper_price = res['proper_price']
    item.tax_type = res['item_tax_type']
    item.stock = res['stock']
    item.visible = res['visible']
    item.display_order = res['list_order']
    item.images = [res['img1_origin'], res['img2_origin'], res['img3_origin'], res['img4_origin'], res['img5_origin']].compact
    item.variations = res['variations']
    item.modified_at = Time.zone.at(res['modified'])
    item.shop_id = id if item.new_record?
    item.save
  end

  def modified_item?(modified_ts)
    item_updated_at.present? && item_updated_at > Time.zone.at(modified_ts)
  end

  def create_order_by_res(res)
    return if modified_order?(res['modified'])

    order = Order.find_or_initialize_by(key: res['unique_key'])
    order.ordered_at = Time.zone.at(res['ordered'])
    order.cancelled_at = Time.zone.at(res['cancelled']) if res['cancelled'].present?
    order.dispatched_at = Time.zone.at(res['dispatched']) if res['dispatched'].present?
    order.payment = res['payment']
    order.first_name = res['first_name']
    order.last_name = res['last_name']
    order.price = res['total']
    order.delivery_date = res['delivery_date']
    order.status = res['dispatch_status']
    order.modified_at = Time.zone.at(res['modified']) if res['modified'].present?
    order.subscription_key = res['subscription']['unique_key']
    order.subscription_repeat_number = res['subscription']['repeat_number']
    order.subscription_repeat_times = res['subscription']['repeat_times']
    order.shop_id = id if order.new_record?
    order.save
  end

  def modified_order?(modified_ts)
    order_updated_at.present? && order_updated_at > Time.zone.at(modified_ts)
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
