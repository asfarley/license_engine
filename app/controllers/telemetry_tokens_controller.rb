class TelemetryTokensController < ApplicationController
  before_action :set_telemetry_token, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /telemetry_tokens or /telemetry_tokens.json
  def index
    @telemetry_tokens = TelemetryToken.all
  end

  # GET /telemetry_tokens/1 or /telemetry_tokens/1.json
  def show
  end

  # GET /telemetry_tokens/new
  def new
    @telemetry_token = TelemetryToken.new
  end

  # GET /telemetry_tokens/1/edit
  def edit
  end

  # POST /telemetry_tokens or /telemetry_tokens.json
  def create
    user_email = telemetry_token_params[:user_email]
    filtered_params = telemetry_token_params.except(:user_email)
    filtered_params[:user_id] = User.find_by_email(user_email).id
    filtered_params[:company_id] = User.find(filtered_params[:user_id]).company_id
    @telemetry_token = TelemetryToken.new(filtered_params)

    respond_to do |format|
      if @telemetry_token.save
        format.html { redirect_to telemetry_token_url(@telemetry_token), notice: "Telemetry token was successfully created." }
        format.json { render :show, status: :created, location: @telemetry_token }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @telemetry_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /telemetry_tokens/1 or /telemetry_tokens/1.json
  def update
    respond_to do |format|
      if @telemetry_token.update(telemetry_token_params)
        format.html { redirect_to telemetry_token_url(@telemetry_token), notice: "Telemetry token was successfully updated." }
        format.json { render :show, status: :ok, location: @telemetry_token }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @telemetry_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /telemetry_tokens/1 or /telemetry_tokens/1.json
  def destroy
    @telemetry_token.destroy

    respond_to do |format|
      format.html { redirect_to telemetry_tokens_url, notice: "Telemetry token was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_telemetry_token
      @telemetry_token = TelemetryToken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def telemetry_token_params
      params.require(:telemetry_token).permit(:user_id, :license_id, :company_id, :minutes, :clicks, :user_email, :version)
    end
end
