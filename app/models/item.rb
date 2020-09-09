class Item < ApplicationRecord
  belongs_to :shop

  enum tax_type: {nomarl: 1, reduced: 2}
  enum visible: {show: 1, hide: 0}

  def self.find_or_initialize_by_res(res)
    find_or_initialize_by(key: res['item_id']) do |item|
      item.name = res['title']
      item.detail = res['detail']
      item.price = res['price']
      item.proper_price = res['proper_price']
      item.tax_type = res['item_tax_type']
      item.stock = res['stock']
      item.visible = res['visible']
      item.display_order = res['list_order']
      item.images = [res['img1_origin'], res['img2_origin'], res['img3_origin'], res['img4_origin'], res['img5_origin']]
      item.variations = res['variations']
      item.modified_at = Time.zone.at(res['modified'])
    end
  end
end
