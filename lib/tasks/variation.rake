namespace :variation do
  #desc '既存のvariationsをItemVariatinに移行'
  #task convert: :environment do
  #  Item.all.each do |item|
  #    item.variations.each do |va|
  #      item.item_variations.find_or_create_by(base_id: va['variation_id']) do |iva|
  #        iva.text = va['variation']
  #        iva.stock = va['variation_stock']
  #        iva.key = va['variation_identifier']
  #        iva.barcode = va['barcode']
  #      end
  #    end
  #  end
  #end
end
