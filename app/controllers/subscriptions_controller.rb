class SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.find_or_create_by(
        endpoint: params[:endpoint]
    ) do |subscription|
      subscription.user   = current_user
      subscription.p256dh =  params[:p256dh]
      subscription.auth   = params[:auth]
    end
    subscription.update(user: current_user)
    render json: {status: 'ok', code: 200, content: {}}
  end
end
