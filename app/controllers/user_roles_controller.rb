class UserRolesController < ApplicationController
  
  def new
    @user_role = UserRole.new
    @roles = Role.all.uniq
  end
  
  def create
    if User.find_by(email_address: params[:user_role][:user_id])
    @user = User.find_by(email_address: params[:user_role][:user_id])
    params[:user_role][:user_id] = @user.id.to_s
    @user_role = UserRole.new(user_role_params)
      if @user_role.save
        flash[:message] = "You have successfully added #{@user} as a #{@user.role}"
        redirect_to restaurant_path(@user_role.restaurant)
      else
        flash.now[:errors] = @user_role.errors.full_messages.join(", ")
        render :new
      end
    end
  end
  
  private
  
  def user_role_params
    params.require(:user_role).permit(:user_id, :restaurant_id, :role_id)
  end
end
