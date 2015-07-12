require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when browsing as a regular user' do

    before(:each) do
      user_data = { name: "Viki",
        email_address: "viki@example.com",
        password: "password",
        password_confirmation: "password" }
      user = User.create(user_data)
      user_role = Role.create(name: "customer")
      @restaurant = Restaurant.create(name: "resto1234",
        description: "descripto1234")
      @restaurant2 = Restaurant.create(name: "jimmy's",
        description: "yummy food")
      category = Category.create(name: "food")
      @item = @restaurant.items.create(title: "some menu item",
        description: "delicious",
        price: 10,
        categories: [category])
      @item2 = @restaurant2.items.create(title: "jimmybuger",
        description: "juicy",
        price: 10,
        categories: [category])
      user.user_roles.create(role: user_role, restaurant: @restaurant)

      visit root_path
      fill_in "email address", with: "viki@example.com"
      fill_in "password", with: "password"
      click_on "Login!"
    end
    
    it "will display items' restaurants on the order show page" do
      click_on(@restaurant.name)
      click_on("Add to Cart")

      expect(page).to have_content("You have 1 #{@item.title} in your cart.")

      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")

      visit cart_items_path
      click_on "Checkout"
      click_on "Update Order"
      
      expect(page).to have_content(@restaurant.name)
      expect(page).to have_content(@restaurant2.name)
    end
    
    it "will create a restaurant order" do
      click_on(@restaurant.name)
      click_on("Add to Cart")
      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")
      visit cart_items_path
      click_on "Checkout"
      click_on "Update Order"

      expect(RestaurantOrder.all.count).to eq(1)
      expect(RestaurantOrder.items.count).to eq(2)
      expect(RestaurantOrder.items.last.title).to eq("jimmyburger")
    end
  end
end
