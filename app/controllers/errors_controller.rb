class ErrorsController < ApplicationController
  def routing_error
    # raise ActionController::RoutingError,
    #   "No route matches #{request.path.inspect}"
    raise ActiveRecord::RecordNotFound
  end
end
