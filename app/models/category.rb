class Category < ActiveRecord::Base
  validates :name, presence: true
  has_many :item_categories
  has_many :items, through: :item_categories
  belongs_to :restaurant
end
