class Wiki < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def should_generate_new_friendly_id?
    new_record?
  end

end
