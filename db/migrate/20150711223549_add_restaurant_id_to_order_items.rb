class AddRestaurantIdToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :restaurant, index: true
  end
end
