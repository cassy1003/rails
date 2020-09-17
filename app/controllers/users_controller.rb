class UsersController < ApplicationController
  def new
    @user = User.new(role: params[:r] || :member)
    @require_params = require_params
  end

  def create
    @user = params[:role] == 'staff' ? Staf.new(user_params) : Owner.new(user_params)
    if @user.save
      redirect_to root_path
    else
      flash[:alert] = @user.errors.full_messages.join('<br>') if @user.errors.any?
      redirect_to signup_path
    end
  end

  private

  def require_params
    p = %i|name email password password_confirmation|
    p += %i|term line_name facebook_name| if @user.member?
    p
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role,
      :term,
      :line_name,
      :facebook_name
    )
  end
end
