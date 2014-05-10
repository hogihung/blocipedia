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
      expect(page).to have_content("A Premium Membership Subscription")
      fill_in "email", with: "joesmoe@email.com"
      fill_in "card_number", with: "4012 8888 8888 1881"
      fill_in "cc-exp", with: "0614"
      fill_in "cc-csc", with: "123"
      click_button("Subscribe $49.00")
    end

    sleep 1 #iframe wait
    expect(page).to have_content "Sign up for Premium account successfull."
  end

  # Need the factory to setup a subscription for us before testing ***
  # Had issue getting factory to create subscription, so created the
  # subscription below after login(premium_user)
  scenario "A logged in premium user should not be able to upgrade" do
    login(premium_user)
    Subscription.create!(user: premium_user, stripe_cart_token: "hubba-bubba")
    click_link premium_user.name

    expect(page).to_not have_link("Upgrade")
  end
end


feature "Visiting user cannot upgrade a subscription" do

  scenario "A visiting user should not be able to upgrade another users subscription." do
    visit "http://localhost:3000/users/1/subscription/new"
    expect(page).to have_content("You are not authorized to perform this action.")
  end
end