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

  scenario 'User attempts log in with invalid creditentials', focus: true do
    @user.password = "not_correct"
    login(@user)
    expect(page).to have_content "Invalid email or password."
  end

  scenario 'User logs in with valid creditentials', focus: true do
    login(@user)
    expect(page).to have_content "Hello #{@user.name}!"
  end

  scenario 'User log out', focus: true do
    login(@user)
    logout
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Sign In"
  end

  scenario 'Users are redirected to Edit User page at login', focus: true do
    login(@user)
    visit edit_user_registration_path
    expect(current_path).to eq(edit_user_registration_path)
    expect(page).to have_content "Edit User"
  end

end
