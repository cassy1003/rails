require 'csv'

class CsvImporter
  def self.import(csv_text)
    header = nil
    items = []
    CSV.parse(csv_text.gsub(/\n/, '')) do |row|
      header = row and next if row[0] == '商品登録'
      next if header.nil?

      item = {}
      target = nil
      header.each_with_index do |key, idx|
        next if key.nil?
        item[key] = row[idx]

        case key
        when '商品番号'
          break if row[idx].blank?
          target = Item.where('detail LIKE ?', "%#{row[idx]}%").last
          break if target.blank?
        when '仕入先URL①'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 1)
          supplier.update(url: row[idx])
        when '仕入先URL②'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 2)
          supplier.update(url: row[idx])
        when '仕入先URL③'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 3)
          supplier.update(url: row[idx])
        when '仕入先URL④'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 4)
          supplier.update(url: row[idx])
        when '仕入先URL⑤'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 5)
          supplier.update(url: row[idx])
        when '仕入先URL⑥'
          next if row[idx].blank?
          supplier = ItemSupplier.find_or_create_by(item: target, priority: 6)
          supplier.update(url: row[idx])
        end
      end
    end

  end
end
