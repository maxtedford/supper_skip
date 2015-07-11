require 'rails_helper'

RSpec.describe RestaurantOrder, :type => :model do

  it "responds to restaurant orders" do
    restaurant = Restaurant.create!(name: "Max's Diner",
      description: "Super fun time")

    expect(restaurant).to respond_to(:restaurant_orders)
  end
end
