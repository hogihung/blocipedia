require 'spec_helper'

describe User do
it { should have_many(:collaborators) }
it { should have_one(:subscription) }
  describe "scopes" do

    let(:current_user) { FactoryGirl.create(:user) }
    let(:users_list) { FactoryGirl.create_list(:user, 5) }

    describe "#potential_collaborators" do
      before do
        current_user
        users_list

      end

      it "should include users_list" do
         users_list.each do |user|
            expect(User.potential_collaborators(current_user)).to include(user)
         end
      end

      it "should have five users" do
        expect(User.potential_collaborators(current_user).count).to eql 5
      end

      it "should exclude current_user" do
        expect(User.potential_collaborators(current_user)).to_not include(current_user)
      end
    end
  end


  describe "#collaborates_on?" do
    let(:owner) { FactoryGirl.create(:user, :with_post) }
    let(:collaborator) do
      FactoryGirl.create(:user)

    end

    before(:each) do
      owner; collaborator;
      collaborator.collaborators.build(wiki: Wiki.first).save
    end

    it { expect(owner.collaborates_on?(Wiki.first)).to be_false }
    it { expect(collaborator.collaborates_on?(Wiki.first)).to be_true }


  end
end
