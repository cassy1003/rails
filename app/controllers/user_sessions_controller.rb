class UserSessionsController < ApplicationController
  def new
    @base_auth_url = "#{base_api_url('oauth/authorize')}?response_type=code&client_id=#{ENV['BASE_CLIENT_ID']}&redirect_uri=#{callback_url}&scope=read_users%20read_items%20read_orders"
  end

  def create
  end

  def callback
    if params[:code]
      response = Typhoeus.post(base_api_url('oauth/token'), body: {
        grant_type: 'authorization_code',
        client_id: ENV['BASE_CLIENT_ID'],
        client_secret: ENV['BASE_CLIENT_SECRET'],
        code: params[:code],
        redirect_uri: base_callback_url
      })
      session[:base_access_token] = response[:access_token]
      session[:base_refresh_token] = response[:refresh_token]
      session[:base_auth_code] = params[:code]
    end
    redirect_to dashboard_index_path
  end

  private

  def base_api_domain
    'https://api.thebase.in/1/'
  end

  def base_api_url(api_key)
    "#{base_api_domain}#{api_key}"
  end

  def base_callback_url
    'https%3A%2F%2Fowners-dev.herokuapp.com%2Fauth%2Fcallback%2Fbase'
  end

end
