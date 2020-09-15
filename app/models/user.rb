class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :shop_users
  has_many :shops, through: :shop_users
  belongs_to :approved_by, class_name: 'User'

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  enum role: { admin: 1, member: 2, staff: 3 }
  enum status: {
    waiting: 1,
    approved: 2,
    invited: 3,
    stop: 4,
    deleted: 5
  }

  def system_admin?
    type == 'SystemAdmin'
  end

  def owner?
    type == 'Owner'
  end

  def staff?
    type == 'Staff'
  end
end
