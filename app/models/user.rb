class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  enum role: { admin: 1, member: 2, staff: 3 }

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
