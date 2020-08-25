class UserSessionsController < ApplicationController
  include BaseConcern

  def new
    #@base_auth_url = Rails.env.production? ? base_auth_url : dashboard_index_path
    @base_auth_url = base_auth_url
  end

  def create
  end

  def callback
    if params[:code]
      base_auth_with_code
    end
    redirect_to dashboard_index_path
  end

end
