class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def edit
    authorize User
    super
  end



end
