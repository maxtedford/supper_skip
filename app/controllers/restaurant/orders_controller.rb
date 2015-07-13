class Restaurant::OrdersController < ApplicationController
  before_action :load_restaurant

  def index
    @restaurant_orders = RestaurantOrder.where(restaurant_id: @restaurant.id)
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find_by(slug: params[:restaurant_id])
  end
end

