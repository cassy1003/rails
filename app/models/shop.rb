class Shop < ApplicationRecord
  has_many :shop_users
  has_many :users, through: :shop_users

  def base_access_token_expired?
    base_access_token_expires_at < Time.zone.now
  end
end
