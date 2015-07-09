class Permission < ActiveRecord::Base
  def initialize(user)
    @user = user
  end

  def can_edit_restaurant?(restaurant)
    @user.verify?("owner", restaurant)
  end
end
