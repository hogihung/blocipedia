class Wiki < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :collaborators
  has_many :collaborating_users, :through => :collaborators

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  #scope :current_user_or_public, -> { where(private: false, user_id: current_user.id) }

  def should_generate_new_friendly_id?
    new_record?
  end

end
