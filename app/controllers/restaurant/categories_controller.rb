class Restaurant::CategoriesController < ApplicationController
  before_action :load_restaurant, only: [:index, :new, :create]

  def index
    @categories = Category.where(restaurant_id: @restaurant.id)
  end

  def new
    @category = Category.new(restaurant_id: params[:restaurant_id])
  end

  def create
    @category = @restaurant.categories.new(category_params)
    if @category.save
      flash[:message] = "You've create the #{@category.name} category"
      redirect_to restaurant_categories_path(@restaurant)
    else
      flash[:errors] = @category.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end

  def category_params
    params.require(:category).permit(:name, :restaurant_id)
  end
end

