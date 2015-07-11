class CreateRestaurantOrders < ActiveRecord::Migration
  def change
    create_table :restaurant_orders do |t|
      t.references :restaurant, index: true

      t.timestamps
    end
  end
end
