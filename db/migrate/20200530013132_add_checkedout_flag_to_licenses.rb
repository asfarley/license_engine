class AddCheckedoutFlagToLicenses < ActiveRecord::Migration[6.0]
  def change
    add_column :licenses, :checkedout, :boolean
  end
end
