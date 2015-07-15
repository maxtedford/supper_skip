require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'non-loggedin user' do
    before(:each) do
      user = User.create!(name: "jamie", email_address: "jamie@jamie.com", password: "password", password_confirmation: "password")
      role = Role.create!(name: "owner")
      @restaurant = Restaurant.create!(name: "some rest",
                                      description: "some desc")
      user.user_roles.create!(role: role, restaurant: @restaurant)
      category = @restaurant.categories.create(name: "dinner")
      category2 = @restaurant.categories.create(name: "lunch")
      Item.create(title: "cheesecake",
                  description: "description",
                  price: 10,
                  categories: [category2],
                  restaurant_id: @restaurant.id)

      Item.create(title: "burger",
                  description: "description1",
                  price: 50,
                  categories: [category],
                  restaurant_id: @restaurant.id)

      visit restaurant_path(@restaurant)
    end

    it "can organize items by cateories" do
      within('#categorylunch') do
        expect(page).to have_content("lunch")
        expect(page).to have_content("cheesecake")
      end
    end

    it "can filter items by categories" do
      click_on "lunch"

      expect(page).to have_content("cheesecake")
      expect(page).to_not have_content("burger")
    end
  end
end
