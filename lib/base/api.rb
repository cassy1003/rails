class Base::Api
  def self.auth_url
    "#{base_api_url('oauth/authorize')}?response_type=code&client_id=#{ENV['BASE_CLIENT_ID']}&redirect_uri=#{base_callback_url}&scope=read_users%20read_items%20read_orders"
  end

  def self.auth_with_code(code)
    request = Typhoeus.post(base_api_url('oauth/token'), params: {
      grant_type: 'authorization_code',
      client_id: ENV['BASE_CLIENT_ID'],
      client_secret: ENV['BASE_CLIENT_SECRET'],
      code: code,
      redirect_uri: base_callback_url
    })
    JSON.parse(response_body)
  end

  def self.auth_with_refresh_token(refresh_token)
    request = Typhoeus.post(base_api_url('oauth/token'), params: {
      grant_type: 'refresh_token',
      client_id: ENV['BASE_CLIENT_ID'],
      client_secret: ENV['BASE_CLIENT_SECRET'],
      refresh_token: ENV['BASE_REFRESH_TOKEN'] || refresh_token,
      redirect_uri: base_callback_url
    })
    JSON.parse(response_body)
  end

  def self.profile
    request = Typhoeus.get(base_api_url('users/me'), headers: auth_header)
    # @base_profile = JSON.parse(request.response_body)
    JSON.parse(request.response_body)
  end

  def self.items
    request = Typhoeus.get(base_api_url('items'), headers: auth_header, params: {
      order: 'modified', # list_order / created / modified
      sort: 'desc', # asc / desc
    })
    JSON.parse(request.response_body)
  end

  def self.orders
    request = Typhoeus.get(base_api_url('orders'), headers: auth_header)
    JSON.parse(request.response_body)
  end

  def self.base_api_domain
    'https://api.thebase.in/1/'
  end

  def self.base_api_url(api_key)
    "#{base_api_domain}#{api_key}"
  end

  def self.base_callback_url
    #'https%3A%2F%2Fowners-dev.herokuapp.com%2Fauth%2Fcallback%2Fbase'
    'https://owners-dev.herokuapp.com/auth/callback/base'
  end

  def self.auth_header
    {Authorization: "Bearer #{session[:base_access_token]}"}
  end
end
