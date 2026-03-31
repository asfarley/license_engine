class SetLicensesCheckedOutNull < ActiveRecord::Migration[6.0]
  def change
    License.where(checkedout: nil).update_all(checkedout: false)
    change_column_null :licenses, :checkedout, false
  end
end
