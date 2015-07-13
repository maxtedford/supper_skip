class AddStatusToRestaurantOrder < ActiveRecord::Migration
  def change
    add_column :restaurant_orders, :status, :integer, default: 0
  end
end
