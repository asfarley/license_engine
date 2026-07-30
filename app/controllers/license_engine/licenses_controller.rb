module LicenseEngine
  class LicensesController < ApplicationController
    before_action :authenticate_engine!
    before_action :set_license, only: [:show, :edit, :update, :destroy, :checkout, :checkin]
    before_action :set_company, only: [:bulk_edit, :bulk_update]

    def index
      authorize_engine!(:view_license)
      @licenses = policy_scoped_licenses.sort_by(&:name)
    end

    def show
      authorize_engine!(:view_license, @license)
    end

    def new
      authorize_engine!(:issue_license)
      @license = LicenseEngine::License.new(expiry_date: Date.today + 1.year)
    end

    def edit
      authorize_engine!(:issue_license, @license)
    end

    def checkout
      authorize_engine!(:checkout_license, @license)

      unless @license.available?
        respond_to do |format|
          flash.alert = "Company licenses have expired; please contact your administrator."
          flash.keep
          format.html { redirect_to action: "index" }
          format.json { render json: { error: "Company licenses have expired; please contact your administrator." } }
        end
        return
      end

      @license.actor = current_actor
      @license.checkedout = true

      respond_to do |format|
        if @license.save
          current_actor.touch_checkout!
          format.html { redirect_to licenses_path, notice: "License was successfully checked out." }
          format.json { render :show, status: :ok, location: @license }
        else
          format.html { render :new }
          format.json { render json: @license.errors, status: :unprocessable_entity }
        end
      end
    end

    def checkout_available
      authorize_engine!(:checkout_license)
      company = actor_company

      unless company&.has_available_license
        respond_to do |format|
          flash.alert = "No licenses available; please contact your administrator."
          flash.keep
          format.html { redirect_to action: "index" }
          format.json { render json: { error: "No licenses available; please contact your administrator." } }
        end
        return
      end

      license = current_actor.checkout_available_license
      respond_to do |format|
        if license
          format.json { render json: license, status: :ok }
        else
          format.json { render json: { error: "No licenses available. Contact your administrator to purchase a new seat." } }
        end
      end
    end

    def checkin
      authorize_engine!(:checkin_license, @license)

      @license.checkedout = false
      @license.actor = nil

      respond_to do |format|
        if @license.save
          current_actor&.touch_checkin!
          format.html { redirect_to licenses_path, notice: "License was successfully checked in." }
          format.json { render :show, status: :ok, location: @license }
        else
          format.html { render :new }
          format.json { render json: @license.errors, status: :unprocessable_entity }
        end
      end
    end

    def validate
      respond_to do |format|
        valid = actor_company&.has_valid_license || false
        format.json { render json: { valid: valid }, status: :ok }
      end
    end

    def create
      authorize_engine!(:issue_license)
      @license = LicenseEngine::License.new(license_params)

      respond_to do |format|
        if @license.save
          format.html { redirect_to @license, notice: "License was successfully created." }
          format.json { render :show, status: :created, location: @license }
        else
          format.html { render :new }
          format.json { render json: @license.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize_engine!(:issue_license, @license)
      respond_to do |format|
        if @license.update(license_params)
          format.html { redirect_to @license, notice: "License was successfully updated." }
          format.json { render :show, status: :ok, location: @license }
        else
          format.html { render :edit }
          format.json { render json: @license.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize_engine!(:revoke_license, @license)
      @license.destroy
      respond_to do |format|
        format.html { redirect_to licenses_url, notice: "License was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def bulk_edit
      authorize_engine!(:bulk_update_licenses, @company)
      @licenses = @company.licenses
    end

    def bulk_update
      authorize_engine!(:bulk_update_licenses, @company)
      selected_ids = params[:license_ids] || []

      if selected_ids.empty?
        redirect_to bulk_edit_company_licenses_path(@company), alert: "Please select at least one license."
        return
      end

      new_date = params[:expiry_date].presence
      if new_date.blank?
        redirect_to bulk_edit_company_licenses_path(@company), alert: "Please choose a new expiry date."
        return
      end

      @company.licenses.where(id: selected_ids).update_all(expiry_date: new_date)
      redirect_to company_path(@company), notice: "#{selected_ids.size} license(s) updated successfully."
    end

    private

    def set_license
      @license = LicenseEngine::License.find(params[:id])
    end

    def set_company
      @company = LicenseEngine::Company.find(params[:company_id])
    end

    def license_params
      params.require(:license).permit(:name, :company_id, :license_type, :expiry_date)
    end

    def policy_scoped_licenses
      company = actor_company
      return LicenseEngine::License.none unless can_engine?(:view_license) || company

      if can_engine?(:view_license) && company.nil?
        LicenseEngine::License.all
      elsif can_engine?(:view_license) && company
        LicenseEngine::License.where(company: company)
      else
        LicenseEngine::License.none
      end
    end
  end
end
