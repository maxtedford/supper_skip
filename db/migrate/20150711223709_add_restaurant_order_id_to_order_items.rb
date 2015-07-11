class AddRestaurantOrderIdToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :restaurant_order, index: true
  end
end
