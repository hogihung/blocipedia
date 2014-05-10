require 'spec_helper'

feature "User upgrades to premium subscription" do
  after(:each) do
    puts page.body if example.exception
  end

  given(:user) { FactoryGirl.create(:user)}
  given(:premium_user) { FactoryGirl.create(:user, :premium) }

  scenario "A logged in member user should be able to upgrade", :js do
    login(user)
    click_link user.name

    expect(page).to have_link("Upgrade")
    click_link("Upgrade")

    expect(page).to have_button("Subscribe")
    click_button("Subscribe")

    stripe = page.driver.window_handles.last
    page.within_window stripe do
      expect(page).to have_content("A month's subscription")
      fill_in "email", with: "joesmoe@email.com"
      fill_in "card_number", with: "4012 8888 8888 1881"
      fill_in "cc-exp", with: "0614"
      fill_in "cc-csc", with: "123"
      click_button("Subscribe $9.00")
    end

    sleep 1 #iframe wait
    expect(page).to have_content "Sign up for Premium account successfull."

    expect(page).to have_link("Cancel Subscription")
  end

  scenario "A visiting user should not be able to upgrade another users subscription." do
    visit "http://localhost:3000/users/1/subscription/new"
    expect(page).to have_content("You are not authorized to perform this action.")
  end
end


feature "User cancels premium subscription" do

  pending "Previous test(s) pass." do
    #...
  end

  scenario "A visiting user should not be able to cancel another user subscription." do
    visit "http://localhost:3000/users/1/subscription/"
    #how do I simulate a destroy via url here? Is it applicable?
    expect(page).to have_content("You are not authorized to perform this action.")
  end

end