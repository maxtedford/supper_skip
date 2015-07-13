class UserRolesController < ApplicationController
  
  def new
    @user_role = UserRole.new
    @roles = Role.all.uniq
  end
  
  def create
    
  end
end
