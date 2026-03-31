class AddLicenseExpirationToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :license_expiration, :date
  end
end
