class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
  end

  def index
    @items      = Item.all
    @categories = Category.all
  end

  def new
    @item = Item.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id].to_i)
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
end
