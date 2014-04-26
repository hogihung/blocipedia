require 'spec_helper'

feature 'User creates a public wiki', %q{
  As a registered user of the site
  When I am logged in
  I can create public wikis
} do

  background do
    @user = create(:user)
    @wiki = create(:wiki)
  end

  scenario 'User is logged in, can create a public wiki', focus: true do
    login(@user)
    visit wikis_path
    click_link "New Wiki"
    fill_in "Title", with: "My Wiki Title"
    fill_in "Body",  with: "This is the body text"
    click_button "Save"
    expect(@wiki.private?).to be_false
  end

  scenario 'User is not logged in, should not be able to create a public wiki', focus: true do
    visit wikis_path
    click_link "New Wiki"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end


feature 'User edits a public wiki', %q{
  As a registered user of the site
  When I am logged in
  I can edit public wikis
} do

  background do
    @user = create(:user)
    @wiki = create(:wiki)
  end

  scenario 'User is logged in, can edit a public wiki', focus: true do
    login(@user)
    @wiki.private = false
    visit wikis_path
    click_link "Edit"
  end

  scenario 'User is not logged in, should not be able to edit a public wiki', focus: true do
    @wiki.private = false
    visit wikis_path
    expect(page).to_not have_content "Edit"
  end
end


feature 'User creates a private wiki', %q{
  As a premium user of the site
  When I am logged in
  I can create private wikis
} do

  background do
    @user = create(:user)
    @wiki = create(:wiki)
    @wiki.private = true
  end

  scenario 'User is creating a private wiki' do
    login(@user)
    visit wikis_path
    click_link "New Wiki"
    fill_in "Title", with: "My Wiki Title"
    fill_in "Body",  with: "This is the body text"
    click_button "Save"
    expect(@wiki.private?).to be_true
  end

  scenario 'User is not logged in, should not be able to create a private wiki' do
    logout(@user)
    visit wikis_path
    click_link "New Wiki"
    expect(page).to have_content "Must be logged in."
  end
end


feature 'User edits a private wiki', %q{
  As a premium user of the site
  When I am logged in
  I can edit private wikis
} do

  background do
    @user = create(:user)
    @wiki = create(:wiki)
    @wiki.private = true
  end

  scenario 'User is logged in as a premium user, edits a private wiki' do
    login(@user)
    @wiki.private = true
  end

  scenario 'User is logged in, but is not a premium user, should not be able to edit a private wiki' do
    login(@user)
    @wiki.private = false
  end

  scenario 'User is not logged in, should not be able to edit a private wiki' do
    #...
  end
end
