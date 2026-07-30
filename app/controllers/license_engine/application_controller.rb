module LicenseEngine
  class ApplicationController < ActionController::Base
    include LicenseEngine::Authorization

    protect_from_forgery with: :exception, if: ->(c) { c.request.format != 'application/json' }
    protect_from_forgery with: :null_session, if: ->(c) { c.request.format == 'application/json' }

    rescue_from LicenseEngine::Authorization::NotAuthorized, with: :engine_not_authorized

    private

    def engine_not_authorized(exception)
      respond_to do |format|
        format.html do
          flash[:alert] = "You are not authorized to perform this action."
          redirect_to(request.referrer || main_app.root_path)
        end
        format.json { render json: { error: "not_authorized", permission: exception.permission }, status: :forbidden }
      end
    end
  end
end
