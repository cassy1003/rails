class Base::Api
  class << self
    def auth_url
      if Rails.env.development?
        '/auth/callback/base'
      else
        "#{base_api_url('oauth/authorize')}?response_type=code&client_id=#{ENV['BASE_CLIENT_ID']}&redirect_uri=#{base_callback_url}&scope=read_users%20read_items%20read_orders"
      end
    end

    def auth_with_code(code)
      request = Typhoeus.post(base_api_url('oauth/token'), params: {
        grant_type: 'authorization_code',
        client_id: ENV['BASE_CLIENT_ID'],
        client_secret: ENV['BASE_CLIENT_SECRET'],
        code: code,
        redirect_uri: base_callback_url
      })
      res = JSON.parse(request.response_body)

      {
        base_access_token: res['access_token'],
        base_access_token_expires_at: 1.hour.since,
        base_refresh_token: res['refresh_token'],
        base_refresh_token_expires_at: 30.days.since
      }
    end

    def auth_with_refresh_token(refresh_token)
      request = Typhoeus.post(base_api_url('oauth/token'), params: {
        grant_type: 'refresh_token',
        client_id: ENV['BASE_CLIENT_ID'],
        client_secret: ENV['BASE_CLIENT_SECRET'],
        refresh_token: ENV['BASE_REFRESH_TOKEN'] || refresh_token,
        redirect_uri: base_callback_url
      })
      res = JSON.parse(request.response_body)

      {
        base_access_token: res['access_token'],
        base_access_token_expires_at: 1.hour.since,
        base_refresh_token: res['refresh_token'],
        base_refresh_token_expires_at: 30.days.since
      }
    end

    def profile(access_token)
      request = Typhoeus.get(base_api_url('users/me'), headers: auth_header(access_token))
      res = JSON.parse(request.response_body)['user']
      {
        base_id: res['shop_id'],
        name: res['shop_name'],
        introduction: res['shop_introduction'],
        url: res['shop_url'],
        logo: res['logo'],
        email: res['mail_address'],
      }
    end

    def items(access_token, order, sort, limit, offset)
      request = Typhoeus.get(base_api_url('items'), headers: auth_header(access_token), params: {
        order: order, # list_order / created / modified
        sort: sort, # asc / desc
        limit: limit,
        offset: offset
      })
      JSON.parse(request.response_body)['items']
    end

    def orders(access_token, start, limit, offset)
      request = Typhoeus.get(base_api_url('orders'), headers: auth_header(access_token), params: {
        start_ordered: start,
        limit: limit,
        offset: offset
      })
      JSON.parse(request.response_body)['orders']
    end

    def order_detail(access_token, order)
      request = Typhoeus.get("#{base_api_url('orders')}/detail/#{order.key}", headers: auth_header(access_token))
      JSON.parse(request.response_body)['order']
    end

    private

    def base_api_domain
      'https://api.thebase.in/1/'
    end

    def base_api_url(api_key)
      "#{base_api_domain}#{api_key}"
    end

    def base_callback_url
      #'https%3A%2F%2Fowners-dev.herokuapp.com%2Fauth%2Fcallback%2Fbase'
      'https://owners-dev.herokuapp.com/auth/callback/base'
    end

    def auth_header(access_token)
      {Authorization: "Bearer #{access_token}"}
    end
  end
end
