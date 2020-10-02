
CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  header = %w|BASE_ID 注文日 更新日 ステータス 注文者 料金 支払い方法|
  csv << header

  @shop.orders.ordered.map do |order|
    values = [
      order.key,
      order.ordered_at,#.strftime('%Y/%m/%d %H:%M'),
      order.modified_at,#.strftime('%Y/%m/%d %H:%M'),
      order.status_i18n,
      order.last_name + ' ' + order.first_name,
      order.price,
      order.payment_i18n
    ]
    csv << values
  end
end
