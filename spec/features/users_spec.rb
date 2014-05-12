require 'spec_helper'

feature 'User Authentication', %q{
  As the user of the site
  I want to be able to login
  And edit my user attributes
  To use the tools of the site
  And be able to log out
} do

  background do
    @user = create(:user)
  end

  scenario 'User attempts log in with invalid creditentials' do
    @user.password = "not_correct"
    login(@user)
    expect(page).to have_content "Invalid email or password."
  end

  scenario 'User logs in with valid creditentials' do
    login(@user)
    expect(page).to have_content "Hello #{@user.name}!"
  end

  scenario 'User log out' do
    login(@user)
    logout
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Sign In"
  end

  scenario 'Users are redirected to Edit User page at login' do
    login(@user)
    visit edit_user_registration_path
    expect(current_path).to eq(edit_user_registration_path)
    expect(page).to have_content "Edit User"
  end

end

feature 'Premium User Account', %q{
  As a registered user of the site
  With a current Premium Account
  I should have an attribute of premium as true
} do

  background do
    @user = create(:user)
  end

  scenario 'User has a premium account' do
    @user.role = "premium"
    expect(@user.premium?).to be_true
  end

  scenario 'User does not have a premium account' do
    expect(@user.premium?).to be_false
  end

end