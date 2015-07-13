class Restaurant::OrdersController < ApplicationController
  before_action :load_restaurant
  before_action :load_restaurant_order, only: [:edit]

  def index
    @restaurant_orders = RestaurantOrder.where(restaurant_id: @restaurant.id)
  end

  def edit
    if @restaurant_order.update_status(valid_params)
      redirect_to restaurant_order_path
    else
      redirect_to restaurant_order_path, alert: "Order status updated"
    end
  end

  private

  def valid_params
    params.require(:restaurant_order).permit(:status, :restaurant_id)
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end

  def load_restaurant_order
     RestaurantOrder.last
  end
end

