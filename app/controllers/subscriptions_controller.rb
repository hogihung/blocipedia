class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
    authorize @subscription
  end

  def create
    begin
      Subscription.create!(user: current_user,
              stripe_cart_token: params[:stripeToken])
      flash[:notice] = "Sign up for Premium account successfull."
      redirect_to edit_user_registration_path
    rescue Exception => e
      flash[:alert] = "There was a problem upgrading to a Premium membership.  Please try again."
      render :new
      puts e.message
    end
  end

  def destroy
    @subscription = Subscription.find(params[:user_id])
    authorize @subscription
    if @subscription.destroy
      flash[:notice] = "Premium membership has been cancelled."
      redirect_to edit_user_registration_path
    else
      flash[:alert] = "There was an error cancelling your Premium membership."
      redirect_to edit_user_registration_path
    end
  end
end
