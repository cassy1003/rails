class Item < ApplicationRecord
  belongs_to :shop
  has_many :item_supplier

  enum tax_type: {nomarl: 1, reduced: 2}
  enum visible: {show: 1, hide: 0}
end
