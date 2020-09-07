class DashboardController < ApplicationController
  include BaseConcern

  before_action :require_login
  #before_action :load_access_token
  #before_action :base_profile
  #

  def index
    # redirect_to action: :shops if current_user.shops.blank?
    base_orders
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
  end

  def base_auth_callback
    if params[:code]
      res = base_auth_with_code
      Shop.new(
        base_access_token: res['access_token'],
        base_access_token_expires_at: 1.hour.since,
        base_refresh_token: res['refresh_token'],
        base_refresh_token_expires_at: 30.days.since
      )
      profile = base_profile

    end
    redirect_to dashboard_index_path
  end

  private

  def load_access_token(shop)
    if shop.base_access_token_expired?
      res = base_auth_with_refresh_token
      shop.new(
        base_access_token: res['access_token'],
        base_access_token_expires_at: 1.hour.since,
        base_refresh_token: res['refresh_token'],
        base_refresh_token_expires_at: 30.days.since
      )
    end
  end
end
