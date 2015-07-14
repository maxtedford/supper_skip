class UserRolesController < ApplicationController
  
  def new
    @user_role = UserRole.new
    @roles = Role.all.uniq
  end
  
  def create
    @user = User.find_by(email_address: params[:user_role][:user_id])
    if @user.nil?
      byebug
      @user = User.create(name: "New User", email_address: user_role_params[:user_id], password: "#{SecureRandom.urlsafe_base64}")
      params[:user_role][:user_id] = @user.id.to_s
      @user_role = UserRole.new(user_role_params)
      if @user_role.save
        flash[:message] = "You have successfully added #{@user.name} as '#{@user.user_roles.map(&:role).last.name}'"
        redirect_to restaurant_path(@user_role.restaurant)
        NotificationMailer.user_signup(@user).deliver
      else
        flash.now[:errors] = @user_role.errors.full_messages.join(", ")
        render :new
      end
    else
      params[:user_role][:user_id] = @user.id.to_s
      @user_role = UserRole.new(user_role_params)
      if @user_role.save
        flash[:message] = "You have successfully added #{@user.name} as '#{@user.user_roles.map(&:role).last.name}'"
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

