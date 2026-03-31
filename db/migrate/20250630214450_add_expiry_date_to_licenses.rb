class AddExpiryDateToLicenses < ActiveRecord::Migration[6.0]
  def change
    add_column :licenses, :expiry_date, :date
    License.find_each do |license|
      license.expiry_date = license.company.license_expiration
      license.save!
    end
  end
end
