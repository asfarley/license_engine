class SetExpiryForLicenses < ActiveRecord::Migration[6.0]
  def change
    License.find_each do |license|
      license.expiry_date = license.company.license_expiration
      license.save!
    end
  end
end
