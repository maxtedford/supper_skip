class AddRestaurantOrdersToOrders < ActiveRecord::Migration
  def change
    add_reference :restaurant_orders, :order, index: true
  end
end
