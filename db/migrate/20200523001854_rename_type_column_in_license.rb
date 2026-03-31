class RenameTypeColumnInLicense < ActiveRecord::Migration[6.0]
  def change
    rename_column :licenses, :type, :license_type
  end
end
