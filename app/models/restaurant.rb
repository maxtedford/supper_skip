class Restaurant < ActiveRecord::Base
  before_create :check_slug
  before_create :sanitize_slug
  validates_presence_of :name, :description
  validates_uniqueness_of :name, :slug

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
