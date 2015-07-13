require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'non-loggedin user' do
    let(:category) { (Category.create(name: "dessert")) }
    let(:category2) { (Category.create(name: "entree")) }
    before(:each) do
      @restaurant = Restaurant.create(name: "some rest",
                                      description: "some desc")
      Item.create(title: "cheesecake",
                  description: "description",
                  price: 10,
                  categories: [category],
                  restaurant_id: @restaurant.id)

      Item.create(title: "burger",
                  description: "description1",
                  price: 50,
                  categories: [category2],
                  restaurant_id: @restaurant.id)

      visit restaurant_path(@restaurant)
    end

    it "can organize items by cateories" do
      within('#category1') do
        expect(page).to have_content("dessert")
        expect(page).to have_content("cheesecake")
      end

      within('#category2') do
        expect(page).to have_content("entree")
        expect(page).to have_content("burger")
      end
    end
  end
end
