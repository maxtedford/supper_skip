class Restaurant < ActiveRecord::Base
  before_create :check_slug
  before_create :sanitize_slug
  validates_presence_of :name, :description
  validates_uniqueness_of :name, :slug
  has_many :items
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :restaurant_orders
  has_many :order_items, through: :restaurant_orders
  has_many :categories

  def to_param
    slug
  end

  def sanitize_slug
    self.slug = slug.parameterize
  end

  def check_slug
    slug.blank? ? self.slug = name.parameterize : slug
  end

  def owner
    if  user_roles.find_by(role_id: Role.find_by(name: "owner").id)
    owner_id = user_roles.find_by(role_id: Role.find_by(name: "owner").id).user_id
    User.find(owner_id).name
    end
  end
end
