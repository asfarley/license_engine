module LicenseEngine
  class TelemetryTokensController < ApplicationController
    before_action :authenticate_engine!, except: [:create]
    before_action :set_telemetry_token, only: %i[show edit update destroy]
    skip_before_action :verify_authenticity_token, only: [:create]

    def index
      authorize_engine!(:view_telemetry)
      @telemetry_tokens = LicenseEngine::TelemetryToken.all
    end

    def show
      authorize_engine!(:view_telemetry, @telemetry_token)
    end

    def new
      authorize_engine!(:record_telemetry)
      @telemetry_token = LicenseEngine::TelemetryToken.new
    end

    def edit
      authorize_engine!(:record_telemetry, @telemetry_token)
    end

    def create
      authorize_engine!(:record_telemetry)

      filtered = telemetry_token_params.except(:external_actor_id, :external_actor_type)
      external_id   = telemetry_token_params[:external_actor_id]
      external_type = telemetry_token_params[:external_actor_type] || "User"

      if external_id.present?
        actor = LicenseEngine::Actor.find_by(external_id: external_id.to_s, external_type: external_type)
        if actor
          filtered[:actor_id]   = actor.id
          filtered[:company_id] ||= actor.company_id
        end
      end

      @telemetry_token = LicenseEngine::TelemetryToken.new(filtered)

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

    def update
      authorize_engine!(:record_telemetry, @telemetry_token)
      respond_to do |format|
        if @telemetry_token.update(telemetry_token_params.except(:external_actor_id, :external_actor_type))
          format.html { redirect_to telemetry_token_url(@telemetry_token), notice: "Telemetry token was successfully updated." }
          format.json { render :show, status: :ok, location: @telemetry_token }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @telemetry_token.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize_engine!(:destroy_telemetry, @telemetry_token)
      @telemetry_token.destroy
      respond_to do |format|
        format.html { redirect_to telemetry_tokens_url, notice: "Telemetry token was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_telemetry_token
      @telemetry_token = LicenseEngine::TelemetryToken.find(params[:id])
    end

    def telemetry_token_params
      params.require(:telemetry_token).permit(
        :actor_id, :license_id, :company_id, :minutes, :clicks, :version,
        :external_actor_id, :external_actor_type
      )
    end
  end
end
