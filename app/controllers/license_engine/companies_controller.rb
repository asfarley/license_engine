module LicenseEngine
  class CompaniesController < ApplicationController
    before_action :authenticate_engine!
    before_action :set_company, only: [:show, :edit, :update, :destroy, :activate, :deactivate]

    def index
      authorize_engine!(:view_company)
      @companies = LicenseEngine::Company.all
    end

    def show
      authorize_engine!(:view_company, @company)
    end

    def new
      authorize_engine!(:create_company)
      @company = LicenseEngine::Company.new
    end

    def edit
      authorize_engine!(:update_company, @company)
    end

    def activate
      authorize_engine!(:activate_company, @company)
      @company.update!(active: true)
      redirect_back fallback_location: company_path(@company)
    end

    def deactivate
      authorize_engine!(:deactivate_company, @company)
      @company.update!(active: false)
      redirect_back fallback_location: company_path(@company)
    end

    def create
      authorize_engine!(:create_company)
      @company = LicenseEngine::Company.new(company_params)

      respond_to do |format|
        if @company.save
          format.html { redirect_to @company, notice: "Company was successfully created." }
          format.json { render :show, status: :created, location: @company }
        else
          format.html { render :new }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize_engine!(:update_company, @company)
      respond_to do |format|
        if @company.update(company_params)
          format.html { redirect_to @company, notice: "Company was successfully updated." }
          format.json { render :show, status: :ok, location: @company }
        else
          format.html { render :edit }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize_engine!(:destroy_company, @company)
      @company.destroy
      respond_to do |format|
        format.html { redirect_to companies_url, notice: "Company was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_company
      @company = LicenseEngine::Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
