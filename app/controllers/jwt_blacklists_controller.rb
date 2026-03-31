class JwtBlacklistsController < ApplicationController
  before_action :set_jwt_blacklist, only: [:show, :edit, :update, :destroy]

  # GET /jwt_blacklists
  # GET /jwt_blacklists.json
  def index
    @jwt_blacklists = JwtBlacklist.all
  end

  # GET /jwt_blacklists/1
  # GET /jwt_blacklists/1.json
  def show
  end

  # GET /jwt_blacklists/new
  def new
    @jwt_blacklist = JwtBlacklist.new
  end

  # GET /jwt_blacklists/1/edit
  def edit
  end

  # POST /jwt_blacklists
  # POST /jwt_blacklists.json
  def create
    @jwt_blacklist = JwtBlacklist.new(jwt_blacklist_params)

    respond_to do |format|
      if @jwt_blacklist.save
        format.html { redirect_to @jwt_blacklist, notice: 'Jwt blacklist was successfully created.' }
        format.json { render :show, status: :created, location: @jwt_blacklist }
      else
        format.html { render :new }
        format.json { render json: @jwt_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jwt_blacklists/1
  # PATCH/PUT /jwt_blacklists/1.json
  def update
    respond_to do |format|
      if @jwt_blacklist.update(jwt_blacklist_params)
        format.html { redirect_to @jwt_blacklist, notice: 'Jwt blacklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @jwt_blacklist }
      else
        format.html { render :edit }
        format.json { render json: @jwt_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jwt_blacklists/1
  # DELETE /jwt_blacklists/1.json
  def destroy
    @jwt_blacklist.destroy
    respond_to do |format|
      format.html { redirect_to jwt_blacklists_url, notice: 'Jwt blacklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jwt_blacklist
      @jwt_blacklist = JwtBlacklist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jwt_blacklist_params
      params.require(:jwt_blacklist).permit(:jti, :exp)
    end
end
