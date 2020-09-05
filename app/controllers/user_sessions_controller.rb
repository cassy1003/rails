class UserSessionsController < ApplicationController
  include BaseConcern

  before_action :require_login, only: %i|destroy|

  def new
    #@base_auth_url = Rails.env.production? ? base_auth_url : dashboard_index_path
    @base_auth_url = base_auth_url
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(dashboard_url)
    else
      # flash[:alert] = 'ログイン失敗'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'ログアウトしました')
  end

  def callback
    if params[:code]
      base_auth_with_code
    end
    redirect_to dashboard_index_path
  end

end
