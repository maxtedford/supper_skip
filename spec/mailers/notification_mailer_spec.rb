require "rails_helper"

RSpec.describe NotificationMailer, :type => :feature do
  describe "user_signup" do
    
    let(:mail) { NotificationMailer.user_signup }

    before(:each) do
      owner_data = { name: "Viki",
        email_address: "viki@example.com",
        password: "password",
        password_confirmation: "password" }
      owner = User.create(owner_data)
      owner_role = Role.create(name: "owner")
      cook_role = Role.create(name: "cook")
      restaurant = Restaurant.new(name: "Owner's Resto",
        description: "So ownery")
      owner.user_roles.create(role: owner_role, restaurant: restaurant)

      visit root_path
      fill_in "email_address", with: owner.email_address
      fill_in "password", with: owner.password
      click_button "Login!"
      visit restaurant_path(restaurant)
    end
    
    it "renders the headers" do
      click_link "Add User"
      fill_in "Email Address", with: "max@example.com"
      select "cook", :from => "user_role[role_id]"
      click_button "Register"
      
      result = ActionMailer::Base.deliveries.last

      expect(result)
      expect(result.from).to include "from@example.com"
      expect(result.to).to include "max@example.com"
      expect(result.subject).to eq("Please register with Crossroads Lodge!")
    end
  end
end
