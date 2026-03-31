class RemoveExpiryFromCustomers < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :expiry_date  
  end
end
