require 'spec_helper'

describe Wiki do
  it 'is valid with title, body and user_id' do
    wiki = Wiki.new(
      title: 'My Wiki Title',
      body: "This is the body of my wiki",
      user_id: 1,
      private: false)
    expect(wiki).to be_valid
  end

  it 'is invalid without a title' do
    expect(Wiki.new(title: nil)).to have(1).errors_on(:title)
  end

  it 'is invalid without a body' do
    expect(Wiki.new(body: nil)).to have(1).errors_on(:body)
  end

  it 'is invalid without a user_id' do
    expect(Wiki.new(user_id: nil)).to have(1).errors_on(:user_id)
  end


  # it 'is valid with private attribute if premium user' do
  #   login(@user)
  #   @user.premium = true
  #   @user.save

  #   wiki = Wiki.new(
  #     title: 'My Wiki Title',
  #     body: "This is the body of my wiki",
  #     user_id: 1,
  #     private: true)

  #   expect(wiki).to be_valid
  # end

  # it 'is invalid with private attribute if not a premium user'
end
