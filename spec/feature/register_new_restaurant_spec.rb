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

    it 'shows good errors for non unique name' do
      click_on("Register Restaurant")
      fill_in "Name", with: "Name"
      fill_in "Description", with: "Desc"
      fill_in "Slug", with: "Slug"
      click_button "Register"

      click_on("Register Restaurant")
      fill_in "Name", with: "Name"
      fill_in "Description", with: "some random shit"
      fill_in "Slug", with: "my screen name"
      click_button "Register"

      within(".notice") do
        expect(page).to have_content("Name has already been taken")
      end
    end

    it 'shows good errors for non unique name' do
      click_on("Register Restaurant")
      fill_in "Name", with: "rando"
      fill_in "Description", with: "Desc"
      fill_in "Slug", with: "slugger"
      click_button "Register"

      visit root_path

      click_on("Register Restaurant")
      fill_in "Name", with: "12345678909"
      fill_in "Description", with: "some random shit"
      fill_in "Slug", with: "slugger"
      click_button "Register"

      within(".notice") do
        expect(page).to have_content("Slug has already been taken")
      end
    end

    it 'defaults to parameterized name if no slug is given' do
      click_on("Register Restaurant")
      fill_in "Name", with: "Name"
      fill_in "Description", with: "Desc"
      click_button "Register"

      expect(current_path).to eq("/restaurants/name")
      expect(Restaurant.last.to_param).to eq("name")
    end
  end
end
