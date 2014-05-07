class Collaborator < ActiveRecord::Base
  belongs_to :wiki
  belongs_to :user

  validates :wiki_id, presence: true
  validates :user_id, presence: true
end