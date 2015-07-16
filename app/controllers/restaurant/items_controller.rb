class Restaurant::ItemsController < ApplicationController
  before_action :load_restaurant
  before_action :authorize!, only: [:edit]

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
      flash[:message] = "Item has successfully been created"
      redirect_to restaurant_path(@restaurant)
    else
      flash[:errors] = @item.errors.full_messages.join(", ")
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
    params.require(:item).permit(:title, :description, :price, :image, :retired, :restaurant_id, :prep_time, category_ids: [])
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end

  def authorize!
    unless Permission.new(current_user).can_edit_restaurant?(@restaurant)
      flash[:notice] = "Can't let you do that, #{current_user.name}!"
      redirect_to root_path
    end
  end
end
