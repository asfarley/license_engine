class SetLicensesCheckedOutDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :licenses, :checkedout, false
  end
end
