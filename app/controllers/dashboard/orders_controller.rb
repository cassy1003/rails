class Dashboard::OrdersController < DashboardController
  def index
    respond_to do |format|
      format.html do
        gon.orders = @shop.orders.order(ordered_at: 'DESC').map do |order|
          {
            key: order.key,
            customer_name: order.last_name + ' ' + order.first_name,
            status: order.status_i18n,
            price: order.price.to_s(:delimited),
            payment: order.payment_i18n,
            ordered_at: order.ordered_at.strftime('%Y/%m/%d %H:%M'),
            updated_at: order.modified_at.strftime('%Y/%m/%d %H:%M')
          }
        end
      end

      format.csv do
        filename = "(仮)new_orders_#{Time.zone.now.to_date.to_s}.csv"
        send_data render_to_string, filename: filename, type: :csv
      end
    end
  end

  def load_detail
    @shop.orders.progressing.take(1).each do |order|
      res = Base::Api.order_detail(@shop.latest_access_token, order)
      binding.pry
    end
  end
end
