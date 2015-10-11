class SubscriptionsController < ApplicationController
    before_action :authenticate_user!

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

        #Customer created with a valid subscription
        #so, update Account model

        account = Account.find_by_email(current_user.email)
        account.stripe_plan_id = plan
        account.save!

        redirect_to :root, :notice => "Successfully subscribed to a plan"

     rescue => e 
        redirect_to :new_subscription, :flash => {:error => e.message }

    end
end
