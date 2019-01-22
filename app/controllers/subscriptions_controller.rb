class SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.find_or_create_by(
        endpoint: params[:endpoint]
    ) do |s|
      s.user   = current_user
      s.p256dh =  params[:p256dh]
      s.auth   = params[:auth]
    end
    subscription.update(user: current_user)
    render json: {status: 'ok', code: 200, content: {}}
  end
end
