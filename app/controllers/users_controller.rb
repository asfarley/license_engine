class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:set_admin, :unset_admin, :edit, :destroy, :update]

  def index
    authorize User
    @users = User.all
  end

  def emails
    authorize User
    @users = User.all
  end

  def new
    authorize User
    @newuser = User.new
  end

  def create
    @newuser = User.create(user_params)
    respond_to do |format|
      if @newuser.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    authorize User
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User has been deleted.' }
      format.json { head :no_content }
    end
  end

  def set_admin
    authorize User
    @user.add_role(:admin)
    redirect_back fallback_location: index
  end

  def unset_admin
    authorize User
    if @user.id == current_user.id
      flash[:notice] = "Cannot unset admin for yourself."
    else
      @user.remove_role(:admin)
    end
    redirect_back fallback_location: index
  end

  def set_user
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    authorize User
    filter_params = user_params
    if user_params[:password].empty? and user_params[:password_confirmation].empty?
      filter_params = user_params.except(:password, :password_confirmation)
    end
    if @user.update(filter_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def user_params
    params.require(:user).permit(:email, :encrypted_password, :company_id, :password, :password_confirmation, :current_password)
  end

end
