require 'spec_helper'

describe Subscription do
  it { should belong_to(:user) }
  it { should validate_presence_of(:stripe_cart_token) }
end
