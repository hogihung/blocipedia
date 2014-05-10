class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
  end

  def create
    begin
      Subscription.create!(user: current_user,
              stripe_cart_token: params[:stripeToken])
      flash[:notice] = "Sign up for Premium account successfull."
      redirect_to edit_user_registration_path
    rescue Exception => e
      flash[:alert] = "You loose!"
      render :new
      puts e.message
    end
  end
end
