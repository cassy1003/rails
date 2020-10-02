require 'csv'

class DashboardController < ApplicationController
  before_action :require_login
  before_action :require_approved
  before_action :load_default_shop

  def index
    if @shop.present?
      now = DateTime.now
      if @shop.order_updated_at.nil? || @shop.order_updated_at < now - 3.hours
        update_date = @shop.orders.progressing.first.try(:ordered_at) ||
                      @shop.orders.order(:ordered_at).last.try(:ordered_at) ||
                      now.yesterday
        @shop.update_orders(update_date.strftime('%Y-%m-%d'))
      end
      if @shop.item_updated_at.nil? || @shop.item_updated_at < now - 12.hours
        @shop.update_items('modified', 'desc')
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

    @shop.update_items

    @shop.update_orders

    redirect_to dashboard_path
  end

  private

  def require_approved
    if current_user.approved_by.nil?
      logout
      redirect_to signin_path
    end
  end

  def load_default_shop
    @shop = current_user&.shops&.first
  end

  def calc_sales(prices, date, format)
    (prices[date.strftime(format)].try(:values) || [0]).inject(:+)
  end
end
