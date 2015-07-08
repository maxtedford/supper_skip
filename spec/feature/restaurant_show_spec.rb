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

    it 'has an edit button' do
      visit restaurant_path(@restaurant1)
      
      expect(page).to have_content("Edit")
    end
    
    it 'actually edits restaurant' do
      visit edit_restaurant_path(@restaurant)
      
      expect(find_field("some rest").value).to eq("some rest")
      expect(find_field("some desc").value).to eq("some desc")
      
      fill_in "some rest", with: "new rest"
      fill_in "some desc", with: "new desc"
      fill_in "some-rest", with: "new-slug"
      click_on "Update"
      
      expect(current_path).to eq("/restaurants/new-slug")
      expect(page).to have_content("new rest")
      expect(page).to have_content("new desc")
    end
  end
end
