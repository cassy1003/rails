class DashboardController < ApplicationController
  before_action :require_login

  def index
    @shop = current_user.shops.first

    if @shop.present?
      @orders = @shop.orders.order(modified_at: 'DESC').first(10)
      @daily_order_count = @shop.daily_order_count
      @monthly_order_count = @shop.monthly_order_count
    else
      @base_auth_url = Base::Api.auth_url
    end

    # redirect_to action: :shops if current_user.shops.blank?
    #base_orders
  end

  def items
    base_items
  end

  def orders
    base_orders
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
    shop = Shop.find_or_initialize_by(base_id: shop_params[:base_id])
    shop.update(shop_params.merge(tokens))
    ShopUser.find_or_create_by(user: current_user, shop: shop, role: :admin)

    # offset = 0
    # limit = 100
    # items = []
    # loop do
    #   res = Base::Api.items(shop.latest_access_token, 'list_order', 'asc', limit, offset)['items']
    #   items += res
    #   break if res.count < limit && items.count >= 2000
    #   offset += limit
    # end

    offset = 0
    limit = 100
    orders = []
    loop do
      res = Base::Api.orders(shop.latest_access_token, '2019-01-01', limit, offset)
      orders += res
      break if res.count < limit
      offset += limit
    end
    orders.reverse_each {|order| shop.create_order_by_res(order)}

    redirect_to dashboard_path
  end
end
