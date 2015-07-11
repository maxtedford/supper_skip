class User < ActiveRecord::Base
  has_secure_password
  has_many :orders
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :restaurants, through: :user_roles

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true

  def verify?(role, restaurant)
    role = Role.find_by(name: role)
    user_roles.where(restaurant_id: restaurant.id, role_id: role.id ).any?
  end
end
