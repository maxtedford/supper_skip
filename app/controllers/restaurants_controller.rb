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

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end
end

