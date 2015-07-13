require 'rails_helper'

context 'restaurant owner', type: :feature do
  let(:restaurant) { Restaurant.create(name: "levs great resto",
                                                   description: "good eats") }
  before(:each) do
    lev = User.create(name: "Lev",
                      email_address: "lev@dev.com",
                      password: "password")
    user_role = Role.create(name: "owner")
    lev.user_roles.create(role: user_role, restaurant: restaurant)
    visit root_path
    fill_in 'email_address', with: lev.email_address
    fill_in 'password', with: lev.password
    click_button 'Login!'
  end

  it 'lets restaurant owners go to a category creation form' do
    visit restaurant_path(restaurant)
    click_link 'Categories'
    expect(current_path).to eq(restaurant_categories_path(restaurant))

    click_button('Add Category')
    expect(current_path).to eq(new_restaurant_category_path(restaurant))

    fill_in 'Name', with: 'my category'
    click_button 'Create Category'
    expect(current_path).to eq(restaurant_categories_path(restaurant))
    expect(restaurant.categories.count).to eq(1)
    expect(restaurant.categories.last.name).to eq('my category')
  end

  it 'only shows the correct categories for a restaurant' do
    visit restaurant_path(restaurant)
    click_link 'Categories'
    click_button('Add Category')
    fill_in 'Name', with: 'my category'
    click_button 'Create Category'

    expect(page).to have_content('my category')
    expect(page).to_not have_content('Burgers')
    expect(page).to_not have_content('Sushi')
  end
end


