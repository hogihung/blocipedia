require 'spec_helper'

feature "User upgrades to premium subscription" do
  after(:each) do
    puts page.body if example.exception
  end

  given(:user) { FactoryGirl.create(:user)}
  given(:premium_user) { FactoryGirl.create(:user, :premium) }

  scenario "A logged in member user should be able to upgrade", :focus, :js do
    login(user)
    click_link user.name

    expect(page).to have_link("Upgrade")
    click_link("Upgrade")

    expect(page).to have_button("Pay with Card")
    click_button("Pay with Card")

    stripe = page.driver.window_handles.last
    page.within_window stripe do
      expect(page).to have_content("A month's subscription")
      fill_in "email", with: "joesmoe@email.com"
      fill_in "card_number", with: "4012 8888 8888 1881"
      fill_in "cc-exp", with: "0614"
      fill_in "cc-csc", with: "123"
      click_button("Pay $9.00")
    end

    sleep 1 #iframe wait
    expect(page).to have_content "Sign up for Premium account successfull."

    expect(page).to have_link("Cancel Subscription")
  end
end


feature "User cancels premium subscription" do

  pending "Previous test(s) pass." do
    #...
  end

end