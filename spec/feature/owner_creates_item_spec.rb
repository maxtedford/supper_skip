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
      restaurant = Restaurant.new(name: "resto1234",
                                  description: "descripto1234")
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

    xit "actually creates the item" do
      click_link("Create Item")
      fill_in "Title", with: "some item"
      fill_in "Description", with: "some desc"
      fill_in "Price", with: 9.99
      check_box "item_category_ids_1"
    end
  end
end

