require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged in' do
    before(:each) do
      user_data = { name: "Viki",
                    email_address: "viki@example.com",
                    password: "password",
                    password_confirmation: "password" }
      user = User.create(user_data)
      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button "Login!"
    end

    it 'displays a button for registering a new restaurant' do
      within("nav") do
        expect(page).to have_content("Register Restaurant"), "There's no button"
      end
    end

    it 'actually registers restaurants' do
      click_on("Register Restaurant")
      fill_in "Name", with: "Name"
      fill_in "Description", with: "Desc"
      fill_in "Slug", with: "Slug"
      click_button "Register"

      expect(Restaurant.last.name).to eq("Name")
      expect(Restaurant.last.slug).to eq("slug")

      expect(page.status_code).to eq(200)
      expect(current_path).to eq("/restaurants/slug")
      expect(page).to have_content("Name")
      expect(page).to have_content("Desc")

    end
  end
end
