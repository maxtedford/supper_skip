class AddStatusToRestaurantOrder < ActiveRecord::Migration
  def change
    add_column :restaurant_orders, :status, :string
  end
end
