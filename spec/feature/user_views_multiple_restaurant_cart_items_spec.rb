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
      category = @restaurant.categories.create(name: "food")
      category2 = @restaurant2.categories.create(name: "food")

      @item = @restaurant.items.create(title: "some menu item",
                                       description: "delicious",
                                       price: 10,
                                       categories: [category])
      @item2 = @restaurant2.items.create(title: "jimmybuger",
                                         description: "juicy",
                                         price: 10,
                                         categories: [category2])
      user.user_roles.create(role: user_role, restaurant: @restaurant)
      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button "Login!"
    end

    it "*will show the restaurant on the root page" do
      expect(page).to have_content("#{@restaurant.name}")
      expect(page).to have_content("#{@restaurant2.name}")
    end

    it "*will show each restaurant's menu items on their show pages" do
      click_on("#{@restaurant.name}")

      expect(page).to have_content("#{@item.title}")

      visit root_path
      click_on("#{@restaurant2.name}")

      expect(page).to have_content("#{@item2.title}")
    end

    it "*can add one restaurant item to the cart" do
      click_on("#{@restaurant.name}")
      click_on("Add to Cart")

      expect(page).to have_content("You have 1 #{@item.title} in your cart.")

      visit cart_items_path

      expect(page).to have_content("#{@item.title}")
      within(".cart_item_#{@item.id} .quantity") do
        expect(page).to have_content("1")
      end
    end

    it "*can add more than one restaurant item to the cart" do
      click_on(@restaurant.name)
      click_on("Add to Cart")

      expect(page).to have_content("You have 1 #{@item.title} in your cart.")

      visit root_path
      click_on(@restaurant2.name)
      click_on("Add to Cart")

      visit cart_items_path

      expect(page).to have_content(@restaurant.name)
      expect(page).to have_content(@item.title)
      expect(page).to have_content(@restaurant2.name)
      expect(page).to have_content(@item2.title)
      within(".cart_item_#{@item.id} .quantity") do
        expect(page).to have_content("1")
      end
      within(".cart_item_#{@item2.id} .quantity") do
        expect(page).to have_content("1")
      end
    end
  end
end

