class AddCompanyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :company, foreign_key: true
    change_column_null :users, :company_id, false
  end
end
