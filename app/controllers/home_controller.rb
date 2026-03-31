class HomeController < ApplicationController
  def index
  end

  def activity
    authorize User
    @active_users = User.recently_active_users
  end

  # GET /companies/status/1
  # GET /companies/status/1.json
  def status
    @company = current_user.company
    redirect_to no_company_path if @company.nil?
  end

  private

end
