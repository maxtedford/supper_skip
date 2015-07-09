class RestaurantsController < ApplicationController
  before_action :require_login, only: [:edit, :create]
  before_action :authorize!, only: [:edit]
  
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      assign_owner
      redirect_to "/restaurants/#{@restaurant.slug.downcase}"
      flash[:message] = "#{@restaurant.name} has been registered"
    else
      flash.now[:errors] = @restaurant.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find_by(slug: params[:id])
  end

  def index
    @restaurants = Restaurant.all
  end
  
  def edit
    @restaurant = Restaurant.find_by(slug: params[:id])
  end
  
  def update
    @restaurant = Restaurant.find_by(slug: params[:id])
    if @restaurant.update(restaurant_params)
      flash[:message] = "You have updated #{@restaurant.name}'s info'"
      redirect_to restaurant_path(@restaurant)
    else
      flash.now[:errors] = @restaurant.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end

  def authorize!
    unless Permission.new(current_user).can_edit_restaurant?(@restaurant)
      flash[:notice] = "Can't let you do that, #{current_user.name}!"
      redirect_to root_path
    end
  end
  
  def assign_owner
    user_role = Role.create(name: "owner")
    current_user.user_roles.create(role: user_role, restaurant: @restaurant)
  end
end

