class LicensesController < ApplicationController
  before_action :set_license, only: [:show, :edit, :update, :destroy, :checkout, :checkin]
  before_action :authenticate_user!
  before_action :set_company, only: [:bulk_edit, :bulk_update]

  # GET /licenses
  # GET /licenses.json
  def index
    authorize License
    if current_user.has_role? :admin
      @licenses = License.all
    else
      @licenses = current_user.licenses.sort_by(&:name)
    end
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
    authorize @license
  end

  # GET /licenses/new
  def new
    authorize License
    @license = License.new
    @license.expiry_date = Date.today + 1.year
  end

  # GET /licenses/1/edit
  def edit
    authorize License
  end

  def checkout
    available = @license.available()
    if not available
      respond_to do |format|
        flash.alert = 'Company licenses have expired; please contact your administrator.'
        flash.keep
        format.html { redirect_to action: 'index' }
        format.json { render json: {error: 'Company licenses have expired; please contact your administrator.'} }
      end
      return
    else
      @license.user_id = current_user.id
      @license.checkedout = true
      current_user.last_checkout_time = DateTime.now
      current_user.save
      respond_to do |format|
        if @license.save
          format.html { redirect_to licenses_path, notice: 'License was successfully checked out.' }
          format.json { render :show, status: :ok, location: @license }
        else
          format.html { render :new }
          format.json { render json: @license.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def checkout_available
    valid_license_exists = current_user.company.has_available_license()
    if valid_license_exists == false
      respond_to do |format|
        flash.alert = 'No licenses available; please contact your administrator.'
        flash.keep
        format.html { redirect_to action: 'index'}
        format.json { render json: {error: 'No licenses available; please contact your administrator.'} }
      end
    else
      license = current_user.checkout_available_license()
      respond_to do |format|
        if license
          format.json { render json: license, status: :ok}
        else
          format.json { render json: {error: 'No licenses available. Contact your administrator to purchase a new seat.'} }
        end
      end
    end
  end

  def checkin
    @license.checkedout = false
    @license.user = nil

    respond_to do |format|
      if @license.save
        current_user.last_checkin_time = DateTime.now
        current_user.save
        format.html { redirect_to licenses_path, notice: 'License was successfully checked in.' }
        format.json { render :show, status: :ok, location: @license }
      else
        format.html { render :new }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  def validate
    respond_to do |format|
      if current_user.company.has_valid_license()
        format.json { render json: {"valid": true}, status: :ok}
      else
        format.json { render json: {"valid": false}, status: :ok}
      end
    end
  end

  # POST /licenses
  # POST /licenses.json
  def create
    authorize License
    @license = License.new(license_params)

    respond_to do |format|
      if @license.save
        format.html { redirect_to @license, notice: 'License was successfully created.' }
        format.json { render :show, status: :created, location: @license }
      else
        format.html { render :new }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /licenses/1
  # PATCH/PUT /licenses/1.json
  def update
    authorize License
    respond_to do |format|
      if @license.update(license_params)
        format.html { redirect_to @license, notice: 'License was successfully updated.' }
        format.json { render :show, status: :ok, location: @license }
      else
        format.html { render :edit }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    authorize License
    @license.destroy
    respond_to do |format|
      format.html { redirect_to licenses_url, notice: 'License was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def bulk_edit
    @licenses = @company.licenses
  end

  def bulk_update
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
    # Use callbacks to share common setup or constraints between actions.
  def set_license
    @license = License.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

    # Only allow a list of trusted parameters through.
  def license_params
    params.require(:license).permit(:name, :company_id, :license_type, :expiry_date)
  end

end
