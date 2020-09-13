class Item < ApplicationRecord
  belongs_to :shop

  enum tax_type: {nomarl: 1, reduced: 2}
  enum visible: {show: 1, hide: 0}
end
