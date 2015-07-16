require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged in as an owner' do
    before(:each) do
      user_data = { name: "Viki",
                    email_address: "viki@example.com",
                    password: "password",
                    password_confirmation: "password" }
      user = User.create(user_data)
      user_role = Role.create(name: "owner")
      category = Category.create(name: "Entree")
      restaurant = Restaurant.new(name: "resto1234",
                                  description: "descripto1234",
                                  categories: [category])
      user.user_roles.create(role: user_role, restaurant: restaurant)

      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button "Login!"

      visit restaurant_path(restaurant)
    end

    it 'has a create button' do
      expect(page).to have_content("Create Item")
    end

    it "actually creates the item" do
      click_link("Create Item")
      fill_in "Title", with: "some item"
      fill_in "Description", with: "some desc"
      fill_in "Price", with: 9.99
      check("item[category_ids][]")
      click_on("Create Item")
      
      expect(page).to have_content("some item")
      expect(page).to have_content("some desc")
      expect(page).to have_link("Add to Cart")
    end
  end
end

