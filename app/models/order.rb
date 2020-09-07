class Order < ApplicationRecord
  belongs_to :shop

  enum payment: {
    creditcard: 1,
    bt: 2,
    cod: 3,
    cvs: 4,
    base_bt: 5,
    atobarai: 6,
    paypal: 7,
    coin: 8,
    carrier_01: 11,
    carrier_02: 12,
    carrier_03: 13
  }

  enum status: {
    ordered: 1,
    cancelled: 2,
    dispatched: 3,
    unpaid: 4,
    shipping: 5
  }

  def self.find_or_initialize_by_res(res)
    find_or_initialize_by(key: res['unique_key']) do |order|
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
    end
  end
end
