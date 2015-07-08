require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged in' do
    before(:each) do
      @restaurant = Restaurant.create(name: "some rest",
                                      description: "some desc")
      visit @restaurant
    end

    it 'creates and visits a restaurant' do
      expect(current_url).to eq("/restaurants/some-rest")
      expect(page).to have_content("some rest")
      expect(page).to have_content("some desc")
    end
  end
end
