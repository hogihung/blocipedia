class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
    authorize @subscription
  end

  def create
    begin
      Subscription.create!(user: current_user,
              stripe_cart_token: params[:stripeToken])

      # ***********************************************
      # Is there a better way to do this?
      current_user.role = "Premium"
      current_user.save
      # ***********************************************

      flash[:notice] = "Sign up for Premium account successfull."
      redirect_to edit_user_registration_path
    rescue Exception => e
      flash[:alert] = "There was a problem upgrading to a Premium membership.  Please try again."
      render :new
      puts e.message
    end
  end

end