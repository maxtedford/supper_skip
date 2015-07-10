class Restaurant::ItemsController < ApplicationController
  before_action :load_restaurant
  def show
    @item = @restaurant.items.find(params[:id])
  end

  def index
    @items      = Item.all
    @categories = Category.all
  end

  def new
    @item = Item.new(restaurant_id: params[:restaurant_id])
  end

  def create
    @item = @restaurant.items.new(item_params)
    if @item.save
      redirect_to restauraunt_path(@restaurant)
    else
      render :new
    end
  end

  def edit
    @item = @restaurant.items.find(params[:id])
  end

  def update
    @item = @restaurant.items.find(params[:id])
    if @item.update(item_params)
      redirect_to restaurant_path(@restaurant)
      flash[:notice] = "#{@item.title} has been updated"
    else
      render :edit
      flash.now[:errors] = @item.errors.full_messages.join(", ")
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to restaurant_path(@restaurant)
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :image, :retired, :restaurant_id, category_ids: [])
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end
end

