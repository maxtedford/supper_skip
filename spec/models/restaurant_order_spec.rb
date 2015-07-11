require 'rails_helper'

RSpec.describe RestaurantOrder, :type => :model do
  
  it "responds to restaurant" do
    restaurant = Restaurant.create!(name: "Max's Diner",
      description: "Super fun time")
    restaurant_order = RestaurantOrder.create(restaurant_id: restaurant.id)
    
    expect(restaurant_order).to respond_to(:restaurant)
  end
end
