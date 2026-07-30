module LicenseEngine
  class HomeController < ApplicationController
    before_action :authenticate_engine!

    def index
    end

    def status
      @company = actor_company
      redirect_to no_company_path if @company.nil?
    end

    def nocompany
    end

    def activity
      authorize_engine!(:view_activity)
      @active_actors = LicenseEngine::Actor.recently_active
    end
  end
end
