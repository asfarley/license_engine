class RemoveVslsSpecificFeatures < ActiveRecord::Migration[8.0]
  def change
    drop_table :programs
    remove_column :users, :last_compile_time, :datetime
    remove_column :users, :store_programs, :boolean
  end
end
