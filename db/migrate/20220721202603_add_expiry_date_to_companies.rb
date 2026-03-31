class AddExpiryDateToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :expiry_date, :date
  end
end
