class Restaurant::CategoriesController < ApplicationController
  before_action :load_restaurant, only: [:index, :new, :create, :destroy, :edit, :update]
  before_action :load_category, only: [:destroy, :edit, :update]

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

  def destroy
    @category.destroy
    redirect_to restaurant_categories_path(@restaurant)
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:message] = "You've updated a category"
      redirect_to restaurant_categories_path(@restaurant)
    else
      flash[:error] = @category.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end

  def category_params
    params.require(:category).permit(:name, :restaurant_id)
  end

  def load_category
    @category = Category.find(params[:id])
  end
end

