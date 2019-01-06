module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :rescue500
    rescue_from ApplicationController::Forbidden, with: :rescue403
    rescue_from ApplicationController::IpAddressRejected, with: :rescue403
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404

    private

    def rescue403(e)
      @exception = e
      logger.error "---------------\n"
      logger.error e
      logger.error "---------------"
      render 'errors/forbidden', status: 403
    end

    def rescue404(e)
      @exception = e
      logger.error "---------------\n"
      logger.error e
      logger.error "---------------"
      render 'errors/not_found', status: 404
    end

    def rescue500(e)
      @exception = e
      logger.error "---------------\n"
      logger.error e
      logger.error "---------------"
      render 'errors/internal_server_error', status: 500
    end
  end
end
