class UserSessionsController < ApplicationController
  before_action :require_login, only: %i|destroy|

  def new
  end

  def create
    if @user = login(params[:email], params[:password])
      if @user.approved_by.present?
        redirect_back_or_to(dashboard_url)
      else
        logout
        flash[:alert] = 'まだ承認されておりません'
        redirect_to signin_path
      end
    else
      flash[:alert] = 'ログインに失敗しました'
      redirect_to signin_path
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'ログアウトしました')
  end
end
