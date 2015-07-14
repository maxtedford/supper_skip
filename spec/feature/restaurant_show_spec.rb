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
      category2 = @restaurant1.categories.create(name: "bitchin")
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
      user = User.create!(name: "jamie", email_address: "jamie@jamie.com", password: "password", password_confirmation: "password")
      user.roles.create(name: "owner")
      rest = Restaurant.create(name: "diner",
                               description: "american")
      cat = rest.categories.create(name: "dessert")
      item = Item.create(title: "cake",
                         description: "chocolate",
                         price: 10,
                         categories: [cat],
                         restaurant_id: rest.id)

      visit restaurant_path(rest)
      expect(page).to have_content("cake")
      expect(page).to have_content("chocolate")
    end

    it 'shows items for given restaurant' do
      user = User.create!(name: "jamie", email_address: "jamie@jamie.com", password: "password", password_confirmation: "password")
      user.roles.create(name: "owner")

      rest = Restaurant.create(name: "diner",
                               description: "american")
      cat = rest.categories.create(name: "dessert")
      item = Item.create(title: "cake",
                         description: "description",
                         price: 10,
                         categories: [cat],
                         restaurant_id: rest.id)

      visit restaurant_path(rest)
      expect(page).to have_content("diner")
      expect(page).to have_content("dessert")
      expect(page).to have_content("cake")
      expect(page).not_to have_content("name")
    end

    it 'shows items for given restaurant' do
      user = User.create!(name: "jamie", email_address: "jamie@jamie.com", password: "password", password_confirmation: "password")
      user.roles.create(name: "owner")

      rest = Restaurant.create(name: "cafeteria",
                               description: "american")
      cat = rest.categories.create(name: "lunch")
      item = Item.create(title: "sandwich",
                         description: "description",
                         price: 10,
                         categories: [cat],
                         restaurant_id: rest.id)

      visit restaurant_path(rest)
      expect(page).to have_content("cafeteria")
      expect(page).to have_content("lunch")
      expect(page).to have_content("sandwich")
      expect(page).not_to have_content("name")

      visit restaurant_path(@restaurant1)

      expect(page).to have_content("other rest")
      expect(page).to have_content("other desc")
      expect(page).not_to have_content("title")
      expect(page).to have_content("bitchin")
    end

    it 'has an edit button' do
      visit restaurant_path(@restaurant1)

      expect(page).not_to have_content("Edit")
    end

    it 'actually edits restaurant' do
      visit edit_restaurant_path(@restaurant)

      expect(page).not_to have_content("some rest")
      expect(page).not_to have_content("some desc")
    end
  end
end
