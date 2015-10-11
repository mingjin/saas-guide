class SubscriptionsController < ApplicationController
    before_filter :authenticate_user!
    
    def new
        @plans = Plan.all
    end

    def create
        ap "Inside create in subscription. See params hash"
        ap params

        # Get the credit card details submitted by the form
        token = params[:stripeToken]

        plan  = params[:plan][:stripe_id]
        email = current_user.email

        #Create a Customer
        customer = Stripe::Customer.create(
          :source => token,
          :plan   => plan,
          :email  => email
        )

    end
end
