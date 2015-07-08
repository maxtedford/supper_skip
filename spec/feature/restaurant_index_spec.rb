require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'user looking at home page' do
      before(:each) do
      restaurant1_data = { name: "some rest",
                           description: "some desc" }
      restaurant2_data = { name: "other rest",
                           description: "other desc" }
      restaurant1 = Restaurant.create(restaurant1_data)
      restaurant2 = Restaurant.create(restaurant2_data)
      end

    it 'shows all restaurants on the homepage' do
      visit root_path

      expect(page).to have_content("some rest")
      expect(page).to have_content("some desc")
      expect(page).to have_content("other rest")
      expect(page).to have_content("other desc")
    end
  end
end
