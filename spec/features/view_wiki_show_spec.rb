require 'spec_helper'


feature "viewing the wiki page" do
  after(:each) do
    puts page.body if example.exception
  end

  given(:owner) { FactoryGirl.create(:user, :with_post) }
  given(:user) { FactoryGirl.create(:user) }
  given(:admin) { FactoryGirl.create(:admin_user) }
  given(:wiki) { owner.wikis.first }
  given(:collaborator) do
    user = FactoryGirl.create(:user)
    wiki.collaborators.build(user: user)
    user
  end


  background do
    owner; user; admin; wiki;
  end

  scenario "should be able to see wiki as a visitor" do
    visit root_path
    click_link 'Wikis'

    click_link wiki.title

    expect(page).to have_content(wiki.title)
    expect(page).to have_content(wiki.body)

    expect(page).not_to have_content("Add Collaborators to")
  end


  scenario "should be able to see wiki as a owner, and collab form" do
    login(owner)

    click_link 'Wikis'
    click_link wiki.title

    expect(page).to have_content(wiki.title)
    expect(page).to have_content(wiki.body)
    expect(page).to have_content("Add Collaborators to")

    User.potential_collaborators(owner).each do |collab|
      expect(page).to have_xpath("//table/tbody/tr/td", text: collab.name)
      expect(page).to have_xpath("//table/tbody/tr/td", text: collab.email)

      if collab.collaborates_on?(wiki)
        expect(page).to have_xpath("//table/tbody/tr[@id='user-#{collab.id}']/td/input[@checked='checked']")
      else
        expect(page).not_to have_xpath("//table/tbody/tr[@id='user-#{collab.id}']/td/input[@checked='checked']")
      end
    end

    expect(page).not_to have_xpath("//table/tbody/tr/td", text: owner.name)
    expect(page).not_to have_content(owner.email)



  end

  scenario "should be able to see wiki as a admin, and collab form" do
    login(admin)

    click_link 'Wikis'
    click_link wiki.title

    expect(page).to have_content(wiki.title)
    expect(page).to have_content(wiki.body)
    expect(page).to have_content("Add Collaborators to")

    User.potential_collaborators(owner).each do |collab|
      expect(page).to have_xpath("//table/tbody/tr/td", text: collab.name)
      expect(page).to have_xpath("//table/tbody/tr/td", text: collab.email)
    end

    expect(page).not_to have_xpath("//table/tbody/tr/td", text: owner.name)
    expect(page).not_to have_content(owner.email)

  end


  scenario "should be able to see wiki when logged in but not owner, and not collab form" do
    visit root_path
    click_link 'Wikis'

    click_link wiki.title

    expect(page).to have_content(wiki.title)
    expect(page).to have_content(wiki.body)

    expect(page).not_to have_content("Add Collaborators to")
  end


  scenario "Wiki owner should be able to add collaborators to a wiki." do
    login owner
    click_link 'Wikis'
    click_link wiki.title

    expect(page).to have_content("Add Collaborators to")
    expect(page).not_to have_xpath("//table/tbody/tr[@id='user-#{user.id}']/td/input[@checked='checked']")
    expect(page).not_to have_content("Wiki updated.")

    within("#user-#{user.id}") do
      check("wiki[user_ids][]")
    end
    click_button "Share Wiki"

    expect(page).to have_content("Wiki updated.")
    expect(page).to have_xpath("//table/tbody/tr[@id='user-#{user.id}']/td/input[@checked='checked']")
  end
end