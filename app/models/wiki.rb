class PremiumValidator < ActiveModel::Validator

  def validate(record)
    if record.private? and record.user.role.eql?('member')
     record.errors[:private] << 'User not permitted to create private wiki.'
    end
  end

end


class Wiki < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :collaborators
  has_many :users, :through => :collaborators

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  validates_with PremiumValidator

  def should_generate_new_friendly_id?
    new_record?
  end

end
