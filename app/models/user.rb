class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :wikis
  has_many :collaborators
  has_many :collaborations, :through => :collaborators, source: :wiki

  #NEED SOME REWORK HERE - See screen shots from call with Charlie

  def premium?
    self.role.eql? "premium"
  end

  scope :potential_collaborators, ->(current) { where("id != ?", current.id) }

  def collaborates_on?(wiki)
    self.collaborations.include? wiki
  end
end
