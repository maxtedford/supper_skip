require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged in' do
  let(:category) { (Category.create(name: "some category")) }
    before(:each) do
      @restaurant = Restaurant.create(name: "some rest",
                                      description: "some desc")
      @restaurant1 = Restaurant.create(name: "other rest",
                                       description: "other desc")
      Item.create(title: "title",
                  description: "description",
                  price: 10,
                  categories: [category],
                  restaurant_id: @restaurant.id)

      Item.create(title: "name",
                  description: "description1",
                  price: 50,
                  categories: [category],
                  restaurant_id: @restaurant1.id)

      visit restaurant_path(@restaurant)
    end

    it 'creates and visits a restaurant' do
      expect(current_path).to eq("/restaurants/some-rest")
      expect(page).to have_content("some rest")
      expect(page).to have_content("some desc")
    end

    it 'shows items for given restaurant' do
      expect(page).to have_content("some rest")
      expect(page).to have_content("some desc")
      expect(page).to have_content("title")
      expect(page).not_to have_content("name")
    end

    it 'shows items for given restaurant' do
      visit restaurant_path(@restaurant1)
      expect(page).to have_content("other rest")
      expect(page).to have_content("other desc")
      expect(page).not_to have_content("title")
      expect(page).to have_content("name")
    end

  end
end
