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

  scope :valid, -> { where.not(status: :cancelled) }

  scope :progressing, -> { where.not(status: [:cancelled, :dispatched]).order(:ordered_at) }

  scope :daily, -> {
    group("to_char(ordered_at AT TIME ZONE 'UTC' AT TIME ZONE 'JST', 'YYYY/MM/DD')").group(:status).order(:to_char_ordered_at_at_time_zone_utc_at_time_zone_jst_yyyy_mm_dd)
  }

  scope :monthly, -> {
    group("to_char(ordered_at AT TIME ZONE 'UTC' AT TIME ZONE 'JST', 'YYYY/MM')").group(:status).order(:to_char_ordered_at_at_time_zone_utc_at_time_zone_jst_yyyy_mm)
  }

  scope :yearly, -> {
    group("to_char(ordered_at AT TIME ZONE 'UTC' AT TIME ZONE 'JST', 'YYYY')").group(:status).order(:to_char_ordered_at_at_time_zone_utc_at_time_zone_jst_yyyy)
  }
end
