class ShopUser < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  enum role: { admin: 1, member: 2, staff: 3 }
end
