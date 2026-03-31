class ChangeDataTypeForLicenseType < ActiveRecord::Migration[6.0]
  def change
    change_column :licenses, :license_type, 'integer USING CAST(license_type AS integer)'
  end
end
