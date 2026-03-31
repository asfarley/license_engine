class RemoveBinaryFromPrograms < ActiveRecord::Migration[6.0]
  def change
    remove_column :programs, :binary_input
  end
end
