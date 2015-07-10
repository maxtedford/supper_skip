class ItemsController < ApplicationController
  before_action :load_restaurant, only: [:new, :create]
  def show
    @item = Item.find(params[:id])
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
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :image, :retired, :restaurant_id, category_ids: [])
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end
end
