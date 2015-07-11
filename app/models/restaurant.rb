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

  def to_param
    slug
  end

  def sanitize_slug
    self.slug = slug.parameterize
  end

  def check_slug
    slug.blank? ? self.slug = name.parameterize : slug
  end
end
