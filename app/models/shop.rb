class Shop < ApplicationRecord
  has_many :shop_users
  has_many :users, through: :shop_users

  def base_access_token_expired?
    base_access_token_expires_at < Time.zone.now
  end

  def base_refresh_token_expired?
    base_refresh_token_expires_at < Time.zone.now
  end

  def latest_access_token
    if base_access_token_expired?
      tokens = Base::Api.auth_with_refresh_token(base_refresh_token)
      update(tokens)
    end
    base_access_token
  end
end
