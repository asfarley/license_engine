class AddStorageOptionToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :store_programs, :boolean, default: false
  end
end
