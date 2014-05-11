class Subscription < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :stripe_cart_token

end
