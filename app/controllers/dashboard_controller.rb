require 'csv'

class DashboardController < ApplicationController
  before_action :require_login
  before_action :require_approved

  def index
    @shop = current_user.shops.first

    if @shop.present?
      now = DateTime.now
      if @shop.order_updated_at.nil? || @shop.order_updated_at < now - 12.hours
        update_date = @shop.orders.progressing.first.try(:ordered_at) ||
                      @shop.orders.order(:ordered_at).last.try(:ordered_at) ||
                      now.yesterday
        update_orders(update_date.strftime('%Y-%m-%d'))
      end
      if @shop.item_updated_at.nil? || @shop.item_updated_at < now - 12.hours
        update_items('modified', 'desc')
      end

      @orders = @shop.orders.order(modified_at: 'DESC').first(10)
      @orders_summary = @shop.orders_summary

      daily_price = @orders_summary[:daily][:price]
      monthly_price = @orders_summary[:monthly][:price]
      yearly_price = @orders_summary[:yearly][:price]
      @sales = {
        today: calc_sales(daily_price, now, '%Y/%m/%d').to_s(:delimited),
        yesterday: calc_sales(daily_price, now.yesterday, '%Y/%m/%d').to_s(:delimited),
        this_month: calc_sales(monthly_price, now, '%Y/%m').to_s(:delimited),
        last_month: calc_sales(monthly_price, (now - 1.month), '%Y/%m').to_s(:delimited),
        this_year: calc_sales(yearly_price, now, '%Y').to_s(:delimited),
        last_year: calc_sales(yearly_price, (now - 1.year), '%Y').to_s(:delimited)
      }
      gon.orders_summary = {
        daily: {
          labels: (0...14).map {|n| (now - (14 - n).days).strftime('%-m/%-d')},
          data: (0...14).map {|n| calc_sales(daily_price, (now - (14 - n).days), '%Y/%m/%d')},
        },
        monthly: {
          labels: (0...12).map {|n| (now - (12 - n).months).strftime('%Y/%-m')},
          data: (0...12).map {|n| calc_sales(monthly_price, (now - (12 - n).months), '%Y/%m')},
        }
      }
    else
      @base_auth_url = Base::Api.auth_url
    end
  end

  def items
    @shop = current_user.shops.first
    gon.items = @shop.items.order(modified_at: 'DESC').map do |item|
      {
        visible: item.show?,
        base_id: item.key,
        name: item.name,
        price: item.price.to_s(:delimited),
        stock: item.stock,
        images: item.images,
        updated_at: item.modified_at.strftime('%Y/%m/%d %H:%M')
      }
    end
  end

  def orders
    @shop = current_user.shops.first

    respond_to do |format|
      format.html do
        gon.orders = @shop.orders.order(modified_at: 'DESC').map do |order|
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

  def members
    redirect_to action: :index unless current_user.admin?

    @shop = current_user.shops.first
    @admins = Owner.admin
    @members = Owner.member
    gon.members = Owner.member.order(updated_at: 'DESC').map do |member|
      {
        id: member.id,
        name: member.name,
        term: member.term,
        facebook_name: member.facebook_name,
        line_name: member.line_name,
        status: member.status_i18n,
        isApproved: member.approved?,
        created_at: member.created_at.strftime('%Y/%m/%d %H:%M')
      }
    end
  end

  def shops
    @shops = current_user.shops
    @base_auth_url = Base::Api.auth_url #base_auth_url
    if ENV['BASE_REFRESH_TOKEN'].present?
      tokens = Base::Api.auth_with_refresh_token(ENV['BASE_REFRESH_TOKEN'])
      shop_params = Base::Api.profile(tokens[:base_access_token])
      shop = Shop.find_or_initialize_by(base_id: shop_params[:base_id])
      shop.update(shop_params.merge(tokens))
      ShopUser.create(user: current_user, shop: shop, role: :admin)
    end
  end

  def base_auth_callback
    tokens = if params[:code]
               Base::Api.auth_with_code(params[:code])
             else
               Base::Api.auth_with_refresh_token(ENV['BASE_REFRESH_TOKEN'])
             end
    shop_params = Base::Api.profile(tokens[:base_access_token])
    @shop = Shop.find_or_initialize_by(base_id: shop_params[:base_id])
    @shop.update(shop_params.merge(tokens))
    ShopUser.find_or_create_by(user: current_user, shop: @shop, role: :admin)

    update_items

    update_orders

    redirect_to dashboard_path
  end

  def import_item_csv
    CsvImporter.import( File.read(params[:csv_file]) )
    flash[:notice] = '読み込みが完了しました'
    redirect_to action: :items
  end

  private

  def require_approved
    if current_user.approved_by.nil?
      logout
      redirect_to signin_path
    end
  end

  def calc_sales(prices, date, format)
    (prices[date.strftime(format)].try(:values) || [0]).inject(:+)
  end

  def update_orders(start = '2019-01-01')
    offset = 0
    limit = 100
    orders = []
    loop do
      res = Base::Api.orders(@shop.latest_access_token, start, limit, offset)
      orders += res
      break if res.count < limit
      offset += limit
    end
    orders.reverse_each {|order| @shop.create_order_by_res(order)}
    @shop.update(order_updated_at: DateTime.now)
  end

  def update_items(order = 'list_order', sort = 'asc')
    offset = 0
    limit = 10
    items = []
    loop do
      res = Base::Api.items(@shop.latest_access_token, order, sort, limit, offset)
      items += res
      break if @shop.modified_item?(items.last['modified'])
      break if res.count < limit || offset >= 2000
      offset += limit
    end
    if sort == 'asc'
      items.each {|item| @shop.create_item_by_res(item)}
    else
      items.reverse_each {|item| @shop.create_item_by_res(item)}
    end
    @shop.update(item_updated_at: DateTime.now)
  end
end
