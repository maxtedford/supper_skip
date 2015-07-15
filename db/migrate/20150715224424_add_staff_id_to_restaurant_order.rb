class AddStaffIdToRestaurantOrder < ActiveRecord::Migration
  def change
    add_column :restaurant_orders, :staff_id, :integer
  end
end
