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
      @item = @restaurant.items.create(title: "some-menu-item",
        description: "delicious",
        price: 10,
        categories: [category])
      @item2 = @restaurant2.items.create(title: "jimmyburger",
        description: "juicy",
        price: 10,
        categories: [category])
      @item3 = @restaurant.items.create(title: "third-item",
        description: "tasty",
        price: 5,
        categories: [category])
      user.user_roles.create(role: user_role, restaurant: @restaurant)

      visit root_path
      fill_in "email address", with: "viki@example.com"
      fill_in "password", with: "password"
      click_on "Login!"
    end

    it "will display items' restaurants on the order show page" do
      click_on(@restaurant.name)
      within(".some-menu-item") do
        click_on("Add to Cart")
      end

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
      within(".some-menu-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")

      expect(RestaurantOrder.last.restaurant_id).to eq(@restaurant2.id)
      expect(RestaurantOrder.find_by(restaurant_id: @restaurant2.id).items.count).to eq(1)
      expect(RestaurantOrder.find_by(restaurant_id: @restaurant2.id).items.last.title).to eq("jimmyburger")
    end

    it "will display a restaurant total on cart show page" do
      click_on(@restaurant.name)
      within(".some-menu-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant.name)
      within(".third-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")
      visit cart_items_path

      expect(page).to have_content "Restaurant Subtotal"
      expect(page).to have_content "$15"
    end
    
    it "will display a restaurant grand total on cart show page" do
      click_on(@restaurant.name)
      within(".some-menu-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant.name)
      within(".third-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")
      visit cart_items_path
      
      expect(page).to have_content("Grand Total: $25")
    end
    
    it "will display the names of both restaurants on the cart show page" do
      visit root_path
      click_on(@restaurant.name)
      within(".third-item") do
        click_on("Add to Cart")
      end
      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")
      visit cart_items_path
      
      expect(page).to have_content("resto1234")
      expect(page).to have_content("jimmy's")
    end
  end
end
