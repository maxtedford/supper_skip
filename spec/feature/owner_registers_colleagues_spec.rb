require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged in as an owner' do
    
    before(:each) do
      owner_data = { name: "Viki",
        email_address: "viki@example.com",
        password: "password",
        password_confirmation: "password" }
      owner = User.create(owner_data)
      owner_role = Role.create(name: "owner")
      cook_role = Role.create(name: "cook")
      delivery_role = Role.create(name: "delivery")
      restaurant = Restaurant.new(name: "Owner's Resto",
                                  description: "So ownery")
      owner.user_roles.create(role: owner_role, restaurant: restaurant)

      visit root_path
      fill_in "email_address", with: owner.email_address
      fill_in "password", with: owner.password
      click_button "Login!"
      visit restaurant_path(restaurant)
    end
    
    it "has a link to add a new user to the restaurant" do
      expect(page).to have_link("Add User")
    end
    
    it "shows the owner a form to fill in the new user's information" do
      click_link "Add User"
      
      expect(page).to have_content("Email address")
      expect(page).to have_content("User role")
    end
  end
end
