class Restaurant < ActiveRecord::Base
  before_create :sanitize_slug

  def to_param
    slug
  end

  def sanitize_slug
    self.slug = slug.parameterize
  end
end
