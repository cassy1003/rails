class DashboardController < ApplicationController
  include BaseConcern

  before_action :check_expired
  before_action :load_access_token
  before_action :base_profile

  def index
  end

  private

  def check_expired
    if session[:base_refresh_token].nil? || session[:base_refresh_token_expired_at] < Time.zone.now
      redirect_to root_path
    end
  end

  def load_access_token
    if session[:base_access_token_expired_at] < Time.zone.now
      base_auth_with_refresh_token
    end
  end
end
