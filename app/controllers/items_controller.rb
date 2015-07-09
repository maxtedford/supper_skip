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
    @item = Item.new(item_params)
    if @item.save
      redirect_to restaurant_item_path(@items)
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :image, :retired, category_ids: [])
  end
end
