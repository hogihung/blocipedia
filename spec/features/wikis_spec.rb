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

  scenario 'User is logged in, can create a public wiki' do
    login(@user)
    visit wikis_path
    click_link "New Wiki"
    fill_in "Title", with: "My Wiki Title"
    fill_in "Body",  with: "This is the body text"
    click_button "Save"
    expect(@wiki.private?).to be_false
  end

  scenario 'User is not logged in, should not be able to create a public wiki'  do
    visit wikis_path
    expect(page).not_to have_link "New Wiki"
    visit new_wiki_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end


feature 'User edits a public wiki', %q{
  As a registered user of the site
  When I am logged in
  I can edit public wikis
} do
  let(:user) { FactoryGirl.create(:user, :with_post) }

  background do
    user
  end

  after(:each) do
    if example.exception
      puts page.body

    end
  end

  scenario 'User is logged in, can edit a public wiki' do
    login(user)
    expect(page).to have_content "Signed in successfully."
    visit wikis_path
    click_link "Edit"
    expect(page).to have_content("Edit Wiki")
  end

  scenario 'User is not logged in, should not be able to edit a public wiki' do
    visit wikis_path
    expect(page).to_not have_content "Edit"
  end
end


feature 'User creates a private wiki', %q{
  As a premium user of the site
  When I am logged in
  I can create private wikis
} do

  given(:premium_user) { FactoryGirl.create(:user, role: 'premium' ) }
  given(:user) { FactoryGirl.create(:user ) }

  scenario 'User, with Premium Account, can create a private wiki' do
    login(premium_user)
    visit wikis_path
    click_link "New Wiki"
    fill_in "Title", with: "Premo Wiki"
    fill_in "Body",  with: "This should by the body of a premium Wiki."
    check("Private")
    click_button "Save"
    wiki = Wiki.last
    expect(wiki.private?).to be_true
  end

  scenario 'User, not with Premium Account, does not have option to create a private wiki' do
    login(user)
    visit wikis_path
    click_link "New Wiki"

    expect(page).to_not have_xpath("//label[@for='wiki_private']")
    expect(page).to_not have_xpath("//input[@id='wiki_private']")
  end

  scenario 'User is not logged in, should not be able to create a private wiki' do
    visit new_wiki_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end


feature 'User edits a private wiki', %q{
  As a premium user of the site
  When I am logged in
  I can edit private wikis
} do

  given(:premium_user) { FactoryGirl.create(:user, :with_post, role: 'premium' ) }
  given(:user) { FactoryGirl.create(:user, :with_post ) }

  scenario 'User is logged in as a premium user, edits a private wiki' do
    login(premium_user)
    visit wikis_path
    click_link "Edit"
  end

  scenario 'User is logged in, but is not a premium user, should not be able to edit a private wiki' do
    login(user)
    visit wikis_path
    click_link "Edit"
    expect(page).to_not have_xpath("//input[@id='wiki_private']")
  end

  scenario 'User is not logged in, should not be able to edit a private wiki' do
    visit wikis_path
    expect(page).to_not have_content "Edit"
  end
end
