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

      role = Role.create(name: "owner")

      restaurant = Restaurant.create!(name: "bob's big food shack",
                                      description: "descripto1234")

      user.user_roles.create(role: role, restaurant: restaurant)

      category = Category.create!(name: "entrees")

      item = restaurant.items.create!(title: "burger",
                                      description: "juicy",
                                      price: 6,
                                      categories: [ category ])

      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button "Login!"
    end

    it "owner edits item test" do
      item = Item.find_by(title: "burger")
      restaurant = Restaurant.find_by(name: "bob's big food shack")

      visit restaurant_item_path(restaurant, item)

      expect(page).to have_button("Edit")

      click_button "Edit"
      fill_in "Title", with: "sandwich"
      click_on "Update"

      expect(current_path).to eq(restaurant_path(restaurant))
      expect(page).to have_content("sandwich")
      expect(page).to_not have_content("burger")
    end
  end
end
