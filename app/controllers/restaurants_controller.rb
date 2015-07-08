class RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
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
end

