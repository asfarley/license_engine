class AddTimesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_compile_time, :datetime
    add_column :users, :last_checkin_time, :datetime
    add_column :users, :last_checkout_time, :datetime
  end
end
