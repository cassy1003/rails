class Item < ApplicationRecord
  belongs_to :shop
  has_many :variations, class_name: 'ItemVariation', foreign_key: 'item_id', dependent: :destroy
  has_many :suppliers, class_name: 'ItemSupplier', foreign_key: 'item_id', dependent: :destroy

  enum tax_type: {nomarl: 1, reduced: 2}
  enum status: {published: 1, unpublished: 0, draft: -1}
end
